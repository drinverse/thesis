
_main:

;PIC_2.c,13 :: 		void main() {
;PIC_2.c,14 :: 		ADCON1 = 0x07;         // Configure AN pins as digital
	MOVLW      7
	MOVWF      ADCON1+0
;PIC_2.c,15 :: 		CMCON  = 0X07;         // Disable comparators
	MOVLW      7
	MOVWF      CMCON+0
;PIC_2.c,16 :: 		OPTION_REG.INTEDG = 1; // Set Rising Edge Trigger for INT
	BSF        OPTION_REG+0, 6
;PIC_2.c,17 :: 		INTCON.GIE = 1;        // Enable The Global Interrupt
	BSF        INTCON+0, 7
;PIC_2.c,18 :: 		INTCON.INTE = 1;       // Enable INT
	BSF        INTCON+0, 4
;PIC_2.c,20 :: 		TRISA.F0 = 1;          // Makes PORT A an input pin
	BSF        TRISA+0, 0
;PIC_2.c,21 :: 		TRISA.F1 = 1;          // Makes PORT A an input pin
	BSF        TRISA+0, 1
;PIC_2.c,22 :: 		TRISA.F2 = 1;          // Makes PORT A an input pin
	BSF        TRISA+0, 2
;PIC_2.c,23 :: 		TRISB.F0 = 1;          // Makes PORT B an input pin
	BSF        TRISB+0, 0
;PIC_2.c,24 :: 		TRISC.F0 = 0;          // Makes PORT C an output pin
	BCF        TRISC+0, 0
;PIC_2.c,25 :: 		TRISC.F1 = 0;          // Makes PORT C an output pin
	BCF        TRISC+0, 1
;PIC_2.c,26 :: 		TRISC.F2 = 0;          // Makes PORT C an output pin
	BCF        TRISC+0, 2
;PIC_2.c,28 :: 		PORTB = 0;
	CLRF       PORTB+0
;PIC_2.c,29 :: 		PORTD = 0;          // Initial value of PORT D is zero
	CLRF       PORTD+0
;PIC_2.c,30 :: 		PORTC = 0;          // Initial value of PORT D is zero
	CLRF       PORTC+0
;PIC_2.c,32 :: 		Stepper_Init(8);    // Initialize stepper motor(20 steps/revoltion)
	MOVLW      8
	MOVWF      FARG_Stepper_Init_steps+0
	MOVLW      0
	MOVWF      FARG_Stepper_Init_steps+1
	CALL       _Stepper_Init+0
;PIC_2.c,33 :: 		stepper_speed(750); // Set stepper motor speed to 200 rpm
	MOVLW      238
	MOVWF      FARG_Stepper_Speed_whatSpeed+0
	MOVLW      2
	MOVWF      FARG_Stepper_Speed_whatSpeed+1
	CALL       _Stepper_Speed+0
;PIC_2.c,35 :: 		while (1)           // Endless loop
L_main0:
;PIC_2.c,38 :: 		PORTC.F0 = 0; //Turns OFF relay 1
	BCF        PORTC+0, 0
;PIC_2.c,39 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
	DECFSZ     R11+0, 1
	GOTO       L_main2
	NOP
	NOP
;PIC_2.c,40 :: 		PORTC.F1 = 0; //Turns OFF relay 2
	BCF        PORTC+0, 1
;PIC_2.c,41 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	DECFSZ     R12+0, 1
	GOTO       L_main3
	DECFSZ     R11+0, 1
	GOTO       L_main3
	NOP
	NOP
;PIC_2.c,42 :: 		PORTC.F2 = 0; //Turns OFF relay 3
	BCF        PORTC+0, 2
;PIC_2.c,43 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
	DECFSZ     R12+0, 1
	GOTO       L_main4
	DECFSZ     R11+0, 1
	GOTO       L_main4
	NOP
	NOP
;PIC_2.c,45 :: 		while(PORTA.F0 == 0)
L_main5:
	BTFSC      PORTA+0, 0
	GOTO       L_main6
;PIC_2.c,47 :: 		PORTC.F0 = 1; //Turns ON relay 1
	BSF        PORTC+0, 0
;PIC_2.c,48 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	DECFSZ     R11+0, 1
	GOTO       L_main7
	NOP
	NOP
;PIC_2.c,50 :: 		if(PORTA.F1 == 0)
	BTFSC      PORTA+0, 1
	GOTO       L_main8
;PIC_2.c,52 :: 		PORTC.F1 = 1; //Turns ON relay 2
	BSF        PORTC+0, 1
;PIC_2.c,53 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	DECFSZ     R11+0, 1
	GOTO       L_main9
	NOP
	NOP
;PIC_2.c,54 :: 		}
	GOTO       L_main10
