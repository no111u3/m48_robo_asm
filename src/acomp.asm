;****************************************************************
.include "m48def.inc"
.include "service.inc"

;****************************************************************
; Data
;****************************************************************
.dseg
.org SRAM_START ; because avra ignores device specific segment placement address

;****************************************************************
; Code
;****************************************************************
.cseg

; Interrupt vector table ========================================
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
		rjmp COMP_OK ; Analog Comparator Handler
		reti 		;		rjmp TWI ; 2-wire Serial Interface Handler
		reti 		;		rjmp SPM_RDY ; Store Program Memory Ready Handler

; Comparator Handler ============================================
COMP_OK:
		pushf		; store flags
		push r17	; store r17

		invb PORTB, 1, r17, r16	; invert bit 1 port B

		pop r17		; restore r17
		popf		; and flags

		reti

; Reset Handler =================================================
reset:
		sset RAMEND ; Setup stack to the end of ram
		regram_clear SRAM_START, RAMEND+1 ; Clear ram and registers
; Internal hardware init ========================================
; Setup comparator
; Triggering on rising and falling edge, enable interrupts
		outi ACSR, r16, 1 << ACBG | 1 << ACIE | 1 << ACIS1 | 1 << ACIS0
; Enable comparator
		outi ADCSRB, r16, 1 << ACME
; Setup input from ADC MUX 5 channel
		outi ADMUX, r16, 5
; Enable output port
		setb DDRB, 1, r16	; DDRB.1 = 1

		sei
;================================================================

; Eternal hardware init =========================================
;================================================================

; Run ===========================================================
start:

; Infinity end loop =============================================
		rjmp pc
;================================================================

;****************************************************************
; Eeprom Data
;****************************************************************
.eseg