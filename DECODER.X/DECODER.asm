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

Start 
   BTFSC PORTA, 0
   call Count
   BTFSS PORTA, 2
   call Clear
goto Start

Count
   call Increment
   call Delay
   return
  
Clear
   BTFSS PORTA, 1
   CLRF PORTB
   return
		   
Increment
   MOVLW 0x01
   ADDWF PORTB
   return
		
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






