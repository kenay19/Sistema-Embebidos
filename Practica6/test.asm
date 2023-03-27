LIST P=16F887
#INCLUDE <P16F887.INC>
	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

		ORG     0x000
CONT    EQU     6FH ; Variable que se sumara al pcl para retornar el valor necesario en el puerto B y C
OPC    EQU     6DH ; Indicara si se ha cambiado de rutina o si el contador se debe reiniciar para volver a mostrar el nombre 
CounterC	EQU    6CH 
CounterB    EQU    6BH
CounterA    EQU    6AH
confi	    BSF   STATUS,RP0
		MOVLW b'00000001'       ;
		MOVWF TRISA		 ;
		MOVLW 0x00		 ;
		MOVWF TRISB		 ;
		MOVWF TRISC
		BSF   STATUS,RP1 ;
		CLRF ANSEL 	 ;
		CLRF ANSELH	 ; 
		BCF STATUS,RP0;
		BCF	 STATUS,RP1;
		CLRF PORTB ;
		CLRF PORTA	;
		CLRF PORTC 	;
		MOVLW d'0'
		MOVWF CONT
		MOVLW d'1'
		MOVWF OPC


INICIO  BTFSC PORTA,0  ; Probamos si el bit 0 del puerto A se encuentra en 0
		GOTO  SECCION1 ; PORTA,0 !=0, Hacemos la rutina para mostrar kevin omar lazaro ortega = 24 letras y espacios 
		GOTO  SECCION2 ; PORTA,0 ==0, Hacemos la rutina para mostrar victor aldair romero paredes = 28 letras y espacios

SECCION1 BTFSC  OPC,0 ; Comprobamos si hemos cambiado de rutina
		 GOTO DOKEV ; OPC,0 != 0 No hemos cambiado de rutina
		 MOVLW d'0' ; OPC,0 == 0 Hemos cambiado de rutina 
		 MOVWF CONT ; Reinicia el contador
		 MOVLW d'1' ; carga 1 en W
		 MOVWF OPC  ; Cambia la opcion para indicar que estamos en la rutina 1
		 MOVLW  0xFF ; cargamos b'11111111' en w
		 MOVWF  PORTB ; Limpiamos el puerto B 
		 MOVWF  PORTC ; Limpiamos el puerto c
		 CALL retrasos ; hacemos un retardo 
		 GOTO DOKEV ; realizamos la secuencia letra por letra del nombre 
		  
SECCION2 BTFSS  OPC,0 ; Comprobamos si hemos cambiado la rutina
		 GOTO DOVIC ; OPC,0 != 1 No hemos cambiado la rutina 
		 MOVLW d'0' ; OPC,0 == 1, Por lo que Cargamos 0 en W
		 MOVWF CONT ; Reiniciamos el contador
		 MOVWF OPC  ; Cambiamos la Opcion para indicar que estamos haciendo la rutina "0"
		 MOVLW  0xFF ; cargamos b'11111111' en w
		 MOVWF  PORTB ; Limpiamos el puerto B 
		 MOVWF  PORTC ; Limpiamos el puerto c
		 CALL retrasos ; hacemos un retardo 
		 GOTO DOVIC

