// LCD module connections
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB3_bit;
sbit LCD_D5 at RB2_bit;
sbit LCD_D6 at RB1_bit;
sbit LCD_D7 at RB0_bit;
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB3_bit;
sbit LCD_D5_Direction at TRISB2_bit;
sbit LCD_D6_Direction at TRISB1_bit;
sbit LCD_D7_Direction at TRISB0_bit;
// End LCD module connections

unsigned short read_ds1307(unsigned short address)
{
  unsigned short read_data;
  I2C1_Start();
  I2C1_Wr(0xD0); //address 0x68 followed by direction bit (0 for write, 1 for read) 0x68 followed by 0 --> 0xD0
  I2C1_Wr(address);
  I2C1_Repeated_Start();
  I2C1_Wr(0xD1); //0x68 followed by 1 --> 0xD1
  read_data=I2C1_Rd(0);
  I2C1_Stop();
  return(read_data);
}

unsigned short read_ds1307(unsigned short address );
void write_ds1307(unsigned short address,unsigned short w_data);
unsigned short sec;
unsigned short minute;
unsigned short hour;
unsigned short hr;
unsigned short day;
unsigned short date;
unsigned short month;
unsigned short year;
unsigned short read_data;
char time[] = "00:00:00 ";
char ddate[11];

unsigned char BCD2UpperCh(unsigned char bcd);
unsigned char BCD2LowerCh(unsigned char bcd);

void Real_Time_Write(){

//Set Time
write_ds1307(0,0x00); //write sec
write_ds1307(1,0x38); //write min
write_ds1307(2,0x18); //write hour
write_ds1307(3,0x07); //write day of week
write_ds1307(4,0x26); // write date
write_ds1307(5,0x02); // write month
write_ds1307(6,0x17); // write year
write_ds1307(7,0x10); //SQWE output at 1 Hz

}

const unsigned short TEMP_RESOLUTION = 12;

char *text = "000.0000";
unsigned temp;

void Display_Temperature(unsigned int temp2write) {
  const unsigned short RES_SHIFT = TEMP_RESOLUTION - 8;
  char temp_whole;
  unsigned int temp_fraction;
  // Check if temperature is negative
  if (temp2write & 0x8000) {
     text[0] = '-';
     temp2write = ~temp2write + 1;
     }
  // Extract temp_whole
  temp_whole = temp2write >> RES_SHIFT ;
  // Convert temp_whole to characters
  if (temp_whole/100)
     text[0] = temp_whole/100  + 48;
  else
     text[0] = '0';

  text[1] = (temp_whole/10)%10 + 48;             // Extract tens digit
  text[2] =  temp_whole%10     + 48;             // Extract ones digit

  // Extract temp_fraction and convert it to unsigned int
  temp_fraction  = temp2write << (4-RES_SHIFT);
  temp_fraction &= 0x000F;
  temp_fraction *= 625;

  // Convert temp_fraction to characters
  text[4] =  temp_fraction/1000    + 48;         // Extract thousands digit
  text[5] = (temp_fraction/100)%10 + 48;         // Extract hundreds digit
  text[6] = (temp_fraction/10)%10  + 48;         // Extract tens digit
  text[7] =  temp_fraction%10      + 48;         // Extract ones digit

  // Print temperature on LCD
  Lcd_Out(2, 5, text);
}
char i;

void Temperature(){
        Ow_Reset(&PORTE, 2);                         // Onewire reset signal
        Ow_Write(&PORTE, 2, 0xCC);                   // Issue command SKIP_ROM
        Ow_Write(&PORTE, 2, 0x44);                   // Issue command CONVERT_T
        Delay_us(120);

        Ow_Reset(&PORTE, 2);
        Ow_Write(&PORTE, 2, 0xCC);                   // Issue command SKIP_ROM
        Ow_Write(&PORTE, 2, 0xBE);                   // Issue command READ_SCRATCHPAD

        temp =  Ow_Read(&PORTE, 2);
        temp = (Ow_Read(&PORTE, 2) << 8) + temp;

      //--- Format and display result on Lcd
      //LCDClear();
        Lcd_Cmd(_LCD_CLEAR);                           // Clear LCD
        Lcd_Cmd(_LCD_CURSOR_OFF);                      // Turn cursor off
        Lcd_Out(1, 1, " Temperature:   ");

      // Print degree character, 'C' for Centigrades
        Lcd_Chr(2,13,223);                             // Different LCD displays have different char code for degree
                                                 // If you see greek alpha letter try typing 178 instead of 223
        Lcd_Chr(2,14,'C');

        Display_Temperature(temp);
        Delay_ms(300);

        //if(temp > 30 || temp < 20){
        //PORTD.F0 = 1;   //TRIGGER HIGH
        //}
}

