list p=16f84a
#include <p16f84a.inc>
__CONFIG _CP_OFF & _PWRTE_ON & _WDT_OFF & _XT_OSC
    
STATUS EQU 03H
PORTA EQU 05H
PORTB EQU 06H
TRISA EQU 85H
TRISB EQU 86H
CounterC EQU 0CH
CounterB EQU 0DH
CounterA EQU 0EH
TEMP EQU 0FH
BitBang EQU 1FH

	ORG 00h
		goto Init
	ORG 04h
		retfile
Init

BSF STATUS, 5
MOVLW 0x1F
MOVWF TRISA
MOVLW 0X0F
MOVWF TRISB
BCF STATUS, 5
MOVLW 0x00
MOVWF PORTB


Start

MOVLW D'0' ; 0 is default value

; Bit bang counter 1-9	
BTFSC PORTA, 0
MOVLW D'1'
BTFSC PORTA, 1
MOVLW D'2'
BTFSC PORTA, 2
MOVLW D'3'
BTFSC PORTA, 3
MOVLW D'4'
BTFSC PORTA, 4
MOVLW D'5'
BTFSC PORTB, 0
MOVLW D'6'
BTFSC PORTB, 1
MOVLW D'7'
BTFSC PORTB, 2
MOVLW D'8'
BTFSC PORTB, 3
MOVLW D'9'

ADDLW D'1' ; offset by 1
MOVWF BitBang
Loop
     DECFSZ BitBang, 1
     goto Blink

goto Start

Blink
    BSF PORTB, 4
    Call Delay
    BCF PORTB, 4
    Call Delay
    goto Loop
		
Delay
    movlw D'6'
    movwf CounterC
    movlw D'24'
    movwf CounterB
    movlw D'167'
    movwf CounterA
   
loop
    decfsz CounterA, 1
    goto loop
    decfsz CounterB, 1
    goto loop
    decfsz CounterC, 1
    goto loop
    nop
    return

end



