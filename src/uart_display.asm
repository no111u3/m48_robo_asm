;****************************************************************
.include "m48def.inc"
.include "service.inc"
.include "display.inc"

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
		reti 		;		rjmp ANA_COMP ; Analog Comparator Handler
		reti 		;		rjmp TWI ; 2-wire Serial Interface Handler
		reti 		;		rjmp SPM_RDY ; Store Program Memory Ready Handler

; Reset Handler =================================================
reset:
		sset RAMEND ; Setup stack to the end of ram
		regram_clear SRAM_START, RAMEND+1 ; Clear ram and registers
; Internal hardware init ========================================
		.equ XTAL = 8000000
		.equ baudrate = 19200
		.equ bauddivider = XTAL / 16 / baudrate-1

uart_init:
		outi UBRR0H, r16, high(bauddivider)
		outi UBRR0L, r16, low(bauddivider)
		
		

		outi UCSR0A, r16, 0
; Interrupts enabled, receive-transmit enabled
		outi UCSR0B, r16, 1 << RXEN0 | 1 << TXEN0 | 1 << RXCIE0 | 1 << TXCIE0 | 0 << UDRIE0
; Frame format - 8 bit
		outi UCSR0C, r16, 1 << UCSZ00 | 1 << UCSZ01

;================================================================

; Eternal hardware init =========================================
;================================================================

; Run ===========================================================
start:
		uart_snd_sbh_m Z, new_line, uart_snds
		uart_snd_sbh_m Z, start_msg, uart_snds
		uart_snd_sbh_m Z, new_line, uart_snds
; Display byte
		uart_snd_sbh_m Z, hex_display, uart_snds
		ldi r16, 0x42
		rcall bin_2_hex8

		uart_snd_sbh_m Z, new_line, uart_snds

		uart_snd_sbh_m Z, hex_display_word, uart_snds
		ldi r16, 0x34
		ldi r17, 0x25
		rcall bin_2_hex16

		uart_snd_sbh_m Z, new_line, uart_snds

		uart_snd_sbh_m Z, hex_display_3bytes, uart_snds
		ldi r16, 0x12
		ldi r17, 0x34
		ldi r18, 0x56
		rcall bin_2_hex24

		uart_snd_sbh_m Z, new_line, uart_snds

		uart_snd_sbh_m Z, hex_display_dword, uart_snds
		ldi r16, 0x87
		ldi r17, 0x65
		ldi r18, 0x43
		ldi r19, 0x21
		rcall bin_2_hex32

		uart_snd_sbh_m Z, new_line, uart_snds

; Infinity end loop =============================================
		rjmp pc
;================================================================
; uart send function
uart_snd:
uart_snd_b_m r16, r21
; uart send string function
uart_snds:
uart_snd_sb_m Z, r16, uart_snd

; display hex format
bin_2_hex32:	; display 32-bit hex
bin_to_hex_append_m r16, bin_2_hex8, r19

bin_2_hex24:	; display 24-bit hex
bin_to_hex_append_m r16, bin_2_hex8, r18

bin_2_hex16:	; display 16-bit hex
bin_to_hex_append_m r16, bin_2_hex8, r17

bin_2_hex8:		; display 8-bit hex
bin_to_hex_m r16, uart_snd

start_msg:
	.db "Display format demo", 0xd, 0xa, 0
hex_display:
	.db "Display byte as hex: 0x", 0
hex_display_word:
	.db "Display word as hex: 0x", 0
hex_display_3bytes:
	.db "Display 3 bytes as hex: 0x", 0
hex_display_dword:
	.db "Display double word as hex: 0x", 0
new_line:
	.db 0xd, 0xa, 0

;****************************************************************
; Eeprom Data
;****************************************************************
.eseg