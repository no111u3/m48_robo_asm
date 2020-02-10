;****************************************************************
.include "m48def.inc"
.include "service.inc"

.macro incr
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
counter:
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
		regram_clear SRAM_START, RAMEND+1
start:
; Internal hardware init ========================================

		setb DDRC, 5, r16	; DDRC.5 = 1
		setb DDRC, 4, r16	; DDRC.6 = 1

		setb PORTC, 3, r16	; PORC.3 = 1
		clrb DDRC, 3, r16	; DDRC.3 = 0

;================================================================

; Eternal hardware init =========================================
;================================================================

; Main ==========================================================
Main:
		sbis pinc, 3	; check button if pressed
		rjmp BT_Push	; jump to push button handler

		setb PORTC, 5, r16	; Enable led 1

Next:
		lds r16, counter
		lds r17, counter+1

		cpi r16, 0x0 ; Compare by byte
		brne NoMatch
		cpi r17, 0x0
		brne NoMatch

Match:
		invb PORTC, 4, r16, r17	; Switch led 2

NoMatch:
		nop
		incr counter

		rjmp Main

BT_Push:
		clrb PORTC, 5, r16	; Disable led 1

		rjmp Next

		rjmp pc
;================================================================

; Procedure =====================================================
.equ LowByte = 255
.equ MedByte = 255
.equ HighByte = 7

Delay:
		ldi r16, LowByte	; Load three bytes of delay
		ldi r17, MedByte
		ldi r18, HighByte

loop:
		subi r16, 1			; substract 1
		sbci r17, 0			; substract C flag
		sbci r18, 0			; substract C flag

		brcc loop			; if not cary go to begin of loop

		ret

;================================================================

;****************************************************************
; Eeprom Data
;****************************************************************
.eseg