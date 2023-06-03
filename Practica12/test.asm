	
LIST p=16f877
#INCLUDE <P16F887.INC>
	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V
	
;Variable para el DELAY del ADC
val equ h'20'
;Variables para el DELAY del ENABLE LCD
val2 equ 0x30
val1 equ 0x31
;Variables para separar el resultado de ADC; en valor BCD
Unidades equ 0x32
Decenas equ 0x33
Centenas equ 0x34
Resto equ 0x35
COUNT equ 0x36

INICIO  clrf PORTA ;Limpia el puerto A
		clrf PORTB ;Limpia el puerto B
		clrf PORTC ;Limpia el puerto C
		clrf PORTD ;Limpia el puerto D
		bsf STATUS,RP0
		bcf STATUS,RP1 ;Cambio al banco 1
		;Configuración de puertos C-D para el LCD
		clrf TRISC ;Configura PORTC como salida
		clrf TRISD ;Configura PORTD como salida

		;Configuración del puerto A para ADC
		movlw 00h
		movwf ADCON1 
		;Configura puerto A y E como analógicos
		movlw 3fh
		movwf TRISA 
		;Configura el puerto A como entrada
		movlw h'0'
		;Configuración del puerto B para mostrar el resultado ADC
		movwf TRISB 
		;Configura puerto B como salida
		bcf STATUS,RP0 ;Regresa al banco 0
		;Inicio del programa
START   call START_LCD ;Inicializa LCD
		CLRF COUNT
SHOW	MOVFW COUNT
		CALL TABLA 
		MOVWF PORTB
		CALL ENVIA
		INCF  COUNT,1
		MOVLW D'13'
		SUBWF COUNT,1
		DECFSZ COUNT,0
		GOTO RECUPERA
		CLRF COUNT 
		GOTO START_ADC ;Comienza la lectura del Conv. A/D
		;Inicia LCDS
START_LCD bcf PORTD,0 ; RS=0 MODO INSTRUCCION
		movlw 0x01 ; 0x01 limpia la pantalla en el LCD
		movwf PORTB
		call COMANDO ; Se da de alta el comando
		movlw 0x0C ; Selecciona la primera línea
		movwf PORTB
		call COMANDO ; Se da de alta el comando
		movlw 0x3C 
		; Se configura el cursor
		movwf PORTB
		call COMANDO ; Se da de alta el comando
		bsf PORTD, 0 ; Rs=1 MODO DATO
		return

;Rutina para enviar un dato
ENVIA 	bsf PORTD, 0 ; RS=1 MODO DATO
		call COMANDO ; Se da de alta el comando
		return
;Rutina para enviar comandos
COMANDO bsf PORTD, 1 ; Pone la señal ENABLE en 1
		CALL DELAY2
		CALL DELAY2
		bcf PORTD, 1 ; ENABLE=0call DELAY2
		return
;Rutina para limpar pantalla LCD
ERASE_LCD	bcf PORTD,0 ; RS=0 MODO INSTRUCCION
				movlw 0x01 ; 0x01 limpia la pantalla en el LCD
				movwf PORTB
				call COMANDO ; Se da de alta el comando
				bsf PORTD, 0 ; Rs=1 MODO DATO
				return
;Configuración Convertidor A/D
START_ADC	movlw b'11000001' ;ConfiguraciOn ADCON0
			movwf ADCON0 ;ADCS1=1 ADCS0=1 CHS2=0 CHS1=0
						;CHS0=0 GO/DONE=0 - ADON=1
			
CICLO		bsf ADCON0,GO_DONE ;Conversión en progreso GO=1
			
			CALL DELAY1
ESPERA 		btfsc ADCON0,GO_DONE ;Pregunta por DONE=0?(Terminó conversión)
			goto ESPERA ;No, vuelve a preguntar
			movf ADRESH,0 ;Si 
			
