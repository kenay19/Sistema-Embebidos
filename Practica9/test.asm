LIST P=16F887
#INCLUDE <P16F887.INC>
	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V
	ORG     0x000
CounterC    EQU     0x3F
CounterB   	EQU     0x4F
CounterA    EQU     0x5F
COUNTU 		EQU 	0x6F
COUNTD 		EQU 	0x7F
COUNTC 		EQU 	0x8F
COUNTM 		EQU 	0x9F
CountMSA   EQU     0xAA
CountMSB   EQU     0xBA
CountMSC   EQU     0xCA
confi		BSF   STATUS,RP0	 
			MOVLW 0x00		 ;
			MOVWF TRISA
			MOVWF TRISB
			BSF   STATUS,RP1 ;
			CLRF  ANSEL 	 ;
			CLRF  ANSELH	 ; 
			BCF   STATUS,RP0;
			BCF	  STATUS,RP1;
			CLRF  PORTA	;
			CLRF  PORTB	
			CLRF  COUNTU
			CLRF  COUNTC
			CLRF  COUNTD
			CLRF  COUNTM



UNIDAD		CALL  RETRASOS
			INCF  COUNTU,1
			MOVLW D'9'
			SUBWF COUNTU,1
			DECFSZ COUNTU,0
			GOTO   RECUU
			MOVLW  D'0'
			MOVWF COUNTU
			GOTO  DECENA


DECENA      INCF COUNTD,1
			MOVLW  D'5'
			SUBWF COUNTD,1
			DECFSZ COUNTD,0
			GOTO   RECUD
			MOVLW  D'0'
			MOVWF COUNTD
			GOTO  CENTENA

RECUD   	MOVLW D'5'
			ADDWF COUNTD,1	
			GOTO  UNIDAD

CENTENA      INCF COUNTC,1
			MOVLW  D'9'
			SUBWF COUNTC,1
			DECFSZ COUNTC,0
			GOTO   RECUC
			MOVLW  D'0'
			MOVWF COUNTC
			GOTO  MILLARES

MILLARES      INCF COUNTM,1
			MOVLW  D'5'
			SUBWF COUNTM,1
			DECFSZ COUNTM,0
			GOTO   RECUM
			MOVLW  D'0'
			MOVWF COUNTM
			GOTO  UNIDAD

RECUM   	MOVLW D'5'
			ADDWF COUNTM,1	
			GOTO  UNIDAD

RECUC   	MOVLW D'9'
			ADDWF COUNTC,1	
			GOTO  UNIDAD


RECUU   	MOVLW D'9'
			ADDWF COUNTU,1	
			GOTO  UNIDAD	
			
			

TABLA      ADDWF PCL,F
		   ;       ABCDEFGH
		   RETLW B'11111100' ;0
		   RETLW B'01100000' ;1
		   RETLW B'11011010' ;2
		   RETLW B'11110010' ;3
		   RETLW B'01100110' ;4
		   RETLW B'10110110' ;5
		   RETLW B'10111110' ;6
		   RETLW B'11100010' ;7
		   RETLW B'11111110' ;8
		   RETLW B'11100110' ;9
		   

RETRASOS	nop
			MOVLW 	D'2'
			MOVWF	CounterC
c			MOVLW	D'10'
			MOVWF	CounterB
a			MOVLW	D'80'
			MOVWF	CounterA
loop	    DECFSZ	CounterA,1
			GOTO	muestra
			DECFSZ	CounterB,1
			GOTO	a 
			DECFSZ	CounterC,1
			GOTO	c
			RETURN


muestra     CALL  SHOW
			GOTO  loop

SHOW        MOVLW B'00001000'
		    MOVWF PORTA
			MOVFW COUNTU
			CALL TABLA 
			MOVWF PORTB
			CALL  MS5
			MOVLW B'00000100'
		    MOVWF PORTA
			MOVFW COUNTD	
			CALL TABLA 
			MOVWF PORTB
			CALL  MS5
			MOVLW B'00000010'
		    MOVWF PORTA
			MOVFW COUNTC	
			CALL TABLA 
			MOVWF PORTB
			CALL  MS5
			MOVLW B'00000001'
		    MOVWF PORTA
			MOVFW COUNTM	
			CALL TABLA 
			MOVWF PORTB
			CALL  MS5
		    RETURN

MS5			movlw	D'1'
			movwf	CountMSA
b2			movlw	D'10'
			movwf	CountMSB
a2			movlw	D'5'
			movwf	CountMSC
loop1		decfsz	CountMSC,1
			goto	loop1
			decfsz	CountMSB,1
			goto	a2
			decfsz	CountMSA,1
			goto	b2
			RETURN
			END