#line 1 "D:/Documents/mikroC/PIC_2.c"

 sbit Stepper_pin1 at RD0_bit;
 sbit Stepper_pin2 at RD1_bit;
 sbit Stepper_pin3 at RD2_bit;
 sbit Stepper_pin4 at RD3_bit;
 sbit Stepper_pin1_Direction at TRISD0_bit;
 sbit Stepper_pin2_Direction at TRISD1_bit;
 sbit Stepper_pin3_Direction at TRISD2_bit;
 sbit Stepper_pin4_Direction at TRISD3_bit;



 void main() {
 ADCON1 = 0x07;
 CMCON = 0X07;
 OPTION_REG.INTEDG = 1;
 INTCON.GIE = 1;
 INTCON.INTE = 1;

 TRISA.F0 = 1;
 TRISA.F1 = 1;
 TRISA.F2 = 1;
 TRISB.F0 = 1;
 TRISC.F0 = 0;
 TRISC.F1 = 0;
 TRISC.F2 = 0;

 PORTB = 0;
 PORTD = 0;
 PORTC = 0;

 Stepper_Init(8);
 stepper_speed(750);

 while (1)
 {

 PORTC.F0 = 0;
 delay_ms(100);
 PORTC.F1 = 0;
 delay_ms(100);
 PORTC.F2 = 0;
 delay_ms(100);

 while(PORTA.F0 == 0)
 {
 PORTC.F0 = 1;
 delay_ms(100);

 if(PORTA.F1 == 0)
 {
 PORTC.F1 = 1;
 delay_ms(100);
 }

 else if(PORTA.F1 == 1)
 {
 PORTC.F1 = 0;
 delay_ms(100);
 }

 else if(PORTA.F2 == 0)
 {
 PORTC.F2 = 1;
 delay_ms(100);
 }

 else if(PORTA.F2 == 1)
 {
 PORTC.F2 = 0;
 delay_ms(100);
 }

 else{
 PORTC.F0 = 0;
 delay_ms(100);
 }

 }

 while(PORTA.F1 == 0)
 {
 PORTC.F1 = 1;
 delay_ms(100);

 if(PORTA.F0 == 0)
 {
 PORTC.F0 = 1;
 delay_ms(100);
 }

 else if(PORTA.F0 == 1)
 {
 PORTC.F0 = 0;
 delay_ms(100);
 }

 else if(PORTA.F2 == 0)
 {
 PORTC.F2 = 1;
 delay_ms(100);
 }

 else if(PORTA.F2 == 1)
 {
 PORTC.F2 = 0;
 delay_ms(100);
 }

 else{
 PORTC.F1 = 0;
 delay_ms(100);
 }

 }

 while(PORTA.F2 == 0 && PORTA.F1 == 0 && PORTA.F0 == 0)
 {
 PORTC.F2 = 1;
 delay_ms(100);

 if(PORTA.F0 == 0)
 {
 PORTC.F0 = 1;
 delay_ms(100);
 }

 else if(PORTA.F0 == 1)
 {
 PORTC.F0 = 0;
 delay_ms(100);
 }

 else if(PORTA.F1 == 0)
 {
 PORTC.F1 = 1;
 delay_ms(100);
 }

 else if(PORTA.F1 == 1)
 {
 PORTC.F1 = 0;
 delay_ms(100);
 }

 else{
 PORTC.F2 = 0;
 delay_ms(100);
 }
 }

 }
}


 void interrupt() {
 INTCON.INTF = 0;
 Stepper_Step(45);
 }
