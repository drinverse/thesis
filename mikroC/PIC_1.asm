
_read_ds1307:

;PIC_1.c,16 :: 		unsigned short read_ds1307(unsigned short address)
;PIC_1.c,19 :: 		I2C1_Start();
	CALL       _I2C1_Start+0
;PIC_1.c,20 :: 		I2C1_Wr(0xD0); //address 0x68 followed by direction bit (0 for write, 1 for read) 0x68 followed by 0 --> 0xD0
	MOVLW      208
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;PIC_1.c,21 :: 		I2C1_Wr(address);
	MOVF       FARG_read_ds1307_address+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;PIC_1.c,22 :: 		I2C1_Repeated_Start();
	CALL       _I2C1_Repeated_Start+0
;PIC_1.c,23 :: 		I2C1_Wr(0xD1); //0x68 followed by 1 --> 0xD1
	MOVLW      209
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;PIC_1.c,24 :: 		read_data=I2C1_Rd(0);
	CLRF       FARG_I2C1_Rd_ack+0
	CALL       _I2C1_Rd+0
	MOVF       R0+0, 0
	MOVWF      read_ds1307_read_data_L0+0
;PIC_1.c,25 :: 		I2C1_Stop();
	CALL       _I2C1_Stop+0
;PIC_1.c,26 :: 		return(read_data);
	MOVF       read_ds1307_read_data_L0+0, 0
	MOVWF      R0+0
;PIC_1.c,27 :: 		}
L_end_read_ds1307:
	RETURN
; end of _read_ds1307

_Real_Time_Write:

;PIC_1.c,46 :: 		void Real_Time_Write(){
;PIC_1.c,49 :: 		write_ds1307(0,0x00); //write sec
	CLRF       FARG_write_ds1307_address+0
	CLRF       FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;PIC_1.c,50 :: 		write_ds1307(1,0x38); //write min
	MOVLW      1
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      56
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;PIC_1.c,51 :: 		write_ds1307(2,0x18); //write hour
	MOVLW      2
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      24
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;PIC_1.c,52 :: 		write_ds1307(3,0x07); //write day of week
	MOVLW      3
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      7
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;PIC_1.c,53 :: 		write_ds1307(4,0x26); // write date
	MOVLW      4
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      38
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;PIC_1.c,54 :: 		write_ds1307(5,0x02); // write month
	MOVLW      5
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      2
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;PIC_1.c,55 :: 		write_ds1307(6,0x17); // write year
	MOVLW      6
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      23
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;PIC_1.c,56 :: 		write_ds1307(7,0x10); //SQWE output at 1 Hz
	MOVLW      7
	MOVWF      FARG_write_ds1307_address+0
	MOVLW      16
	MOVWF      FARG_write_ds1307_w_data+0
	CALL       _write_ds1307+0
;PIC_1.c,58 :: 		}
L_end_Real_Time_Write:
	RETURN
; end of _Real_Time_Write

_Display_Temperature:

