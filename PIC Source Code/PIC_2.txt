// Stepper motor module connections
sbit Stepper_pin1 at RD0_bit;
sbit Stepper_pin2 at RD1_bit;
sbit Stepper_pin3 at RD2_bit;
sbit Stepper_pin4 at RD3_bit;
sbit Stepper_pin1_Direction at TRISD0_bit;
sbit Stepper_pin2_Direction at TRISD1_bit;
sbit Stepper_pin3_Direction at TRISD2_bit;
sbit Stepper_pin4_Direction at TRISD3_bit;
// End stepper motor module connections

// Main
void main() {
 ADCON1 = 0x07;         // Configure AN pins as digital
 CMCON  = 0X07;         // Disable comparators
 OPTION_REG.INTEDG = 1; // Set Rising Edge Trigger for INT
 INTCON.GIE = 1;        // Enable The Global Interrupt
 INTCON.INTE = 1;       // Enable INT

 TRISA.F0 = 1;          // Makes RA0, RA1, RA2 an input pin
 TRISA.F1 = 1;          //
 TRISA.F2 = 1;          //
 TRISB.F0 = 1;          // Makes RB0 an input pin
 TRISC.F0 = 0;          // Makes RC0, RC1, RC3 an output pin
 TRISC.F1 = 0;          //
 TRISC.F2 = 0;          //

 PORTB = 0;             // Initial value of PORT B,C,D is zero
 PORTC = 0;             //
 PORTD = 0;             //

 Stepper_Init(8);    // Initialize stepper motor(20 steps/revoltion)
 stepper_speed(750); // Set stepper motor speed to 200 rpm

while (1)           // Endless loop
{

PORTC.F0 = 0; //Turns OFF relay 1
delay_ms(100);
PORTC.F1 = 0; //Turns OFF relay 2
delay_ms(100);
PORTC.F2 = 0; //Turns OFF relay 3
delay_ms(100);

while(PORTA.F0 == 0) {
PORTC.F0 = 1; //Turns ON relay 1
    delay_ms(100);

    if(PORTA.F1 == 0)
    {
    PORTC.F1 = 1; //Turns ON relay 2
    delay_ms(100);
    }

    else if(PORTA.F1 == 1)
    {
    PORTC.F1 = 0; //Turns OFF relay 2
    delay_ms(100);
    }

    else if(PORTA.F2 == 0)
    {
    PORTC.F2 = 1; //Turns ON relay 3
    delay_ms(100);
    }

    else if(PORTA.F2 == 1)
    {
    PORTC.F2 = 0; //Turns OFF relay 3
    delay_ms(100);
    }

    else{
    PORTC.F0 = 0; //Turns ON relay 1
    delay_ms(100);
    }

   }

   while(PORTA.F1 == 0)
   {
    PORTC.F1 = 1; //Turns ON relay 2
    delay_ms(100);

    if(PORTA.F0 == 0)
    {
    PORTC.F0 = 1; //Turns ON relay 1
    delay_ms(100);
    }

    else if(PORTA.F0 == 1)
    {
    PORTC.F0 = 0; //Turns OFF relay 1
    delay_ms(100);
    }

    else if(PORTA.F2 == 0)
    {
    PORTC.F2 = 1; //Turns ON relay 3
    delay_ms(100);
    }

    else if(PORTA.F2 == 1)
    {
    PORTC.F2 = 0; //Turns OFF relay 3
    delay_ms(100);
    }

    else{
    PORTC.F1 = 0; //Turns OFF relay 2
    delay_ms(100);
    }

   }

   while(PORTA.F2 == 0 && PORTA.F1 == 0 && PORTA.F0 == 0)
   {
    PORTC.F2 = 1; //Turns ON relay 3
    delay_ms(100);

    if(PORTA.F0 == 0)
    {
    PORTC.F0 = 1; //Turns ON relay 1
    delay_ms(100);
    }

    else if(PORTA.F0 == 1)
    {
    PORTC.F0 = 0; //Turns OFF relay 1
    delay_ms(100);
    }

    else if(PORTA.F1 == 0)
    {
    PORTC.F1 = 1; //Turns ON relay 2
    delay_ms(100);
    }

    else if(PORTA.F1 == 1)
    {
    PORTC.F1 = 0; //Turns OFF relay 2
    delay_ms(100);
    }

    else{
    PORTC.F2 = 0; //Turns OFF relay 3
    delay_ms(100);
    }
   }

   }
}

// Interrupt
void interrupt() { //  ISR
INTCON.INTF = 0; // Clear the interrupt 0 flag
Stepper_Step(45);
}
// End of Interrupt