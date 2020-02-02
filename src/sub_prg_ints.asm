;****************************************************************
.include "m48def.inc"
.include "service.inc"

;****************************************************************
; Data
;****************************************************************
.dseg

;****************************************************************
; Code
;****************************************************************
.cseg
.org 0x000
		rjmp reset 	; Reset Handler
		reti 		;		rjmp EXT_INT0 ; IRQ0 Handler
		reti 		;		rjmp EXT_INT1 ; IRQ1 Handler
		reti 		;		rjmp PCINT0 ; PCINT0 Handler
		reti 		;		rjmp PCINT1 ; PCINT1 Handler
		reti 		;		rjmp PCINT2 ; PCINT2 Handler
		reti 		;		rjmp WDT ; Watchdog Timer Handler
		reti 		;		rjmp TIM2_COMPA ; Timer2 Compare A Handler
		reti 		;		rjmp TIM2_COMPB ; Timer2 Compare B Handler
		reti 		;		rjmp TIM2_OVF ; Timer2 Overflow Handler
		reti 		;		rjmp TIM1_CAPT ; Timer1 Capture Handler
		reti 		;		rjmp TIM1_COMPA ; Timer1 Compare A Handler
		reti 		;		rjmp TIM1_COMPB ; Timer1 Compare B Handler
		reti 		;		rjmp TIM1_OVF ; Timer1 Overflow Handler
		reti 		;		rjmp TIM0_COMPA ; Timer0 Compare A Handler
		reti 		;		rjmp TIM0_COMPB ; Timer0 Compare B Handler
		reti 		;		rjmp TIM0_OVF ; Timer0 Overflow Handler
		reti 		;		rjmp SPI_STC ; SPI Transfer Complete Handler
		rjmp rx_ok 	; USART, RX Complete Handler
		reti 		;		rjmp USART_UDRE ; USART, UDR Empty Handler
		reti 		;		rjmp USART_TXC ; USART, TX Complete Handler
		reti 		;		rjmp ADC ; ADC Conversion Complete Handler
		reti 		;		rjmp EE_RDY ; EEPROM Ready Handler
		reti 		;		rjmp ANA_COMP ; Analog Comparator Handler
		reti 		;		rjmp TWI ; 2-wire Serial Interface Handler
		reti 		;		rjmp SPM_RDY ; Store Program Memory Ready Handler

;----------------------------------------------------------------
; Interrupt Handler
rx_ok:
		push r16		; store r16
		in r16, sreg	; store sreg
		push r16
		push r17		; store r17

		uin r16, UDR0	; Read UDR register
		cpi r16, 10
		breq ten
		rjmp rx_exit

ten:
		ldi r17, 't'
		uout UDR0, r17

rx_exit:
		pop r17
		pop r16
		out sreg, r16
		pop r16
		reti 			; Return from interrupt handler
;----------------------------------------------------------------

reset:
		sset RAMEND

		.equ Byte = 50
		.equ Delay = 20

		ldi r16, Byte
start:
		uout UDR0, r16

		rcall wait
		uout UDR0, r16

		rcall wait
		uout UDR0, r16

		rcall wait

		sei				; enable interrupts
		ldi r17, (1<<RXCIE0); enable receive usart interrupt
		uout UCSR0B, r17


		rjmp start
		rjmp pc

wait:
		ldi r17, Delay	; load delay value
m1:		
		dec r17			; decrementing by 1
		nop				; nop
		brne m1			; check to zero end jump to m1 if not
		ret 		    ; return from sub program

;****************************************************************
; Eeprom Data
;****************************************************************
.eseg