;PIC_1.c,65 :: 		void Display_Temperature(unsigned int temp2write) {
;PIC_1.c,70 :: 		if (temp2write & 0x8000) {
	BTFSS      FARG_Display_Temperature_temp2write+1, 7
	GOTO       L_Display_Temperature0
;PIC_1.c,71 :: 		text[0] = '-';
	MOVF       _text+0, 0
	MOVWF      FSR
	MOVLW      45
	MOVWF      INDF+0
;PIC_1.c,72 :: 		temp2write = ~temp2write + 1;
	COMF       FARG_Display_Temperature_temp2write+0, 1
	COMF       FARG_Display_Temperature_temp2write+1, 1
	INCF       FARG_Display_Temperature_temp2write+0, 1
	BTFSC      STATUS+0, 2
	INCF       FARG_Display_Temperature_temp2write+1, 1
;PIC_1.c,73 :: 		}
L_Display_Temperature0:
;PIC_1.c,75 :: 		temp_whole = temp2write >> RES_SHIFT ;
	MOVF       FARG_Display_Temperature_temp2write+0, 0
	MOVWF      R0+0
	MOVF       FARG_Display_Temperature_temp2write+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVF       R0+0, 0
	MOVWF      Display_Temperature_temp_whole_L0+0
;PIC_1.c,77 :: 		if (temp_whole/100)
	MOVLW      100
	MOVWF      R4+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Display_Temperature1
;PIC_1.c,78 :: 		text[0] = temp_whole/100  + 48;
	MOVLW      100
	MOVWF      R4+0
	MOVF       Display_Temperature_temp_whole_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       _text+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	GOTO       L_Display_Temperature2
L_Display_Temperature1:
;PIC_1.c,80 :: 		text[0] = '0';
	MOVF       _text+0, 0
	MOVWF      FSR
	MOVLW      48
	MOVWF      INDF+0
L_Display_Temperature2:
;PIC_1.c,82 :: 		text[1] = (temp_whole/10)%10 + 48;             // Extract tens digit
	INCF       _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       Display_Temperature_temp_whole_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;PIC_1.c,83 :: 		text[2] =  temp_whole%10     + 48;             // Extract ones digit
	MOVLW      2
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       Display_Temperature_temp_whole_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;PIC_1.c,86 :: 		temp_fraction  = temp2write << (4-RES_SHIFT);
	MOVF       FARG_Display_Temperature_temp2write+0, 0
	MOVWF      Display_Temperature_temp_fraction_L0+0
	MOVF       FARG_Display_Temperature_temp2write+1, 0
	MOVWF      Display_Temperature_temp_fraction_L0+1
;PIC_1.c,87 :: 		temp_fraction &= 0x000F;
	MOVLW      15
	ANDWF      FARG_Display_Temperature_temp2write+0, 0
	MOVWF      R0+0
	MOVF       FARG_Display_Temperature_temp2write+1, 0
	MOVWF      R0+1
	MOVLW      0
	ANDWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      Display_Temperature_temp_fraction_L0+0
	MOVF       R0+1, 0
	MOVWF      Display_Temperature_temp_fraction_L0+1
;PIC_1.c,88 :: 		temp_fraction *= 625;
	MOVLW      113
	MOVWF      R4+0
	MOVLW      2
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      Display_Temperature_temp_fraction_L0+0
	MOVF       R0+1, 0
	MOVWF      Display_Temperature_temp_fraction_L0+1
;PIC_1.c,91 :: 		text[4] =  temp_fraction/1000    + 48;         // Extract thousands digit
	MOVLW      4
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;PIC_1.c,92 :: 		text[5] = (temp_fraction/100)%10 + 48;         // Extract hundreds digit
	MOVLW      5
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       Display_Temperature_temp_fraction_L0+0, 0
	MOVWF      R0+0
	MOVF       Display_Temperature_temp_fraction_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;PIC_1.c,93 :: 		text[6] = (temp_fraction/10)%10  + 48;         // Extract tens digit
	MOVLW      6
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       Display_Temperature_temp_fraction_L0+0, 0
	MOVWF      R0+0
	MOVF       Display_Temperature_temp_fraction_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;PIC_1.c,94 :: 		text[7] =  temp_fraction%10      + 48;         // Extract ones digit
	MOVLW      7
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       Display_Temperature_temp_fraction_L0+0, 0
	MOVWF      R0+0
	MOVF       Display_Temperature_temp_fraction_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;PIC_1.c,97 :: 		Lcd_Out(2, 5, text);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PIC_1.c,98 :: 		}
L_end_Display_Temperature:
	RETURN
; end of _Display_Temperature

_Temperature:

