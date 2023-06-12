#line 1 "D:/Documents/mikroC/PIC_1.c"

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


unsigned short read_ds1307(unsigned short address)
{
 unsigned short read_data;
 I2C1_Start();
 I2C1_Wr(0xD0);
 I2C1_Wr(address);
 I2C1_Repeated_Start();
 I2C1_Wr(0xD1);
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


write_ds1307(0,0x00);
write_ds1307(1,0x38);
write_ds1307(2,0x18);
write_ds1307(3,0x07);
write_ds1307(4,0x26);
write_ds1307(5,0x02);
write_ds1307(6,0x17);
write_ds1307(7,0x10);

}

const unsigned short TEMP_RESOLUTION = 12;

char *text = "000.0000";
unsigned temp;

void Display_Temperature(unsigned int temp2write) {
 const unsigned short RES_SHIFT = TEMP_RESOLUTION - 8;
 char temp_whole;
 unsigned int temp_fraction;

 if (temp2write & 0x8000) {
 text[0] = '-';
 temp2write = ~temp2write + 1;
 }

 temp_whole = temp2write >> RES_SHIFT ;

 if (temp_whole/100)
 text[0] = temp_whole/100 + 48;
 else
 text[0] = '0';

 text[1] = (temp_whole/10)%10 + 48;
 text[2] = temp_whole%10 + 48;


 temp_fraction = temp2write << (4-RES_SHIFT);
 temp_fraction &= 0x000F;
 temp_fraction *= 625;


 text[4] = temp_fraction/1000 + 48;
 text[5] = (temp_fraction/100)%10 + 48;
 text[6] = (temp_fraction/10)%10 + 48;
 text[7] = temp_fraction%10 + 48;


 Lcd_Out(2, 5, text);
}
char i;

void Temperature(){
 Ow_Reset(&PORTE, 2);
 Ow_Write(&PORTE, 2, 0xCC);
 Ow_Write(&PORTE, 2, 0x44);
 Delay_us(120);

 Ow_Reset(&PORTE, 2);
 Ow_Write(&PORTE, 2, 0xCC);
 Ow_Write(&PORTE, 2, 0xBE);

 temp = Ow_Read(&PORTE, 2);
 temp = (Ow_Read(&PORTE, 2) << 8) + temp;



 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1, 1, " Temperature:   ");


 Lcd_Chr(2,13,223);

 Lcd_Chr(2,14,'C');

 Display_Temperature(temp);
 Delay_ms(300);




}

void Water_Level(){
 int a;
 char txt[7];
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 TRISD = 0b00000010;
 T1CON = 0x10;

 for(i=0; i<10; i++){
 TMR1H = 0;
 TMR1L = 0;

 PORTD.F0 = 1;
 Delay_us(10);
 PORTD.F0 = 0;

 while(!PORTD.F1);
 T1CON.F0 = 1;
 while(PORTD.F1);
 T1CON.F0 = 0;

 a = (TMR1L | (TMR1H<<8));
 a = (a/2.5)/58.82;
 a = a + 1;
 a = 47 - a;

 if(a>=0 && a<=400){
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

I2C1_Init(100000);
PORTB = 0;
TRISB = 0;
TRISC = 0xFF;




sec=read_ds1307(0);
minute=read_ds1307(1);
hour=read_ds1307(2);
day=read_ds1307(3);
date=read_ds1307(4);
month=read_ds1307(5);
year=read_ds1307(6);


if(hour == 0x23 && minute == 0x35){
PORTA.F3 = 1;
delay_ms(300);
}


else if(hour == 0x23 && minute == 0x36){
PORTA.F0 = 0;
delay_ms(300);
}


else if(hour == 0x23 && minute == 0x37){
PORTA.F0 = 0;
delay_ms(300);
}


else if(hour == 0x23 && minute == 0x38){
PORTA.F0 = 0;
delay_ms(300);
}


else if(hour == 0x23 && minute == 0x39){
PORTA.F0 = 0;
delay_ms(300);
}


else if(hour == 0x23 && minute == 0x40){
PORTA.F0 = 0;
delay_ms(300);
PORTA.F1 = 0;
delay_ms(300);
}


else if(hour == 0x23 && minute == 0x41){
PORTA.F0 = 0;
delay_ms(300);
PORTA.F1 = 0;
delay_ms(300);
}


else if(hour == 0x23 && minute == 0x42){
PORTA.F0 = 1;
delay_ms(300);
PORTA.F1 = 0;
delay_ms(300);
}


else if(hour == 0x23 && minute == 0x43){
PORTA.F0 = 1;
delay_ms(300);
PORTA.F1 = 0;
delay_ms(300);
}


else if(hour == 0x23 && minute == 0x44){
PORTA.F0 = 1;
delay_ms(300);
PORTA.F1 = 1;
delay_ms(300);
}


else if(hour == 0x23 && minute == 0x45){
PORTA.F2 = 0;
delay_ms(300);
}


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
I2C1_Start();

I2C1_Wr(0xD0);
I2C1_Wr(address);
I2C1_Wr(w_data);
I2C1_Stop();
}

void main() {
 ADCON1 = 0x7A;

 CMCON = 0x07;

 Lcd_Init();


 do {
 for(i=0; i<10; i++) {
 Temperature();
 Delay_ms(300);
 }

 } while(1);
}