;Rutina que muestra temperatura			
SHOW2
			BCF PORTD,0 ; RS = 0 MODO DE INSTRUCCION
			MOVLW 0Xc1  ; LIMPIAMOS DISPLAY 
			MOVWF PORTB ; 
			CALL  COMANDO
			BSF PORTD,0 
			
			MOVFW COUNT
			CALL TABLA2 
			MOVWF PORTB
			CALL ENVIA
			INCF  COUNT,1
			MOVLW D'4'
			SUBWF COUNT,1
			DECFSZ COUNT,0
			GOTO RECUPERA2 
			CLRF COUNT
			call READ_TEMP ;Llamada a rutina que obtine el
							;valor de la temperatura a partir
							;del resultado del Conv a/D
			BCF PORTD,0 ; RS = 0 MODO DE INSTRUCCION
			MOVLW 0Xc0  ; LIMPIAMOS DISPLAY 
			MOVWF PORTB ; 
			CALL  COMANDO
			BSF PORTD,0 
			goto CICLO ;Repite el ciclo de lectura ADC

;Rutina que obtine el valor de la temperatura
;a partir del resultado del Conv a/D

READ_TEMP	
			clrf Centenas
			clrf Decenas
			clrf Unidades
			movf ADRESH,W
			addwf ADRESH,W ;Dupilca el valor de ADRESH para;obtener un valor de temperatura real aprox
			movwf Resto ;Guarda el valor de ADRESH en Resto
			
;para Centenas, Decenas y unidades atraves de restas
;sucesivas
CENTENAS1
			;Comienza el proceso d
			movlw d'100' ;W=d'100'
			subwf Resto,W ;Resto - d'100' (W)
			btfss STATUS,C ;Resto menor que d'100'?
			goto DECENAS1 ;SI
			movwf Resto ;NO, Salva el resto
			incf Centenas,1 ;Incrementa el contador de centenas BCD
			goto CENTENAS1 ;Realiza otra resta
DECENAS1	
;Comienza el proceso d
			movlw d'10' ;W=d'10'
			subwf Resto,W ;Resto - d'10' (W)
			btfss STATUS,C ;Resto menor que d'10'?
			goto UNIDADES1 ;Si
			movwf Resto ;No, Salva el resto
			incf Decenas,1 ;Incrementa el contador de centenas BCD
			goto DECENAS1 ;Realiza otra resta

UNIDADES1	
;Comienza el proceso d
			movf Resto,W ;El resto son la Unidades BCD
			movwf Unidades;
			clrf Resto;Rutina que obtiene el equivalente en ASCII
OBTEN_ASCII	
			movlw h'30'
			iorwf Unidades,f
			iorwf Decenas,f
			iorwf Centenas,f
			movf Centenas,W ;Imprime el dígito de las centenas
			movwf PORTB
			call ENVIA
			movf Decenas,W ;Imprime el dígito de las decenas
			movwf PORTB
			call ENVIA
			movf Unidades,W ;Imprime el dígito de las unidades
			movwf PORTB
			call ENVIA
			movlw ' '
			movwf PORTB
			call ENVIA
			movlw h'DF' ;Imprime el simbolo "°"
			movwf PORTB
			call ENVIA
			movlw 'C'
			movwf PORTB
			call ENVIA
			return
;Rutina que genera un Delay de 20 microSeg aprox.
;para el Conv. A/D
DELAY1		movlw h'30'
			movwf val
Loop 
			decfsz val,1
			goto Loop
			return
;Subrutina de retardo para ENABLE_LCD
DELAY2		movlw 0x70
			movwf val1
Loop1
			movlw 0x20
			movwf val2
Loop2
			decfsz val2,1
			goto Loop2
			decfsz val1,1
			goto Loop1
			return

TABLA   ADDWF PCL,F
		DT " TEMPERATURA: "
TABLA2   ADDWF PCL,F
		DT "     "
RECUPERA 	MOVLW D'13'
		 	ADDWF COUNT,1
			GOTO SHOW

RECUPERA2 	MOVLW D'4'
		 	ADDWF COUNT,1
			GOTO SHOW2
			end
