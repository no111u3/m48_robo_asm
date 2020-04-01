;******************************************************************************
.include "m48def.inc"
.include "std/convert.inc"
.include "std/io.inc"
.include "std/ram.inc"
.include "std/serial.inc"
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
.define ADCC_int
.define UTXC_int
		int_vectors

; ADC Conversion Complete Handler ===============================
ADCC_handler:
		pushr16sr
		push zl
		push zh
		push r17

		uin r16, ADMUX		; Get value from ADMUX
		andi r16, 0x07		; Clear not mux bits

		mov r17, r16		; Store selected channel copy

		ldi zl, low(adc_channels)	; Get address of ADC channel storage
		ldi zh, high(adc_channels)

		add zl, r16			; Add channel number to pointer

		clr r16				; we get a flag but value not needed

		adc zh, r16			; Add higher part of pointer

		uin r16, ADCL		; lower part of ADC value not needed
							; but need to read it
		uin r16, ADCH		; higher part of ADC value used
		st z, r16			; store it to pointer

		uin r16, ADMUX		; get ADMUX value
		andi r16, 0xf8		; but clear channel part

		inc r17				; increment channel number

		cpi r17, 0x6		; compare channel number with limit
		brlo no_clear		; if number great or equal 6, clear channel number
		clr r17

no_clear:
		andi r17, 0x7		; clear not needed part of bits
		or r16, r17			; add channel number to ADMUX configuration
		uout ADMUX, r16		; and store in to ADMUX

; start ADC conversion
		outir ADCSRA, r16, 1 << ADEN | 1 << ADIE | 1 << ADSC | 0 << ADATE | 3 << ADPS0
; restore registers, flags and exit
		pop r17
		pop zh
		pop zl
		popr16sr

		reti

; Transmit interrupt handler ==================================================
UTXC_handler:
		pushr16sr
		push zl
		push zh

		uart_sends_invoke uart_sends, channel_values_msg

		ldi zl, low(adc_channels)	; Get address of ADC channel storage
		ldi zh, high(adc_channels)

print_values:
		ld r16, z				; load channel value
		rcall bin_2_dec8		; convert from binary to decimal and ouput it
								; to serial port
		cpi zl, low(adc_channels+5)	; if channel is 5
		brge exit				; exit

		inc zl					; else increment channel
		push zh					; store index register
		push zl

		uart_sends_invoke uart_sends, channel_delim_msg ; print delimiter
		pop zl					; restore index register
		pop zh

		rjmp print_values		; print next channels

exit:
		uart_sends_invoke uart_sends, new_line ; print new line

		pop zh
		pop zl
		popr16sr

		reti

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
		uart_sends_invoke uart_sends, start_msg
; ADC init
; ADEN - enable ADC
; ADIE - allow interrupts
; ADSC - start conversion
; ADPS2..0 = 3 - clock divided by 8
		outir ADCSRA, r16, 1 << ADEN | 1 << ADIE | 1 << ADSC | 0 << ADATE | 3 << ADPS0
; Infinity end loop ===========================================================
		rjmp pc
;==============================================================================
; uart send byte function
uart_sendb:
uart_sendb_def r16, r21
; uart send string function
uart_sends:
uart_send_fstring_def r16, uart_sendb
; display 8-bit dec
bin_2_dec8:
	clr r17
; display 16-bit dec
bin_2_dec16:
bin_to_dec_def r16, r17, r18, r19, r20, r22, uart_sendb

start_msg:
	.db "Light Follower Sensors demo", 0xd, 0xa, 0
channel_values_msg:
	.db "ADC channels values: ", 0
channel_delim_msg:
	.db ", ", 0
new_line:
	.db 0xd, 0xa, 0
;******************************************************************************
; Eeprom Data
;******************************************************************************
.eseg