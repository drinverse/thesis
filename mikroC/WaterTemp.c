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


void main() {
  ADCON1 = 0x7A; //Configure AN Pins.
  CMCON = 0x07;  // To turn off comparators

  Lcd_Init();    // Initialize LCD

  //--- Main loop
  do {

      //----Temperature Loop
      for(i=0; i<10; i++) {             // Loop 10 times
      //----Perform temperature reading
               Temperature();
               Delay_ms(300);
      }

  } while(1);
}