L_main8:
;PIC_2.c,56 :: 		else if(PORTA.F1 == 1)
	BTFSS      PORTA+0, 1
	GOTO       L_main11
;PIC_2.c,58 :: 		PORTC.F1 = 0; //Turns OFF relay 2
	BCF        PORTC+0, 1
;PIC_2.c,59 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main12:
	DECFSZ     R13+0, 1
	GOTO       L_main12
	DECFSZ     R12+0, 1
	GOTO       L_main12
	DECFSZ     R11+0, 1
	GOTO       L_main12
	NOP
	NOP
;PIC_2.c,60 :: 		}
	GOTO       L_main13
L_main11:
;PIC_2.c,62 :: 		else if(PORTA.F2 == 0)
	BTFSC      PORTA+0, 2
	GOTO       L_main14
;PIC_2.c,64 :: 		PORTC.F2 = 1; //Turns ON relay 3
	BSF        PORTC+0, 2
;PIC_2.c,65 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main15:
	DECFSZ     R13+0, 1
	GOTO       L_main15
	DECFSZ     R12+0, 1
	GOTO       L_main15
	DECFSZ     R11+0, 1
	GOTO       L_main15
	NOP
	NOP
;PIC_2.c,66 :: 		}
	GOTO       L_main16
L_main14:
;PIC_2.c,68 :: 		else if(PORTA.F2 == 1)
	BTFSS      PORTA+0, 2
	GOTO       L_main17
;PIC_2.c,70 :: 		PORTC.F2 = 0; //Turns OFF relay 3
	BCF        PORTC+0, 2
;PIC_2.c,71 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main18:
	DECFSZ     R13+0, 1
	GOTO       L_main18
	DECFSZ     R12+0, 1
	GOTO       L_main18
	DECFSZ     R11+0, 1
	GOTO       L_main18
	NOP
	NOP
;PIC_2.c,72 :: 		}
	GOTO       L_main19
L_main17:
;PIC_2.c,75 :: 		PORTC.F0 = 0; //Turns ON relay 1
	BCF        PORTC+0, 0
;PIC_2.c,76 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main20:
	DECFSZ     R13+0, 1
	GOTO       L_main20
	DECFSZ     R12+0, 1
	GOTO       L_main20
	DECFSZ     R11+0, 1
	GOTO       L_main20
	NOP
	NOP
;PIC_2.c,77 :: 		}
L_main19:
L_main16:
L_main13:
L_main10:
;PIC_2.c,79 :: 		}
	GOTO       L_main5
L_main6:
;PIC_2.c,81 :: 		while(PORTA.F1 == 0)
L_main21:
	BTFSC      PORTA+0, 1
	GOTO       L_main22
;PIC_2.c,83 :: 		PORTC.F1 = 1; //Turns ON relay 2
	BSF        PORTC+0, 1
;PIC_2.c,84 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main23:
	DECFSZ     R13+0, 1
	GOTO       L_main23
	DECFSZ     R12+0, 1
	GOTO       L_main23
	DECFSZ     R11+0, 1
	GOTO       L_main23
	NOP
	NOP