DOVIC    MOVFW CONT  ; Movemos lo que esta en el contador a W; W = CONT
		 CALL  VICTORB ; Mandamos a Llamar a la tabla que guarda lo que se mostrara por el puerto B
		 MOVWF PORTB ; Lo que regrese de la tabla los mandamos al puerto B
		 MOVFW CONT ; Movemos lo que esta en el contador a W; W = CONT
		 CALL  VICTORC ;  Mandamos a Llamar a la tabla que guarda lo que se mostrara por el puerto C
		 MOVWF PORTC ;  Lo que regrese de la tabla los mandamos al puerto C
		 MOVLW  d'1' ; Cargamos uno en W, W=1
		 ADDWF CONT,1 ; Sumamos lo que se encuentre en W a CONT, CONT = CONT + W
		 CALL  retrasos ; Realizamos un retraso 
		 MOVLW  d'27'   ; Cargamos 27 en W 
		 SUBWF  CONT,1 ; Le restamos lo que se encuntre en W a CONT = CONT - W
		 DECFSZ CONT,0 ; Le restamos 1 a cont, W = CONT -1
		 GOTO   reVic  ; Si el resultado no es 0  le volvemos a sumar 27 para dejar a CONT como estaba antes
		 MOVLW  d'1' ; Si el resultado es 1 cargamos uno en W 
		 MOVWF  OPC ; Movemos lo que esta en W a OPC decierta manera volver a empezar a mostrar el nombre si el puerto A no ha sido modificado
		 GOTlO   INICIO

reVic    MOVLW  d'27' ; Cargamos 27 en W
		 ADDWF  CONT,1 ; Se lo sumamos a CONT
		 GOTO   INICIO
		 

DOKEV  	 MOVFW CONT ; Movemos lo que esta en el contador a W; W = CONT
		 CALL  KEVINB; Mandamos a Llamar a la tabla que guarda lo que se mostrara por el puerto B
		 MOVWF PORTB; Lo que regrese de la tabla los mandamos al puerto B
		 MOVFW CONT; Movemos lo que esta en el contador a W; W = CONT
		 CALL  KEVINC;  Mandamos a Llamar a la tabla que guarda lo que se mostrara por el puerto C
		 MOVWF PORTC;  Lo que regrese de la tabla los mandamos al puerto C
		 MOVLW d'1'; Cargamos uno en W, W=1
		 ADDWF CONT,1; Sumamos lo que se encuentre en W a CONT, CONT = CONT + W
		 CALL  retrasos; Realizamos un retraso 
		 MOVLW  d'23'; Cargamos 23 en W 
		 SUBWF  CONT,1 ; Le restamos lo que se encuntre en W a CONT = CONT - W
		 DECFSZ CONT,0 ; Le restamos 1 a cont, W = CONT -1
		 GOTO   reKev ; Si el resultado no es 0  le volvemos a sumar 23 para dejar a CONT como estaba antes
		 MOVLW  d'0' ; Si el resultado es 0 cargamos uno en W 
		 MOVWF  OPC ; Movemos lo que esta en W a OPC decierta manera volver a empezar a mostrar el nombre si el puerto A no ha sido modificado
		 GOTO   INICIO

reKev    MOVLW  d'23' ; Cargamos 27 en W
		 ADDWF  CONT,1 ; Se lo sumamos a CONT
		 GOTO   INICIO

		 
		 

VICTORB  ADDWF PCL,F
		;        HGFEDCBA
		 RETLW b'00111111'      ; V
		 RETLW b'11001100'      ; I
		 RETLW b'00001100'      ; C
		 RETLW b'11111100'      ; T
		 RETLW b'00000000'      ; O
		 RETLW b'00111000'      ; R
		 RETLW b'11111111'      ; 
		 RETLW b'00110000'      ; A
		 RETLW b'00001111'     	; L
		 RETLW b'11000000'      ; D
		 RETLW b'00110000'      ; A
		 RETLW b'11001100'      ; I
		 RETLW b'00111000'      ; R
		 RETLW b'11111111'      ; 
		 RETLW b'00111000'      ; R
		 RETLW b'00000000'      ; O
		 RETLW b'00110011'     	; M
		 RETLW b'00001100'      ; E
		 RETLW b'00111000'      ; R
		 RETLW b'00000000'      ; O
		 RETLW b'11111111'      ; 
		 RETLW b'00111000'      ; P
		 RETLW b'00110000'      ; A
		 RETLW b'00111000'      ; R
		 RETLW b'00001100'      ; E
		 RETLW b'11000000'      ; D
		 RETLW b'00001100'      ; E
		 RETLW b'01000100'      ; S

