LIST P=16F887
#INCLUDE <P16F887.INC>
	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

		ORG     0x000
		NOP
confi	BSF   STATUS,RP0
		MOVLW b'11111111'       ;
		MOVWF TRISA	 ;
		MOVLW 0x00		 ;
		MOVWF TRISB		 ;
		BSF   STATUS,RP1 ;
		CLRF ANSEL 	 ;
		CLRF ANSELH	 ; 
		BCF STATUS,RP0;
		BCF	 STATUS,RP1;
		CLRF PORTB ;
		CLRF PORTA 

INICIO  MOVLW  0x0F    ;Cargamos 00001111 para filtrar los bits menos significativos
		ANDWF  PORTA,0 ;Hacemos el enmascaramiento con lo que esta en el puerto A
		CALL   TABLA   ; Regresamos en W el valor obtenido por la tabla
		MOVWF  PORTB	; movemos lo que se encuentre en w a el puerto b
		GOTO   INICIO   ; 
		


TABLA   ADDWF  PCL,F;
		RETLW  b'11000000'; 0
		RETLW  b'11111001';1
		RETLW  b'10100100';2
		RETLW  b'10110000';3
		RETLW  b'10011001';4              
		RETLW  b'10010010';5
		RETLW  b'10000010';6
		RETLW  b'10111000';7
		RETLW  b'10000000';8
		RETLW  b'10010000';9
		RETLW  b'10001000';A
		RETLW  b'00000000';B
		RETLW  b'11000110';C
		RETLW  b'01000000';D
		RETLW  b'10000110';E
		RETLW  b'10001110';F
		END