;PIC_1.c,101 :: 		void Temperature(){
;PIC_1.c,102 :: 		Ow_Reset(&PORTE, 2);                         // Onewire reset signal
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;PIC_1.c,103 :: 		Ow_Write(&PORTE, 2, 0xCC);                   // Issue command SKIP_ROM
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      204
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;PIC_1.c,104 :: 		Ow_Write(&PORTE, 2, 0x44);                   // Issue command CONVERT_T
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      68
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;PIC_1.c,105 :: 		Delay_us(120);
	MOVLW      199
	MOVWF      R13+0
L_Temperature3:
	DECFSZ     R13+0, 1
	GOTO       L_Temperature3
	NOP
	NOP
;PIC_1.c,107 :: 		Ow_Reset(&PORTE, 2);
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;PIC_1.c,108 :: 		Ow_Write(&PORTE, 2, 0xCC);                   // Issue command SKIP_ROM
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      204
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;PIC_1.c,109 :: 		Ow_Write(&PORTE, 2, 0xBE);                   // Issue command READ_SCRATCHPAD
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      190
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;PIC_1.c,111 :: 		temp =  Ow_Read(&PORTE, 2);
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Read_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Read_pin+0
	CALL       _Ow_Read+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	CLRF       _temp+1
;PIC_1.c,112 :: 		temp = (Ow_Read(&PORTE, 2) << 8) + temp;
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Read_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Read_pin+0
	CALL       _Ow_Read+0
	MOVF       R0+0, 0
	MOVWF      R1+1
	CLRF       R1+0
	MOVF       R1+0, 0
	ADDWF      _temp+0, 1
	MOVF       R1+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _temp+1, 1
;PIC_1.c,116 :: 		Lcd_Cmd(_LCD_CLEAR);                           // Clear LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;PIC_1.c,117 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                      // Turn cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;PIC_1.c,118 :: 		Lcd_Out(1, 1, " Temperature:   ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_PIC_1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PIC_1.c,121 :: 		Lcd_Chr(2,13,223);                             // Different LCD displays have different char code for degree
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      223
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PIC_1.c,123 :: 		Lcd_Chr(2,14,'C');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      67
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PIC_1.c,125 :: 		Display_Temperature(temp);
	MOVF       _temp+0, 0
	MOVWF      FARG_Display_Temperature_temp2write+0
	MOVF       _temp+1, 0
	MOVWF      FARG_Display_Temperature_temp2write+1
	CALL       _Display_Temperature+0
;PIC_1.c,126 :: 		Delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Temperature4:
	DECFSZ     R13+0, 1
	GOTO       L_Temperature4
	DECFSZ     R12+0, 1
	GOTO       L_Temperature4
	DECFSZ     R11+0, 1
	GOTO       L_Temperature4
	NOP
	NOP
;PIC_1.c,131 :: 		}
L_end_Temperature:
	RETURN
; end of _Temperature

_Water_Level:

;PIC_1.c,133 :: 		void Water_Level(){
;PIC_1.c,136 :: 		Lcd_Cmd(_LCD_CLEAR);           // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;PIC_1.c,137 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);      // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;PIC_1.c,138 :: 		TRISD = 0b00000010;            //RD4 as Input PIN (ECHO)
	MOVLW      2
	MOVWF      TRISD+0
;PIC_1.c,139 :: 		T1CON = 0x10;                  //Initialize Timer Module
	MOVLW      16
	MOVWF      T1CON+0
;PIC_1.c,141 :: 		for(i=0; i<10; i++){
	CLRF       _i+0
L_Water_Level5:
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Water_Level6
;PIC_1.c,142 :: 		TMR1H = 0;      //Sets the Initial Value of Timer
	CLRF       TMR1H+0
;PIC_1.c,143 :: 		TMR1L = 0;      //Sets the Initial Value of Timer
	CLRF       TMR1L+0
;PIC_1.c,145 :: 		PORTD.F0 = 1;   //TRIGGER HIGH
	BSF        PORTD+0, 0
;PIC_1.c,146 :: 		Delay_us(10);   //10uS Delay
	MOVLW      16
	MOVWF      R13+0
L_Water_Level8:
	DECFSZ     R13+0, 1
	GOTO       L_Water_Level8
	NOP
;PIC_1.c,147 :: 		PORTD.F0 = 0;   //TRIGGER LOW
	BCF        PORTD+0, 0
;PIC_1.c,149 :: 		while(!PORTD.F1);//Waiting for Echo
L_Water_Level9:
	BTFSC      PORTD+0, 1
	GOTO       L_Water_Level10
	GOTO       L_Water_Level9
L_Water_Level10:
;PIC_1.c,150 :: 		T1CON.F0 = 1;    //Timer Starts
	BSF        T1CON+0, 0
;PIC_1.c,151 :: 		while(PORTD.F1); //Waiting for Echo goes LOW
L_Water_Level11:
	BTFSS      PORTD+0, 1
	GOTO       L_Water_Level12
	GOTO       L_Water_Level11
L_Water_Level12:
;PIC_1.c,152 :: 		T1CON.F0 = 0;    //Timer Stops
	BCF        T1CON+0, 0
;PIC_1.c,154 :: 		a = (TMR1L | (TMR1H<<8)); //Reads Timer Value
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      Water_Level_a_L0+0
	MOVF       R0+1, 0
	MOVWF      Water_Level_a_L0+1
;PIC_1.c,155 :: 		a = (a/2.5)/58.82; //Converts Time to Distance
	CALL       _int2double+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      128
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVLW      174
	MOVWF      R4+0
	MOVLW      71
	MOVWF      R4+1
	MOVLW      107
	MOVWF      R4+2
	MOVLW      132
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      Water_Level_a_L0+0
	MOVF       R0+1, 0
	MOVWF      Water_Level_a_L0+1
;PIC_1.c,156 :: 		a = a + 1; //Distance Calibration
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	MOVF       R0+0, 0
	MOVWF      Water_Level_a_L0+0
	MOVF       R0+1, 0
	MOVWF      Water_Level_a_L0+1
;PIC_1.c,157 :: 		a = 47 - a;
	MOVF       R0+0, 0
	SUBLW      47
	MOVWF      R2+0
	MOVF       R0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R2+1
	SUBWF      R2+1, 1
	MOVF       R2+0, 0
	MOVWF      Water_Level_a_L0+0
	MOVF       R2+1, 0
	MOVWF      Water_Level_a_L0+1
;PIC_1.c,159 :: 		if(a>=0 && a<=400){ //Check whether the result is valid or not
	MOVLW      128
	XORWF      R2+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Water_Level111
	MOVLW      0
	SUBWF      R2+0, 0
L__Water_Level111:
	BTFSS      STATUS+0, 0
	GOTO       L_Water_Level15
	MOVLW      128
	XORLW      1
	MOVWF      R0+0
	MOVLW      128
	XORWF      Water_Level_a_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Water_Level112
	MOVF       Water_Level_a_L0+0, 0
	SUBLW      144
L__Water_Level112:
	BTFSS      STATUS+0, 0
	GOTO       L_Water_Level15
L__Water_Level93:
;PIC_1.c,160 :: 		IntToStr(a,txt);
	MOVF       Water_Level_a_L0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       Water_Level_a_L0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      Water_Level_txt_L0+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;PIC_1.c,161 :: 		Ltrim(txt);
	MOVLW      Water_Level_txt_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;PIC_1.c,162 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;PIC_1.c,163 :: 		Lcd_Out(1,1," Water Level: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_PIC_1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PIC_1.c,164 :: 		Lcd_Out(2,5,txt);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      Water_Level_txt_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PIC_1.c,165 :: 		Lcd_Out(2,8,"cm");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_PIC_1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PIC_1.c,166 :: 		}
L_Water_Level15:
;PIC_1.c,167 :: 		Delay_ms(400);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_Water_Level16:
	DECFSZ     R13+0, 1
	GOTO       L_Water_Level16
	DECFSZ     R12+0, 1
	GOTO       L_Water_Level16
	DECFSZ     R11+0, 1
	GOTO       L_Water_Level16
	NOP
	NOP
;PIC_1.c,141 :: 		for(i=0; i<10; i++){
	INCF       _i+0, 1
;PIC_1.c,168 :: 		}
	GOTO       L_Water_Level5
L_Water_Level6:
;PIC_1.c,169 :: 		}
L_end_Water_Level:
	RETURN
; end of _Water_Level

_Real_Time:

;PIC_1.c,171 :: 		void Real_Time(){
;PIC_1.c,173 :: 		I2C1_Init(100000); //DS1307 I2C is running at 100KHz
	MOVLW      50
	MOVWF      SSPADD+0
	CALL       _I2C1_Init+0
;PIC_1.c,174 :: 		PORTB = 0;
	CLRF       PORTB+0
;PIC_1.c,175 :: 		TRISB = 0;
	CLRF       TRISB+0
;PIC_1.c,176 :: 		TRISC = 0xFF;
	MOVLW      255
	MOVWF      TRISC+0
;PIC_1.c,181 :: 		sec=read_ds1307(0); // read second
	CLRF       FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _sec+0
;PIC_1.c,182 :: 		minute=read_ds1307(1); // read minute
	MOVLW      1
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _minute+0
;PIC_1.c,183 :: 		hour=read_ds1307(2); // read hour
	MOVLW      2
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _hour+0
;PIC_1.c,184 :: 		day=read_ds1307(3); // read day
	MOVLW      3
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _day+0
;PIC_1.c,185 :: 		date=read_ds1307(4); // read date
	MOVLW      4
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _date+0
;PIC_1.c,186 :: 		month=read_ds1307(5); // read month
	MOVLW      5
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _month+0
;PIC_1.c,187 :: 		year=read_ds1307(6); // read year
	MOVLW      6
	MOVWF      FARG_read_ds1307_address+0
	CALL       _read_ds1307+0
	MOVF       R0+0, 0
	MOVWF      _year+0
;PIC_1.c,190 :: 		if(hour == 0x23 && minute == 0x35){
	MOVF       _hour+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time19
	MOVF       _minute+0, 0
	XORLW      53
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time19
L__Real_Time105:
;PIC_1.c,191 :: 		PORTA.F3 = 1;
	BSF        PORTA+0, 3
;PIC_1.c,192 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time20:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time20
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time20
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time20
	NOP
	NOP
;PIC_1.c,193 :: 		}
	GOTO       L_Real_Time21
L_Real_Time19:
;PIC_1.c,196 :: 		else if(hour == 0x23 && minute == 0x36){
	MOVF       _hour+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time24
	MOVF       _minute+0, 0
	XORLW      54
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time24
L__Real_Time104:
;PIC_1.c,197 :: 		PORTA.F0 = 0;
	BCF        PORTA+0, 0
;PIC_1.c,198 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time25:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time25
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time25
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time25
	NOP
	NOP
;PIC_1.c,199 :: 		}
	GOTO       L_Real_Time26
L_Real_Time24:
;PIC_1.c,202 :: 		else if(hour == 0x23 && minute == 0x37){
	MOVF       _hour+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time29
	MOVF       _minute+0, 0
	XORLW      55
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time29
L__Real_Time103:
;PIC_1.c,203 :: 		PORTA.F0 = 0;
	BCF        PORTA+0, 0
;PIC_1.c,204 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time30:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time30
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time30
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time30
	NOP
	NOP
;PIC_1.c,205 :: 		}
	GOTO       L_Real_Time31
L_Real_Time29:
;PIC_1.c,208 :: 		else if(hour == 0x23 && minute == 0x38){
	MOVF       _hour+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time34
	MOVF       _minute+0, 0
	XORLW      56
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time34
L__Real_Time102:
;PIC_1.c,209 :: 		PORTA.F0 = 0;
	BCF        PORTA+0, 0
;PIC_1.c,210 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time35:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time35
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time35
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time35
	NOP
	NOP
;PIC_1.c,211 :: 		}
	GOTO       L_Real_Time36
L_Real_Time34:
;PIC_1.c,214 :: 		else if(hour == 0x23 && minute == 0x39){
	MOVF       _hour+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time39
	MOVF       _minute+0, 0
	XORLW      57
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time39
L__Real_Time101:
;PIC_1.c,215 :: 		PORTA.F0 = 0;
	BCF        PORTA+0, 0
;PIC_1.c,216 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time40:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time40
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time40
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time40
	NOP
	NOP
;PIC_1.c,217 :: 		}
	GOTO       L_Real_Time41
L_Real_Time39:
;PIC_1.c,220 :: 		else if(hour == 0x23 && minute == 0x40){
	MOVF       _hour+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time44
	MOVF       _minute+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time44
L__Real_Time100:
;PIC_1.c,221 :: 		PORTA.F0 = 0;
	BCF        PORTA+0, 0
;PIC_1.c,222 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time45:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time45
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time45
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time45
	NOP
	NOP
;PIC_1.c,223 :: 		PORTA.F1 = 0;
	BCF        PORTA+0, 1
;PIC_1.c,224 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time46:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time46
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time46
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time46
	NOP
	NOP
;PIC_1.c,225 :: 		}
	GOTO       L_Real_Time47
L_Real_Time44:
;PIC_1.c,228 :: 		else if(hour == 0x23 && minute == 0x41){
	MOVF       _hour+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time50
	MOVF       _minute+0, 0
	XORLW      65
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time50
L__Real_Time99:
;PIC_1.c,229 :: 		PORTA.F0 = 0;
	BCF        PORTA+0, 0
;PIC_1.c,230 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time51:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time51
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time51
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time51
	NOP
	NOP
;PIC_1.c,231 :: 		PORTA.F1 = 0;
	BCF        PORTA+0, 1
;PIC_1.c,232 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time52:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time52
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time52
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time52
	NOP
	NOP
;PIC_1.c,233 :: 		}
	GOTO       L_Real_Time53
L_Real_Time50:
;PIC_1.c,236 :: 		else if(hour == 0x23 && minute == 0x42){
	MOVF       _hour+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time56
	MOVF       _minute+0, 0
	XORLW      66
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time56
L__Real_Time98:
;PIC_1.c,237 :: 		PORTA.F0 = 1;
	BSF        PORTA+0, 0
;PIC_1.c,238 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time57:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time57
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time57
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time57
	NOP
	NOP
;PIC_1.c,239 :: 		PORTA.F1 = 0;
	BCF        PORTA+0, 1
;PIC_1.c,240 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time58:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time58
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time58
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time58
	NOP
	NOP
;PIC_1.c,241 :: 		}
	GOTO       L_Real_Time59
L_Real_Time56:
;PIC_1.c,244 :: 		else if(hour == 0x23 && minute == 0x43){
	MOVF       _hour+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time62
	MOVF       _minute+0, 0
	XORLW      67
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time62
L__Real_Time97:
;PIC_1.c,245 :: 		PORTA.F0 = 1;
	BSF        PORTA+0, 0
;PIC_1.c,246 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time63:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time63
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time63
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time63
	NOP
	NOP
;PIC_1.c,247 :: 		PORTA.F1 = 0;
	BCF        PORTA+0, 1
;PIC_1.c,248 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time64:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time64
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time64
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time64
	NOP
	NOP
;PIC_1.c,249 :: 		}
	GOTO       L_Real_Time65
L_Real_Time62:
;PIC_1.c,252 :: 		else if(hour == 0x23 && minute == 0x44){
	MOVF       _hour+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time68
	MOVF       _minute+0, 0
	XORLW      68
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time68
L__Real_Time96:
;PIC_1.c,253 :: 		PORTA.F0 = 1;
	BSF        PORTA+0, 0
;PIC_1.c,254 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time69:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time69
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time69
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time69
	NOP
	NOP
;PIC_1.c,255 :: 		PORTA.F1 = 1;
	BSF        PORTA+0, 1
;PIC_1.c,256 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time70:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time70
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time70
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time70
	NOP
	NOP
;PIC_1.c,257 :: 		}
	GOTO       L_Real_Time71
L_Real_Time68:
;PIC_1.c,260 :: 		else if(hour == 0x23 && minute == 0x45){
	MOVF       _hour+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time74
	MOVF       _minute+0, 0
	XORLW      69
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time74
L__Real_Time95:
;PIC_1.c,261 :: 		PORTA.F2 = 0;
	BCF        PORTA+0, 2
;PIC_1.c,262 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time75:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time75
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time75
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time75
	NOP
	NOP
;PIC_1.c,263 :: 		}
	GOTO       L_Real_Time76
L_Real_Time74:
;PIC_1.c,266 :: 		else if(hour == 0x23 && minute == 0x46){
	MOVF       _hour+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time79
	MOVF       _minute+0, 0
	XORLW      70
	BTFSS      STATUS+0, 2
	GOTO       L_Real_Time79
L__Real_Time94:
;PIC_1.c,267 :: 		PORTA.F2 = 1;
	BSF        PORTA+0, 2
;PIC_1.c,268 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time80:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time80
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time80
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time80
	NOP
	NOP
;PIC_1.c,269 :: 		}
	GOTO       L_Real_Time81
L_Real_Time79:
;PIC_1.c,272 :: 		PORTA.F0 = 1;
	BSF        PORTA+0, 0
;PIC_1.c,273 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time82:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time82
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time82
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time82
	NOP
	NOP
;PIC_1.c,274 :: 		PORTA.F1 = 1;
	BSF        PORTA+0, 1
;PIC_1.c,275 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time83:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time83
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time83
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time83
	NOP
	NOP
;PIC_1.c,276 :: 		PORTA.F2 = 1;
	BSF        PORTA+0, 2
;PIC_1.c,277 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time84:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time84
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time84
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time84
	NOP
	NOP
;PIC_1.c,278 :: 		PORTA.F3 = 0;
	BCF        PORTA+0, 3
;PIC_1.c,279 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_Real_Time85:
	DECFSZ     R13+0, 1
	GOTO       L_Real_Time85
	DECFSZ     R12+0, 1
	GOTO       L_Real_Time85
	DECFSZ     R11+0, 1
	GOTO       L_Real_Time85
	NOP
	NOP
;PIC_1.c,280 :: 		}
L_Real_Time81:
L_Real_Time76:
L_Real_Time71:
L_Real_Time65:
L_Real_Time59:
L_Real_Time53:
L_Real_Time47:
L_Real_Time41:
L_Real_Time36:
L_Real_Time31:
L_Real_Time26:
L_Real_Time21:
;PIC_1.c,281 :: 		}
L_end_Real_Time:
	RETURN
; end of _Real_Time

_BCD2UpperCh:

;PIC_1.c,283 :: 		unsigned char BCD2UpperCh(unsigned char bcd)
;PIC_1.c,285 :: 		return ((bcd >> 4) + '0');
	MOVF       FARG_BCD2UpperCh_bcd+0, 0
	MOVWF      R0+0
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	MOVLW      48
	ADDWF      R0+0, 1
;PIC_1.c,286 :: 		}
L_end_BCD2UpperCh:
	RETURN
; end of _BCD2UpperCh

_BCD2LowerCh:

;PIC_1.c,288 :: 		unsigned char BCD2LowerCh(unsigned char bcd)
;PIC_1.c,290 :: 		return ((bcd & 0x0F) + '0');
	MOVLW      15
	ANDWF      FARG_BCD2LowerCh_bcd+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 1
;PIC_1.c,291 :: 		}
L_end_BCD2LowerCh:
	RETURN
