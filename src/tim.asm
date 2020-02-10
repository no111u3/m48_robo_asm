;****************************************************************
.include "m48def.inc"
.include "service.inc"

.macro incm
		lds r16, @0
		lds r17, @0+1

		subi r16,(-1)
		sbci r17,(-1)

		sts @0, r16
		sts @0+1, r17
.endm

;****************************************************************
; Data
;****************************************************************
.dseg
.org SRAM_START ; because avra ignores device specific segment placement address
ccnt:
	.byte 2
tcnt:
	.byte 2
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
		rjmp TIM0_OVF ; Timer0 Overflow Handler
		reti 		;		rjmp SPI_STC ; SPI Transfer Complete Handler
		reti 		;		rjmp USART_RXC ; USART, RX Complete Handler
		reti 		;		rjmp USART_UDRE ; USART, UDR Empty Handler
		reti 		;		rjmp USART_TXC ; USART, TX Complete Handler
		reti 		;		rjmp ADC ; ADC Conversion Complete Handler
		reti 		;		rjmp EE_RDY ; EEPROM Ready Handler
		reti 		;		rjmp ANA_COMP ; Analog Comparator Handler
		reti 		;		rjmp TWI ; 2-wire Serial Interface Handler
		reti 		;		rjmp SPM_RDY ; Store Program Memory Ready Handler

; Timer0 Overflow Handler =======================================
TIM0_OVF:
		pushf
		push r17

		incm tcnt

		pop r17
		popf

		reti

reset:
		sset RAMEND
		regram_clear SRAM_START, RAMEND+1
start:
; Internal hardware init ========================================

		setb DDRC, 5, r16	; DDRC.5 = 1
		setb DDRC, 4, r16	; DDRC.6 = 1

		setb PORTC, 3, r16	; PORC.3 = 1
		clrb DDRC, 3, r16	; DDRC.3 = 0

		setb TIMSK0, TOIE0, r16 ; Enable Timer0 interrupt

		ldi r16, 1 << CS00 ; Start Timer0, prescale to 1.
		uout TCCR0B, r16

		sei					; Enable interrupts

;================================================================

; Eternal hardware init =========================================
;================================================================

; Main ==========================================================
Main:
		sbis pinc, 3	; check button if pressed
		rjmp BT_Push	; jump to push button handler

		setb PORTC, 5, r16	; Enable led 1

Next:
		lds r16, tcnt
		lds r17, tcnt+1

		cpi r16, 0x0 ; Compare by byte
		brne NoMatch
		cpi r17, 0x10
		brne NoMatch

Match:
		invb PORTC, 4, r16, r17	; Switch led 2

; Clear counter, with clear timer0 cnt register
		clr r16

		cli			; disable interrupts for atomic operations

		uout TCNT0, r16 ; clear timer0 counter
		sts tcnt, r16	; clear program counter
		sts tcnt+1, r16

		sei			; enable interrupts

NoMatch:
		nop
		incm ccnt

		rjmp Main

BT_Push:
		clrb PORTC, 5, r16	; Disable led 1

		rjmp Next

		rjmp pc
;================================================================

;****************************************************************
; Eeprom Data
;****************************************************************
.eseg