void Water_Level(){
        int a;
        char txt[7];
        Lcd_Cmd(_LCD_CLEAR);           // Clear display
        Lcd_Cmd(_LCD_CURSOR_OFF);      // Cursor off
        TRISD = 0b00000010;            //RD4 as Input PIN (ECHO)
        T1CON = 0x10;                  //Initialize Timer Module

              for(i=0; i<10; i++){
                       TMR1H = 0;      //Sets the Initial Value of Timer
                       TMR1L = 0;      //Sets the Initial Value of Timer

                       PORTD.F0 = 1;   //TRIGGER HIGH
                       Delay_us(10);   //10uS Delay
                       PORTD.F0 = 0;   //TRIGGER LOW

                       while(!PORTD.F1);//Waiting for Echo
                       T1CON.F0 = 1;    //Timer Starts
                       while(PORTD.F1); //Waiting for Echo goes LOW
                       T1CON.F0 = 0;    //Timer Stops

                       a = (TMR1L | (TMR1H<<8)); //Reads Timer Value
                       a = (a/2.5)/58.82; //Converts Time to Distance
                       a = a + 1; //Distance Calibration
                       a = 47 - a;

                       if(a>=0 && a<=400){ //Check whether the result is valid or not
                               IntToStr(a,txt);
                               Ltrim(txt);
                               Lcd_Cmd(_LCD_CLEAR);
                               Lcd_Out(1,1," Water Level: ");
                               Lcd_Out(2,5,txt);
                               Lcd_Out(2,8,"cm");
                       }
                       Delay_ms(400);
              }
}

void Real_Time(){

I2C1_Init(100000); //DS1307 I2C is running at 100KHz
PORTB = 0;
TRISB = 0;
TRISC = 0xFF;


//Real_Time_Write();

sec=read_ds1307(0); // read second
minute=read_ds1307(1); // read minute
hour=read_ds1307(2); // read hour
day=read_ds1307(3); // read day
date=read_ds1307(4); // read date
month=read_ds1307(5); // read month
year=read_ds1307(6); // read year

// Feeder Start
if(hour == 0x23 && minute == 0x35){
PORTA.F3 = 1;
delay_ms(300);
}

// Draining -> start
else if(hour == 0x23 && minute == 0x36){
PORTA.F0 = 0;
delay_ms(300);
}

// Draining -->
else if(hour == 0x23 && minute == 0x37){
PORTA.F0 = 0;
delay_ms(300);
}

// Draining --->
else if(hour == 0x23 && minute == 0x38){
PORTA.F0 = 0;
delay_ms(300);
}

// Draining ---->complete
else if(hour == 0x23 && minute == 0x39){
PORTA.F0 = 0;
delay_ms(300);
}

// Circulating -> start
else if(hour == 0x23 && minute == 0x40){
PORTA.F0 = 0;
delay_ms(300);
PORTA.F1 = 0;
delay_ms(300);
}

// circulating --> complete
else if(hour == 0x23 && minute == 0x41){
PORTA.F0 = 0;
delay_ms(300);
PORTA.F1 = 0;
delay_ms(300);
}

// Refilling -> start
else if(hour == 0x23 && minute == 0x42){
PORTA.F0 = 1;
delay_ms(300);
PORTA.F1 = 0;
delay_ms(300);
}

// Refilling -->
else if(hour == 0x23 && minute == 0x43){
PORTA.F0 = 1;
delay_ms(300);
PORTA.F1 = 0;
delay_ms(300);
}

// Refilling ---> complete
else if(hour == 0x23 && minute == 0x44){
PORTA.F0 = 1;
delay_ms(300);
PORTA.F1 = 1;
delay_ms(300);
}

// Water to filtration -> start
else if(hour == 0x23 && minute == 0x45){
PORTA.F2 = 0;
delay_ms(300);
}

// Water to filtration --> complete
else if(hour == 0x23 && minute == 0x46){
PORTA.F2 = 1;
delay_ms(300);
}

else{
PORTA.F0 = 1;
delay_ms(300);
PORTA.F1 = 1;
delay_ms(300);
PORTA.F2 = 1;
delay_ms(300);
PORTA.F3 = 0;
delay_ms(300);
}
}

unsigned char BCD2UpperCh(unsigned char bcd)
{
return ((bcd >> 4) + '0');
}

unsigned char BCD2LowerCh(unsigned char bcd)
{
return ((bcd & 0x0F) + '0');
}
void write_ds1307(unsigned short address,unsigned short w_data)
{
I2C1_Start(); // issue I2C start signal
//address 0x68 followed by direction bit (0 for write, 1 for read) 0x68 followed by 0 --> 0xD0
I2C1_Wr(0xD0); // send byte via I2C (device address + W)
I2C1_Wr(address); // send byte (address of DS1307 location)
I2C1_Wr(w_data); // send data (data to be written)
I2C1_Stop(); // issue I2C stop signal
}

void main() {
  //ADCON1 = 0x7A; //Configure AN Pins.
  ADCON1 = 0x07;         // Configure AN pins as digital
  CMCON = 0x07;  // To turn off comparators
  
  Lcd_Init();    // Initialize LCD

  //--- Main loop
  do {
               for(i=0; i<10; i++) {
               Temperature();
               Delay_ms(300);
               }
               
  } while(1);
}