;PIC_2.c,86 :: 		if(PORTA.F0 == 0)
	BTFSC      PORTA+0, 0
	GOTO       L_main24
;PIC_2.c,88 :: 		PORTC.F0 = 1; //Turns ON relay 1
	BSF        PORTC+0, 0
;PIC_2.c,89 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main25:
	DECFSZ     R13+0, 1
	GOTO       L_main25
	DECFSZ     R12+0, 1
	GOTO       L_main25
	DECFSZ     R11+0, 1
	GOTO       L_main25
	NOP
	NOP
;PIC_2.c,90 :: 		}
	GOTO       L_main26
L_main24:
;PIC_2.c,92 :: 		else if(PORTA.F0 == 1)
	BTFSS      PORTA+0, 0
	GOTO       L_main27
;PIC_2.c,94 :: 		PORTC.F0 = 0; //Turns OFF relay 1
	BCF        PORTC+0, 0
;PIC_2.c,95 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main28:
	DECFSZ     R13+0, 1
	GOTO       L_main28
	DECFSZ     R12+0, 1
	GOTO       L_main28
	DECFSZ     R11+0, 1
	GOTO       L_main28
	NOP
	NOP
;PIC_2.c,96 :: 		}
	GOTO       L_main29
L_main27:
;PIC_2.c,98 :: 		else if(PORTA.F2 == 0)
	BTFSC      PORTA+0, 2
	GOTO       L_main30
;PIC_2.c,100 :: 		PORTC.F2 = 1; //Turns ON relay 3
	BSF        PORTC+0, 2
;PIC_2.c,101 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main31:
	DECFSZ     R13+0, 1
	GOTO       L_main31
	DECFSZ     R12+0, 1
	GOTO       L_main31
	DECFSZ     R11+0, 1
	GOTO       L_main31
	NOP
	NOP
;PIC_2.c,102 :: 		}
	GOTO       L_main32
L_main30:
;PIC_2.c,104 :: 		else if(PORTA.F2 == 1)
	BTFSS      PORTA+0, 2
	GOTO       L_main33
;PIC_2.c,106 :: 		PORTC.F2 = 0; //Turns OFF relay 3
	BCF        PORTC+0, 2
;PIC_2.c,107 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main34:
	DECFSZ     R13+0, 1
	GOTO       L_main34
	DECFSZ     R12+0, 1
	GOTO       L_main34
	DECFSZ     R11+0, 1
	GOTO       L_main34
	NOP
	NOP
;PIC_2.c,108 :: 		}
	GOTO       L_main35
L_main33:
;PIC_2.c,111 :: 		PORTC.F1 = 0; //Turns OFF relay 2
	BCF        PORTC+0, 1
;PIC_2.c,112 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main36:
	DECFSZ     R13+0, 1
	GOTO       L_main36
	DECFSZ     R12+0, 1
	GOTO       L_main36
	DECFSZ     R11+0, 1
	GOTO       L_main36
	NOP
	NOP
;PIC_2.c,113 :: 		}
L_main35:
L_main32:
L_main29:
L_main26:
;PIC_2.c,115 :: 		}
	GOTO       L_main21
L_main22:
;PIC_2.c,117 :: 		while(PORTA.F2 == 0 && PORTA.F1 == 0 && PORTA.F0 == 0)
L_main37:
	BTFSC      PORTA+0, 2
	GOTO       L_main38
	BTFSC      PORTA+0, 1
	GOTO       L_main38
	BTFSC      PORTA+0, 0
	GOTO       L_main38
L__main55:
;PIC_2.c,119 :: 		PORTC.F2 = 1; //Turns ON relay 3
	BSF        PORTC+0, 2
;PIC_2.c,120 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main41:
	DECFSZ     R13+0, 1
	GOTO       L_main41
	DECFSZ     R12+0, 1
	GOTO       L_main41
	DECFSZ     R11+0, 1
	GOTO       L_main41
	NOP
	NOP
