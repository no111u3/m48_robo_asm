;****************************************************************
.include "m48def.inc"
.include "service.inc"

.macro xri
		ldi @2, @1
		eor @0, @2
.endm

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
		reti 		;		rjmp USART_RXC ; USART, RX Complete Handler
		reti 		;		rjmp USART_UDRE ; USART, UDR Empty Handler
		reti 		;		rjmp USART_TXC ; USART, TX Complete Handler
		reti 		;		rjmp ADC ; ADC Conversion Complete Handler
		reti 		;		rjmp EE_RDY ; EEPROM Ready Handler
		reti 		;		rjmp ANA_COMP ; Analog Comparator Handler
		reti 		;		rjmp TWI ; 2-wire Serial Interface Handler
		reti 		;		rjmp SPM_RDY ; Store Program Memory Ready Handler
reset:
		sset RAMEND
start:
		cp r16, r17	; Compare two values A and B
; A >= B branches
		brcs action_b ; if A >= B than C flag is clear
; A > B branches
		breq action_b ; if A > B, jump to else if equal
		brcs action_b ; if A > B, jump to else if A less B
; C < A AND A < B branches
		cp r16, r18	; Compare two values A and C
		breq action_b ; if C = A
		brcs action_b ; if C > A

		cp r16, r17 ; Compare two values A and B
		brcc action_b ; if A > B or A = B

action_a:
		nop
		nop
		nop
		rjmp next_action

action_b:
		nop
		nop
		nop

next_action:
		nop
		nop

; set bit in io register
		uin r17, TWCR
		xri r17, 3 << 1 | 2 << 1, r16
		uout TWCR, r17

; cout enable bits in byte
		clr r18		; clear counter of ones
		ldi r17, 9	; cycle counter
		ldi r16, 0xaa ; counted byte
		clc			; clear C clag

loop:
		dec r17		; substraction loop counter
		breq end	; if loop counter is zero exit

		rol r16		; shift byte
		brcc loop	; if C flag is zero skip iteration

		inc r18		; increment ones counter
		rjmp loop

end:
		nop

		rjmp pc

;****************************************************************
; Eeprom Data
;****************************************************************
.eseg