VICTORC  ADDWF PCL,F
		;        LNOPMKJI
		 RETLW b'10111011'      ; V
		 RETLW b'11011101'      ; I
		 RETLW b'11111111'      ; C
		 RETLW b'11011101'      ; T
		 RETLW b'11111111'      ; O
		 RETLW b'01100111'      ; R
		 RETLW b'11111111'      ; 
		 RETLW b'01110111'      ; A
		 RETLW b'11111111'      ; L
		 RETLW b'11011101'      ; D
		 RETLW b'01110111'      ; A
		 RETLW b'11011101'      ; I
		 RETLW b'01100111'      ; R
		 RETLW b'11111111'      ; 
		 RETLW b'01100111'      ; R
		 RETLW b'11111111'      ; O
		 RETLW b'11111010'      ; M
		 RETLW b'01110111'      ; E
		 RETLW b'01100111'      ; R
		 RETLW b'11111111'      ; O
		 RETLW b'11111111'      ; 
		 RETLW b'01110111'      ; P
		 RETLW b'01110111'      ; A
		 RETLW b'01100111'      ; R
		 RETLW b'01110111'      ; E
		 RETLW b'11011101'      ; D
		 RETLW b'01110111'      ; E
		 RETLW b'01110111'      ; S

KEVINB   ADDWF  PCL,F 
		 ;       HGFEDCBA
		 RETLW b'00111111'      ; K
		 RETLW b'00001100'      ; E
		 RETLW b'00111111'      ; V
		 RETLW b'11001100'      ; I
		 RETLW b'00110011'      ; N 
		 RETLW b'11111111'      ; 
		 RETLW b'00000000'      ; O
		 RETLW b'00110011'      ; M
		 RETLW b'00110000'     	; A
		 RETLW b'00111000'      ; R
		 RETLW b'11111111'      ; 
		 RETLW b'00001111'      ; L
		 RETLW b'00110000'      ; A
		 RETLW b'11001100'      ; Z
		 RETLW b'00110000'      ; A
		 RETLW b'00111000'      ; R
		 RETLW b'00000000'     	; O
		 RETLW b'11111111'      ; 
		 RETLW b'00000000'      ; O
		 RETLW b'00111000'      ; R
		 RETLW b'11111100'      ; T
		 RETLW b'00001100'      ; E
		 RETLW b'00000100'      ; G
		 RETLW b'00110000'      ; A

KEVINC   ADDWF PCL,F
		;        LNOPMKJI
		 RETLW b'01101011'      ; K
		 RETLW b'01110111'      ; E
		 RETLW b'10111011'      ; V
		 RETLW b'11011101'      ; I
		 RETLW b'11101110'      ; N
		 RETLW b'11111111'      ; 
		 RETLW b'11111111'      ; O
		 RETLW b'11111010'      ; M
		 RETLW b'01110111'      ; A
		 RETLW b'01100111'      ; R
		 RETLW b'11111111'      ; 
		 RETLW b'11111111'      ; L
		 RETLW b'01110111'      ; A
		 RETLW b'10111011'      ; Z
		 RETLW b'01110111'      ; A
		 RETLW b'01100111'      ; R
		 RETLW b'11111111'      ; O
		 RETLW b'11111111'      ; 
		 RETLW b'11111111'      ; O
		 RETLW b'01100111'      ; R
		 RETLW b'11011101'      ; T
		 RETLW b'01110111'      ; E
		 RETLW b'11110111'      ; G
		 RETLW b'01110111'      ; A	

retrasos MOVLW D'7'
		MOVWF	CounterC
		MOVLW	D'22'
		MOVWF	CounterB
		MOVLW	D'233'
		MOVWF	CounterA
loop    DECFSZ	CounterA,1
		GOTO	loop
		DECFSZ	CounterB,1
		GOTO	loop 
		DECFSZ	CounterC,1
		GOTO	loop
		RETURN


		END 