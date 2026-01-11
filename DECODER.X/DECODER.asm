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
MOVLW 0x07
MOVWF TRISA
MOVLW 0X00
MOVWF TRISB
BCF STATUS, 5
CLRF PORTA
CLRF PORTB

STATE_Q0
    BTFSS PORTA, 1
    goto STATE_Q0 ; if RA1 = 0, stay in STATE Q0 there are no pulses
    
    goto STATE_Q1 ; if RA1 = 1, goto STATE_Q1 there are pulses
    
STATE_Q1

    BTFSC PORTA, 2
    goto STATE_Q3  ; if RA2 = 1, Proceed to STATE_Q3
    
    goto STATE_Q2 ; if RA2 = 0, Proceed to STATE_Q2

; NON-CUMULATIVE MODE    
STATE_Q2    
    ; Clear display back to 0000 0000 
    CLRF PORTB
    
    BTFSC PORTA, 0
    goto STATE_Q3 ; if RA0 = 1, proceed to STATE_Q3
    
    goto STATE_Q2 ; if RA0 = 0, stay in STATE_Q2 

; CUMULATIVE MODE    
STATE_Q3
    BTFSC PORTA, 0
    call STATE_Q4 ; if RA0 = 1, proceed to STATE_Q4

    ; Stay here while sender is still sending pulses
    BTFSC PORTA, 1
    goto STATE_Q3 ; if RA1 = 1, stay in STATE_Q3

    ; All pulses have been received
    goto STATE_Q0 ; RA0 = 0, return to STATE_Q0 

STATE_Q4
   ; Increments display by 1 for every pulse  
   MOVLW 0x01
   ADDWF PORTB
   call Delay
   return
  
Clear
   call Delay
   BTFSS PORTA, 1
   CLRF PORTB
   return
		
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