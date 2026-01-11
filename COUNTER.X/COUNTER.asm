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
CLRF PORTB


STATE_Q0
    MOVLW D'0' ; 0 is default value

    ; Bit bang counter 1-9	
    BTFSC PORTA, 0
    goto STATE_Q1
    
    BTFSC PORTA, 1
    goto STATE_Q2
    
    BTFSC PORTA, 2
    goto STATE_Q3
    
    BTFSC PORTA, 3
    goto STATE_Q4
    
    BTFSC PORTA, 4
    goto STATE_Q5
    
    BTFSC PORTB, 0
    goto STATE_Q6
    
    BTFSC PORTB, 1
    goto STATE_Q7
    
    BTFSC PORTB, 2
    goto STATE_Q8
    
    BTFSC PORTB, 3
    goto STATE_Q9
    
    goto STATE_Q10

STATE_Q1
    MOVLW D'1'
    goto STATE_Q10

STATE_Q2
    MOVLW D'2'
    goto STATE_Q10

STATE_Q3
    MOVLW D'3'
    goto STATE_Q10

STATE_Q4
    MOVLW D'4'
    goto STATE_Q10
    
STATE_Q5
    MOVLW D'5'
    goto STATE_Q10
    
STATE_Q6
    MOVLW D'6'
    goto STATE_Q10
    
STATE_Q7
    MOVLW D'7'
    goto STATE_Q10
    
STATE_Q8
    MOVLW D'8'
    goto STATE_Q10
    
STATE_Q9	
    MOVLW D'9'
    goto STATE_Q10

STATE_Q10
    ADDLW D'1' ; offset by 1
    ADDWF BitBang
    
    Loop
	DECFSZ BitBang, 1
	goto Blink

    ; Set RA5 to 0 (off)
    BCF PORTB, 5

    goto STATE_Q0

STATE_Q11
    Call Delay
    BCF PORTB, 4
    goto Loop
    
Blink
    ; Set RA5 to 1 (on)
    BTFSS PORTB, 5
    BSF PORTB, 5
    
    Call Delay
    BSF PORTB, 4
    
    goto STATE_Q11
    
		
Delay
    movlw D'2'
    movwf CounterC
    movlw D'6'
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

