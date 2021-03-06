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
; PC5 - output, always enable
; PC4 - output, enable if button is pressed
; PC3 - input, pulluped
		ldi r16, (1 << PC5) | (1 << PC3); Set Pin 5 and 3 Port C to high
		ldi r17, (1 << DDC5) | (1 << DDC4) ; Set Pin 5 and 4 Port C to output
		uout PORTC, r16
		uout DDRC, r17
;================================================================

; Eternal hardware init =========================================
;================================================================

; Run ===========================================================
Main:
		uin r16, PINC	; Read PINC to tmp
		
		sbrs r16, PINC3	; check Pin 3 to clear
		cbi PORTC, PC4	; disable Pin 4 if cleared

		sbrc r16, PINC3 ; check Pin 3 to set
		sbi PORTC, PC4	; enable Pin 4 if setted

		rjmp Main
		rjmp pc
;================================================================

;****************************************************************
; Eeprom Data
;****************************************************************
.eseg