;PIC_2.c,122 :: 		if(PORTA.F0 == 0)
	BTFSC      PORTA+0, 0
	GOTO       L_main42
;PIC_2.c,124 :: 		PORTC.F0 = 1; //Turns ON relay 1
	BSF        PORTC+0, 0
;PIC_2.c,125 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main43:
	DECFSZ     R13+0, 1
	GOTO       L_main43
	DECFSZ     R12+0, 1
	GOTO       L_main43
	DECFSZ     R11+0, 1
	GOTO       L_main43
	NOP
	NOP
;PIC_2.c,126 :: 		}
	GOTO       L_main44
L_main42:
;PIC_2.c,128 :: 		else if(PORTA.F0 == 1)
	BTFSS      PORTA+0, 0
	GOTO       L_main45
;PIC_2.c,130 :: 		PORTC.F0 = 0; //Turns OFF relay 1
	BCF        PORTC+0, 0
;PIC_2.c,131 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main46:
	DECFSZ     R13+0, 1
	GOTO       L_main46
	DECFSZ     R12+0, 1
	GOTO       L_main46
	DECFSZ     R11+0, 1
	GOTO       L_main46
	NOP
	NOP
;PIC_2.c,132 :: 		}
	GOTO       L_main47
L_main45:
;PIC_2.c,134 :: 		else if(PORTA.F1 == 0)
	BTFSC      PORTA+0, 1
	GOTO       L_main48
;PIC_2.c,136 :: 		PORTC.F1 = 1; //Turns ON relay 2
	BSF        PORTC+0, 1
;PIC_2.c,137 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main49:
	DECFSZ     R13+0, 1
	GOTO       L_main49
	DECFSZ     R12+0, 1
	GOTO       L_main49
	DECFSZ     R11+0, 1
	GOTO       L_main49
	NOP
	NOP
;PIC_2.c,138 :: 		}
	GOTO       L_main50
L_main48:
;PIC_2.c,140 :: 		else if(PORTA.F1 == 1)
	BTFSS      PORTA+0, 1
	GOTO       L_main51
;PIC_2.c,142 :: 		PORTC.F1 = 0; //Turns OFF relay 2
	BCF        PORTC+0, 1
;PIC_2.c,143 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main52:
	DECFSZ     R13+0, 1
	GOTO       L_main52
	DECFSZ     R12+0, 1
	GOTO       L_main52
	DECFSZ     R11+0, 1
	GOTO       L_main52
	NOP
	NOP
;PIC_2.c,144 :: 		}
	GOTO       L_main53
L_main51:
;PIC_2.c,147 :: 		PORTC.F2 = 0; //Turns OFF relay 3
	BCF        PORTC+0, 2
;PIC_2.c,148 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main54:
	DECFSZ     R13+0, 1
	GOTO       L_main54
	DECFSZ     R12+0, 1
	GOTO       L_main54
	DECFSZ     R11+0, 1
	GOTO       L_main54
	NOP
	NOP
;PIC_2.c,149 :: 		}
L_main53:
L_main50:
L_main47:
L_main44:
;PIC_2.c,150 :: 		}
	GOTO       L_main37
L_main38:
;PIC_2.c,152 :: 		}
	GOTO       L_main0
;PIC_2.c,153 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;PIC_2.c,156 :: 		void interrupt() { //  ISR
;PIC_2.c,157 :: 		INTCON.INTF = 0; // Clear the interrupt 0 flag
	BCF        INTCON+0, 1
;PIC_2.c,158 :: 		Stepper_Step(45);
	MOVLW      45
	MOVWF      FARG_Stepper_Step_steps_to_move+0
	MOVLW      0
	MOVWF      FARG_Stepper_Step_steps_to_move+1
	CALL       _Stepper_Step+0
;PIC_2.c,159 :: 		}
L_end_interrupt:
L__interrupt58:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt
