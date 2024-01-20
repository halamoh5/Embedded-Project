
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MyProject.c,31 :: 		void interrupt(){
;MyProject.c,33 :: 		if(INTCON | 0x02){    //
	MOVLW      2
	IORWF      INTCON+0, 0
	MOVWF      R0+0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt0
;MyProject.c,34 :: 		PORTC = PORTC | 0x04; //0000 0100
	BSF        PORTC+0, 2
;MyProject.c,35 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,36 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,37 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,38 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,39 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,40 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,41 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,42 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,43 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,44 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,45 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,46 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,47 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,48 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,49 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,50 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,51 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,52 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,53 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,54 :: 		delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,55 :: 		PORTC = PORTC & 0x00;
	MOVLW      0
	ANDWF      PORTC+0, 1
;MyProject.c,56 :: 		INTCON = INTCON & 0xFD; //clear the flag
	MOVLW      253
	ANDWF      INTCON+0, 1
;MyProject.c,57 :: 		}
L_interrupt0:
;MyProject.c,59 :: 		}
L_end_interrupt:
L__interrupt21:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_ADC_init:

;MyProject.c,61 :: 		void ADC_init(void){
;MyProject.c,62 :: 		ADCON1 = 0xC0; // right justified, all channels are analog    //0001 1100
	MOVLW      192
	MOVWF      ADCON1+0
;MyProject.c,63 :: 		TRISA = 0x0F; // Port A is input
	MOVLW      15
	MOVWF      TRISA+0
;MyProject.c,64 :: 		ADCON0 = 0x41; //prescale 16, channel3, dont start conversion, power on ATD
	MOVLW      65
	MOVWF      ADCON0+0
;MyProject.c,66 :: 		}
L_end_ADC_init:
	RETURN
; end of _ADC_init

_ADC_read1:

;MyProject.c,69 :: 		unsigned int ADC_read1(){
;MyProject.c,70 :: 		unsigned int read = 0;
;MyProject.c,71 :: 		ADCON0 = 0x41;      // 0100 1001      RA0                 0010 0001
	MOVLW      65
	MOVWF      ADCON0+0
;MyProject.c,72 :: 		ADCON0 = ADCON0 | 0x04; // GO
	BSF        ADCON0+0, 2
;MyProject.c,73 :: 		while(ADCON0 & 0x04);      // until finish reading
L_ADC_read11:
	BTFSS      ADCON0+0, 2
	GOTO       L_ADC_read12
	GOTO       L_ADC_read11
L_ADC_read12:
;MyProject.c,75 :: 		read     =   (ADRESH<<8)|ADRESL  ;
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;MyProject.c,76 :: 		read =  (read * 100) / 1023;
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
;MyProject.c,77 :: 		return read;
;MyProject.c,79 :: 		}
L_end_ADC_read1:
	RETURN
; end of _ADC_read1

_check_moisture:

;MyProject.c,81 :: 		unsigned int check_moisture(void){
;MyProject.c,83 :: 		moist = ADC_read1();
	CALL       _ADC_read1+0
	MOVF       R0+0, 0
	MOVWF      _moist+0
	MOVF       R0+1, 0
	MOVWF      _moist+1
;MyProject.c,84 :: 		return moist;
;MyProject.c,85 :: 		}
L_end_check_moisture:
	RETURN
; end of _check_moisture

_buzz:

;MyProject.c,87 :: 		void buzz(){
;MyProject.c,88 :: 		TRISD = 0x00;
	CLRF       TRISD+0
;MyProject.c,89 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;MyProject.c,90 :: 		PORTD = PORTD | 0x01;
	BSF        PORTD+0, 0
;MyProject.c,91 :: 		myyDelay(1000);
	MOVLW      232
	MOVWF      FARG_myyDelay_t+0
	MOVLW      3
	MOVWF      FARG_myyDelay_t+1
	CALL       _myyDelay+0
;MyProject.c,92 :: 		PORTD = PORTD & 0x00;
	MOVLW      0
	ANDWF      PORTD+0, 1
;MyProject.c,93 :: 		myyDelay(1000);
	MOVLW      232
	MOVWF      FARG_myyDelay_t+0
	MOVLW      3
	MOVWF      FARG_myyDelay_t+1
	CALL       _myyDelay+0
;MyProject.c,94 :: 		}
L_end_buzz:
	RETURN
; end of _buzz

_Dist1:

;MyProject.c,96 :: 		int Dist1(){
;MyProject.c,99 :: 		int dist=0;
;MyProject.c,100 :: 		TMR1H = 0;                  //Sets the Initial Value of Timer
	CLRF       TMR1H+0
;MyProject.c,101 :: 		TMR1L = 0;                  //Sets the Initial Value of Timer
	CLRF       TMR1L+0
;MyProject.c,103 :: 		RC0_BIT = 1;               //TRIGGER HIGH
	BSF        RC0_bit+0, BitPos(RC0_bit+0)
;MyProject.c,104 :: 		Delay_us(10);               //10uS Delay
	MOVLW      6
	MOVWF      R13+0
L_Dist13:
	DECFSZ     R13+0, 1
	GOTO       L_Dist13
	NOP
;MyProject.c,105 :: 		RC0_BIT = 0;               //TRIGGER LOW
	BCF        RC0_bit+0, BitPos(RC0_bit+0)
;MyProject.c,107 :: 		while(!RC1_BIT);           //Waiting for Echo
L_Dist14:
	BTFSC      RC1_bit+0, BitPos(RC1_bit+0)
	GOTO       L_Dist15
	GOTO       L_Dist14
L_Dist15:
;MyProject.c,108 :: 		T1CON.F0 = 1;               //Timer Starts
	BSF        T1CON+0, 0
;MyProject.c,109 :: 		while(RC1_BIT);            //Waiting for Echo goes LOW
L_Dist16:
	BTFSS      RC1_bit+0, BitPos(RC1_bit+0)
	GOTO       L_Dist17
	GOTO       L_Dist16
L_Dist17:
;MyProject.c,110 :: 		T1CON.F0 = 0;               //Timer Stops
	BCF        T1CON+0, 0
;MyProject.c,112 :: 		dist = (TMR1L | (TMR1H<<8));   //Reads Timer Value
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;MyProject.c,113 :: 		dist = dist/58.82;                //Converts Time to Distance
	CALL       _int2double+0
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
;MyProject.c,114 :: 		return dist;
;MyProject.c,115 :: 		}
L_end_Dist1:
	RETURN
; end of _Dist1

_main:

;MyProject.c,118 :: 		void main(){
;MyProject.c,120 :: 		TRISC=0x02;
	MOVLW      2
	MOVWF      TRISC+0
;MyProject.c,121 :: 		TRISB=0x01;       //port b is output
	MOVLW      1
	MOVWF      TRISB+0
;MyProject.c,122 :: 		PORTB = PORTB & 0xFE;
	MOVLW      254
	ANDWF      PORTB+0, 1
;MyProject.c,123 :: 		PORTC=0x00;
	CLRF       PORTC+0
;MyProject.c,124 :: 		INTCON = INTCON | 0x90; // GIE and Local Enable the External Interrupt RB0
	MOVLW      144
	IORWF      INTCON+0, 1
;MyProject.c,126 :: 		Lcd_Init();                   // Initialize LCD
	CALL       _Lcd_Init+0
;MyProject.c,127 :: 		myyDelay(2000);
	MOVLW      208
	MOVWF      FARG_myyDelay_t+0
	MOVLW      7
	MOVWF      FARG_myyDelay_t+1
	CALL       _myyDelay+0
;MyProject.c,128 :: 		Lcd_Cmd(_LCD_CLEAR);          // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,129 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);     // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,130 :: 		Lcd_Out(1,6,"Hello");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_MyProject+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,132 :: 		ADC_init();
	CALL       _ADC_init+0
;MyProject.c,136 :: 		myyDelay(1000);
	MOVLW      232
	MOVWF      FARG_myyDelay_t+0
	MOVLW      3
	MOVWF      FARG_myyDelay_t+1
	CALL       _myyDelay+0
;MyProject.c,138 :: 		myyDelay(1000);
	MOVLW      232
	MOVWF      FARG_myyDelay_t+0
	MOVLW      3
	MOVWF      FARG_myyDelay_t+1
	CALL       _myyDelay+0
;MyProject.c,140 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,141 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,143 :: 		T1CON = 0x10;                 //Initialize Timer Module
	MOVLW      16
	MOVWF      T1CON+0
;MyProject.c,145 :: 		while(1){
L_main8:
;MyProject.c,149 :: 		myyDelay(3000);
	MOVLW      184
	MOVWF      FARG_myyDelay_t+0
	MOVLW      11
	MOVWF      FARG_myyDelay_t+1
	CALL       _myyDelay+0
;MyProject.c,151 :: 		Lcd_Out(1,1,"Distance: ");         // Cursor off
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_MyProject+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,152 :: 		distt = Dist1();
	CALL       _Dist1+0
	MOVF       R0+0, 0
	MOVWF      _distt+0
	MOVF       R0+1, 0
	MOVWF      _distt+1
;MyProject.c,153 :: 		IntToStr(distt,text1);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _text1+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;MyProject.c,154 :: 		Ltrim(text1);
	MOVLW      _text1+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;MyProject.c,155 :: 		Lcd_Out(2,8, text1);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _text1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,156 :: 		myyDelay(3000);
	MOVLW      184
	MOVWF      FARG_myyDelay_t+0
	MOVLW      11
	MOVWF      FARG_myyDelay_t+1
	CALL       _myyDelay+0
;MyProject.c,157 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,158 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,160 :: 		if(distt > 6){
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _distt+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main28
	MOVF       _distt+0, 0
	SUBLW      6
L__main28:
	BTFSC      STATUS+0, 0
	GOTO       L_main10
;MyProject.c,161 :: 		buzz();
	CALL       _buzz+0
;MyProject.c,162 :: 		}
	GOTO       L_main11
L_main10:
;MyProject.c,164 :: 		Lcd_Out(1,1,"Moisture: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_MyProject+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,165 :: 		moist = check_moisture();
	CALL       _check_moisture+0
	MOVF       R0+0, 0
	MOVWF      _moist+0
	MOVF       R0+1, 0
	MOVWF      _moist+1
;MyProject.c,166 :: 		IntToStr(moist,t_moist);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _t_moist+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;MyProject.c,167 :: 		ltrim(t_moist);
	MOVLW      _t_moist+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;MyProject.c,168 :: 		Lcd_Out(2,8, t_moist );
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _t_moist+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,169 :: 		Lcd_Out_cp("%");
	MOVLW      ?lstr4_MyProject+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;MyProject.c,170 :: 		myyDelay(4000);     // Write text in first row
	MOVLW      160
	MOVWF      FARG_myyDelay_t+0
	MOVLW      15
	MOVWF      FARG_myyDelay_t+1
	CALL       _myyDelay+0
;MyProject.c,171 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,172 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,174 :: 		if(moist < 36){
	MOVLW      0
	SUBWF      _moist+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main29
	MOVLW      36
	SUBWF      _moist+0, 0
L__main29:
	BTFSC      STATUS+0, 0
	GOTO       L_main12
;MyProject.c,175 :: 		Lcd_Out(2,1,"Low Moisture");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_MyProject+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,176 :: 		myyDelay(4000);
	MOVLW      160
	MOVWF      FARG_myyDelay_t+0
	MOVLW      15
	MOVWF      FARG_myyDelay_t+1
	CALL       _myyDelay+0
;MyProject.c,177 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,178 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                // Clear display
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;MyProject.c,179 :: 		PORTD = PORTD | 0x02;  //0000 0010
	BSF        PORTD+0, 1
;MyProject.c,180 :: 		myyDelay(4000);
	MOVLW      160
	MOVWF      FARG_myyDelay_t+0
	MOVLW      15
	MOVWF      FARG_myyDelay_t+1
	CALL       _myyDelay+0
;MyProject.c,181 :: 		PORTD = PORTD & 0x00;
	MOVLW      0
	ANDWF      PORTD+0, 1
;MyProject.c,182 :: 		myyDelay(2000);
	MOVLW      208
	MOVWF      FARG_myyDelay_t+0
	MOVLW      7
	MOVWF      FARG_myyDelay_t+1
	CALL       _myyDelay+0
;MyProject.c,183 :: 		PORTC = PORTC | 0x04; //0000 0100
	BSF        PORTC+0, 2
;MyProject.c,184 :: 		myyDelay(5000);
	MOVLW      136
	MOVWF      FARG_myyDelay_t+0
	MOVLW      19
	MOVWF      FARG_myyDelay_t+1
	CALL       _myyDelay+0
;MyProject.c,185 :: 		PORTC = PORTC & 0x00;  //0000 0000
	MOVLW      0
	ANDWF      PORTC+0, 1
;MyProject.c,186 :: 		continue;
	GOTO       L_main8
;MyProject.c,187 :: 		}
L_main12:
;MyProject.c,190 :: 		Lcd_Out(1,1,"High Moisture");                                                                                   //0000 0000 (bit 0 & 1 output)
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_MyProject+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,191 :: 		PORTD = PORTD | 0X04;     //0000 0100
	BSF        PORTD+0, 2
;MyProject.c,192 :: 		myyDelay(4000);
	MOVLW      160
	MOVWF      FARG_myyDelay_t+0
	MOVLW      15
	MOVWF      FARG_myyDelay_t+1
	CALL       _myyDelay+0
;MyProject.c,193 :: 		PORTB = PORTB & 0x00;
	MOVLW      0
	ANDWF      PORTB+0, 1
;MyProject.c,194 :: 		continue;
	GOTO       L_main8
;MyProject.c,197 :: 		}
L_main11:
;MyProject.c,199 :: 		}
	GOTO       L_main8
;MyProject.c,201 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_myyDelay:

;MyProject.c,203 :: 		void myyDelay(unsigned int t){
;MyProject.c,204 :: 		for(i = 0;i < t; i++)
	CLRF       _i+0
	CLRF       _i+1
L_myyDelay14:
	MOVF       FARG_myyDelay_t+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__myyDelay31
	MOVF       FARG_myyDelay_t+0, 0
	SUBWF      _i+0, 0
L__myyDelay31:
	BTFSC      STATUS+0, 0
	GOTO       L_myyDelay15
;MyProject.c,205 :: 		for(j = 0;j < 165; j++); //delay of 1 ms
	CLRF       _j+0
	CLRF       _j+1
L_myyDelay17:
	MOVLW      128
	XORWF      _j+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__myyDelay32
	MOVLW      165
	SUBWF      _j+0, 0
L__myyDelay32:
	BTFSC      STATUS+0, 0
	GOTO       L_myyDelay18
	INCF       _j+0, 1
	BTFSC      STATUS+0, 2
	INCF       _j+1, 1
	GOTO       L_myyDelay17
L_myyDelay18:
;MyProject.c,204 :: 		for(i = 0;i < t; i++)
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;MyProject.c,205 :: 		for(j = 0;j < 165; j++); //delay of 1 ms
	GOTO       L_myyDelay14
L_myyDelay15:
;MyProject.c,207 :: 		}
L_end_myyDelay:
	RETURN
; end of _myyDelay
