LIST P=16F887
#INCLUDE <P16F887.INC>
	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

		ORG     0x000
Cont        equ      2EH
Ret1	 	equ      3EH 
Ret2	 	equ      4EH
Opcion	 	equ      5EH
confi	BSF   STATUS,RP0
		MOVLW b'00000011'       ;
		MOVWF TRISD		 ;
		MOVLW 0x00		 ;
		MOVWF TRISB		 ;
		MOVWF TRISA
		BSF   STATUS,RP1 ;
		CLRF ANSEL 	 ;
		CLRF ANSELH	 ; 
		BCF STATUS,RP0;
		BCF	 STATUS,RP1;
		CLRF PORTB ;
		CLRF PORTD 
		MOVLW d'2'
		MOVWF Opcion

INICIO 	BTFSC  PORTD,0;
		GOTO   SECCIONES34	;
		GOTO   SECCIONES12

SECCIONES12	BTFSC  PORTD,1;
			GOTO   SECCION2	;
			GOTO   SECCION1
SECCIONES34	BTFSC  PORTD,1;
			GOTO   SECCION4	;
			GOTO   SECCION3

SECCION1    MOVLW  d'1'
			ADDWF  PORTB,1
			DECFSZ PORTB,1
			GOTO   rigth
			MOVLW  b'1000000'
			MOVWF  PORTB
			GOTO   rigth

SECCION2    MOVLW  d'1'
			ADDWF  PORTB,1
			DECFSZ PORTB,1
			GOTO   left
			MOVLW  b'00000001'
			MOVWF  PORTB
			GOTO   left

SECCION3	MOVLW  d'3'
			MOVWF  Cont
dentro		MOVFW  Cont
			CALL   tabla
			MOVWF  PORTB
			CALL   retrasos
			DECFSZ  Cont,1
			GOTO   dentro
			MOVFW  Cont
			CALL   tabla
			MOVWF  PORTB
			CALL   retrasos
fuera		MOVLW  d'1'
			ADDWF  Cont,1
			MOVFW  Cont
			CALL   tabla
			MOVWF  PORTB
			CALL   retrasos
			MOVLW  d'2'
			SUBWF  Cont,1
			DECFSZ Cont,0
			GOTO RECUPERA
			CLRF PORTB
			GOTO INICIO

RECUPERA   MOVLW  d'2'
		   ADDWF  Cont,1
		   GOTO   fuera

SECCION4    MOVLW  d'1'
			ADDWF  PORTB,1
			DECFSZ PORTB,1
			GOTO   test1
			MOVLW  b'00000001'
			MOVWF  PORTB
			GOTO   test1

test1       BTFSS  PORTB,7
			GOTO   test2
			MOVLW  d'1'
			MOVWF  Opcion
			ADDWF  Opcion,1
			GOTO   test2
			
test2       BTFSS  PORTB,0
			GOTO   direc
			MOVLW  d'1'
			SUBWF  Opcion,1
			GOTO   direc

direc       DECFSZ  Opcion,0
			GOTO    rigth
			GOTO    left
			
rigth 		CALL   retrasos
			BCF    STATUS,C
			RRF    PORTB,W
			MOVWF  PORTB
			GOTO   INICIO

left		CALL   retrasos
			BCF    STATUS,C
			RLF    PORTB,W
			MOVWF  PORTB
			INCFSZ PORTB,0
			GOTO   INICIO

retrasos  	MOVLW  d'255'
			MOVWF 	Ret1
retra1		DECFSZ  Ret1,1
			goto    retra2
			return
retra2		MOVWF 	Ret2
retra2a		DECFSZ  Ret2,1
			GOTO    retra2a
			GOTO    retra1

tabla       ADDWF   PCL,F
			RETLW   b'00011000'
			RETLW   b'00100100'
			RETLW   b'01000010'
			RETLW 	b'10000001'

		END