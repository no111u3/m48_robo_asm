;******************************************************************************
.include "m48def.inc"
.include "std/io.inc"
.include "std/ram.inc"
.include "std/stack.inc"
.include "std/vectors.inc"

;******************************************************************************
; Data
;******************************************************************************
.dseg
adc_channels:
		.byte 6		; 6th bytes of ADC result - sensors channels

;******************************************************************************
; Code
;******************************************************************************
.cseg

; Interrupt vector table ======================================================
.define reti_dummy_use
		int_vectors

; Reset Handler ===============================================================
reset_handler:
		setup_stack RAMEND ; Setup stack to the end of ram
		clear_ram_regs SRAM_START, RAMEND+1 ; Clear ram and registers

; Hardware configuration defines ==============================================
; System clock configuration
.equ XTAL = 8000000
; Prefered baudrate
.equ baudrate = 19200
; Baudrate divider for uart
.equ bauddivider = XTAL / 16 / baudrate-1
;==============================================================================

; Internal hardware init ======================================================
; Uart startup init
		outir UBRR0H, r16, high(bauddivider)
		outir UBRR0L, r16, low(bauddivider)
		
		outir UCSR0A, r16, 0
; Interrupts enabled, receive-transmit enabled
		outir UCSR0B, r16, 1 << RXEN0 | 1 << TXEN0 | 1 << RXCIE0 | 1 << TXCIE0 | 0 << UDRIE0
; Frame format - 8 bit
		outir UCSR0C, r16, 1 << UCSZ00 | 1 << UCSZ01

; ADC setup
; REFS0 - reference from AVcc with external capacitor at AREF pin
; ADLAR - left adjust result
; MUX0 = 0 - channel 0 selected
		outir ADMUX, r16, 1 << REFS0 | 1 << ADLAR | 0 << MUX0

		sei
;==============================================================================

; Eternal hardware init =======================================================
;==============================================================================

; Run =========================================================================
start:

; Infinity end loop ===========================================================
		rjmp pc
;==============================================================================

;******************************************************************************
; Eeprom Data
;******************************************************************************
.eseg