; end of _BCD2LowerCh

_write_ds1307:

;PIC_1.c,292 :: 		void write_ds1307(unsigned short address,unsigned short w_data)
;PIC_1.c,294 :: 		I2C1_Start(); // issue I2C start signal
	CALL       _I2C1_Start+0
;PIC_1.c,296 :: 		I2C1_Wr(0xD0); // send byte via I2C (device address + W)
	MOVLW      208
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;PIC_1.c,297 :: 		I2C1_Wr(address); // send byte (address of DS1307 location)
	MOVF       FARG_write_ds1307_address+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;PIC_1.c,298 :: 		I2C1_Wr(w_data); // send data (data to be written)
	MOVF       FARG_write_ds1307_w_data+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;PIC_1.c,299 :: 		I2C1_Stop(); // issue I2C stop signal
	CALL       _I2C1_Stop+0
;PIC_1.c,300 :: 		}
L_end_write_ds1307:
	RETURN
; end of _write_ds1307

_main:

;PIC_1.c,302 :: 		void main() {
;PIC_1.c,303 :: 		ADCON1 = 0x7A; //Configure AN Pins.
	MOVLW      122
	MOVWF      ADCON1+0
;PIC_1.c,305 :: 		CMCON = 0x07;  // To turn off comparators
	MOVLW      7
	MOVWF      CMCON+0
;PIC_1.c,307 :: 		Lcd_Init();    // Initialize LCD
	CALL       _Lcd_Init+0
;PIC_1.c,310 :: 		do {
L_main86:
;PIC_1.c,311 :: 		for(i=0; i<10; i++) {
	CLRF       _i+0
L_main89:
	MOVLW      10
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main90
;PIC_1.c,312 :: 		Temperature();
	CALL       _Temperature+0
;PIC_1.c,313 :: 		Delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_main92:
	DECFSZ     R13+0, 1
	GOTO       L_main92
	DECFSZ     R12+0, 1
	GOTO       L_main92
	DECFSZ     R11+0, 1
	GOTO       L_main92
	NOP
	NOP
;PIC_1.c,311 :: 		for(i=0; i<10; i++) {
	INCF       _i+0, 1
;PIC_1.c,314 :: 		}
	GOTO       L_main89
L_main90:
;PIC_1.c,316 :: 		} while(1);
	GOTO       L_main86
;PIC_1.c,317 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
