LIST P=16F887
#INCLUDE <P16F887.INC>
	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V
	ORG     0x000

COUNT 		EQU 	0x6F 
val1 equ 0x30
val2 equ 0x31    

 confi		BSF   STATUS,RP0	 
			MOVLW 0x00		 ;
			MOVWF TRISB
			MOVWF TRISD
			BSF   STATUS,RP1 ;
			CLRF  ANSEL 	 ;
			CLRF  ANSELH	 ; 
			BCF   STATUS,RP0;
			BCF	  STATUS,RP1;
			CLRF  PORTB
			CLRF  PORTD	
			CLRF  COUNT
			MOVLW D'1'
			

 
CONFIDISPLAY BCF PORTD,0 ; RS = 0 MODO DE INSTRUCCION
			 MOVLW 0X01  ; LIMPIAMOS DISPLAY 
			 MOVWF PORTB ; 
			 CALL  ESPERACOM
			 movlw 0x0F       ; Selecciona la primera línea
        	 movwf PORTB
       		 call ESPERACOM   
			 MOVLW 0x3C       ; Se configura el cursor
             MOVWF PORTB
        	 CALL ESPERACOM    ; Se da de alta el comando
        	 BSF PORTD, 0     ; Rs=1 MODO DATO
			 GOTO INICIO	
			
RECUCOUNT  MOVLW D'15'
		   ADDWF COUNT
		  GOTO INICIO

RECUCOUNT1  MOVLW D'15'
		   ADDWF COUNT
		  GOTO SECOND

ESPERACOM BSF PORTD,1        ; Pone la ENABLE en 1
          CALL DELAY      ; Tiempo de espera
          CALL DELAY
          BCF PORTD, 1    ; ENABLE=0    
          CALL DELAY
          RETURN      
;Subrutina para enviar un dato
LCD_Envia
        BSF PORTD,0     ; RS=1 MODO DATO
        CALL ESPERACOM   ; Se da de alta el comando
        RETURN
; Subrutina de retardo
DELAY           
        movlw .250
        movwf val2 
ciclo
        movlw .100
        movwf val1
ciclo2
        decfsz val1,1
        goto ciclo2
        decfsz val2,1
        goto ciclo
        return

TABLA       ADDWF PCL,F
			DT "   HOLA MUNDO   "
TABLA2      ADDWF  PCL,F
			DT "    ICO 2023A   "

INICIO     	MOVFW COUNT 
			CALL  TABLA 
			MOVWF PORTB
			CALL  LCD_Envia
			INCF  COUNT,F
			MOVLW D'15'
			SUBWF COUNT,F
			DECFSZ COUNT,0
			GOTO RECUCOUNT ; Termina Linea 1
			BCF PORTD,0 ; RS = 0 MODO DE INSTRUCCION
			MOVLW 0XC0  ; LIMPIAMOS DISPLAY 
			MOVWF PORTB ; 
			CALL  ESPERACOM
			BSF PORTD,0 
			CLRF COUNT
SECOND		MOVFW COUNT 
			CALL  TABLA2 
			MOVWF PORTB
			CALL  LCD_Envia
			INCF  COUNT,F
			MOVLW D'15'
			SUBWF COUNT,F
			DECFSZ COUNT,0
			GOTO RECUCOUNT1 ; Termina Linea 2
     		BCF PORTD,0 ; RS = 0 MODO DE INSTRUCCION
			MOVLW 0X07  ; LIMPIAMOS DISPLAY 
			MOVWF PORTB ; 
			CALL  ESPERACOM
			MOVLW 0X80  ; LIMPIAMOS DISPLAY 
			MOVWF PORTB ; 
			CALL  ESPERACOM
			BSF PORTD,0
			GOTO  INICIO 

			END