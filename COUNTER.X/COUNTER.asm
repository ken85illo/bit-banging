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
    goto STATE_Q1 ; if RA0 = 1 
    
    BTFSC PORTA, 1
    goto STATE_Q2 ; if RA1 = 1
    
    BTFSC PORTA, 2
    goto STATE_Q3 ; if RA2 = 1
    
    BTFSC PORTA, 3
    goto STATE_Q4 ; if RA3 = 1
    
    BTFSC PORTA, 4
    goto STATE_Q5 ; if RA4 = 1
    
    BTFSC PORTB, 0
    goto STATE_Q6 ; if RB0 = 1
    
    BTFSC PORTB, 1
    goto STATE_Q7 ; if RB1 = 1
    
    BTFSC PORTB, 2
    goto STATE_Q8 ; if RB2 = 1
    
    BTFSC PORTB, 3
    goto STATE_Q9 ; if RB3 = 1
    
    goto STATE_Q0 ; stays in STATE_Q0 when no input

STATE_Q1
    MOVLW D'1' ; adds 1 for 1 pulse
    goto STATE_Q10 ; goto STATE_Q10 to send the pulses

STATE_Q2
    MOVLW D'2' ; adds 2 for 2 pulses
    goto STATE_Q10 ; goto STATE_Q10 to send the pulses

STATE_Q3
    MOVLW D'3' ; adds 3 for 3 pulses
    goto STATE_Q10 ; goto STATE_Q10 to send the pulses

STATE_Q4
    MOVLW D'4' ; adds 4 for 4 pulses
    goto STATE_Q10 ; goto STATE_Q10 to send the pulses
    
STATE_Q5
    MOVLW D'5' ; adds 5 for 5 pulses
    goto STATE_Q10 ; goto STATE_Q10 to send the pulses
    
STATE_Q6
    MOVLW D'6' ; adds 6 for 6 pulses
    goto STATE_Q10 ; goto STATE_Q10 to send the pulses
    
STATE_Q7
    MOVLW D'7' ; adds 7 for 7 pulses
    goto STATE_Q10 ; goto STATE_Q10 to send the pulses
    
STATE_Q8
    MOVLW D'8' ; adds 8 for 8 pulses
    goto STATE_Q10 ; goto STATE_Q10 to send the pulses
    
STATE_Q9	
    MOVLW D'9' ; adds 9 for 9 pulses
    goto STATE_Q10 ; goto STATE_Q10 to send the pulses

STATE_Q10
    ADDLW D'1' ; offset by 1
    ADDWF BitBang
    
    ; Sets rising edge of pulse
    Loop
	DECFSZ BitBang, 1
	goto Blink

    ; Set RA5 to 0 (off)
    BCF PORTB, 5

    goto STATE_Q0

STATE_Q11
    ; Sets falling edge of pulse
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

