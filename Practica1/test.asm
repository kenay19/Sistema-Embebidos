LIST P=16F887
#INCLUDE <P16F887.INC>
	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

		ORG     0x000  
		nop
configPort	bsf   STATUS,RP0
		movlw 0xFF       ;
		movwf TRISA      ;
		movwf TRISC      ;
		movlw 0x00		 ;
		movwf TRISB		 ;
		bsf   STATUS,RP1 ;
	
		clrf ANSEL 	 ;
		clrf ANSELH	 ; 
		bcf  STATUS,RP0;
		bcf	 STATUS,RP1;
		clrf PORTA ;
		clrf PORTB ;
		clrf PORTC ;


inicio movf PORTA,W
	   andwf PORTC,W
	   movwf PORTB
	   goto inicio
		
		END