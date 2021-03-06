;******************************************************************************
.include "m48def.inc"
.include "std/convert.inc"
.include "std/io.inc"
.include "std/ram.inc"
.include "std/serial.inc"
.include "std/stack.inc"
.include "std/vectors.inc"

; directions
.equ front = 3
.equ front_left = 4
.equ front_right = 2
.equ back = 0
.equ left = 5
.equ right = 1

;******************************************************************************
; Data
;******************************************************************************
.dseg
adc_channels:
		.byte 6		; 6th bytes of ADC result - sensors channels
processed:
		.byte 6		; 6th bytes of processed result
direction:
		.byte 1		; direction indicator

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
							
		rcall sensors_process ; after get values process it


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

; Process sensors values ======================================================
sensors_process:
		push yl
		push yh
		push r17
		push r16

		ldi yl, low(adc_channels) ; load address of adc channel storage
		ldi yh, high(adc_channels)

		ldi zl, low(processed)	; load address of processed storage
		ldi zh, high(processed)

process_iter:
		ld r17, y			; load ad value
		ser r16				; load 0xff to r16
		sub r16, r17		; inverstion of value: 0xff - channel value
		st z, r16			; store to pressed

		cpi yl, low(adc_channels+5) ; if channel is 5
		brge calc_direction	; exit from process

		inc yl				; else increment channel and processed
		inc zl				; pointer

		rjmp process_iter	; and repeat iteration

calc_direction:
		push r18

		ldi r16, 0			; store 0 value for max value
		ldi r17, 0			; store 0 index for max value
		ldi zl, low(processed) ; reset index for processed

find_direction:
		ld r18, z			; load value to tmp register
		cp r18, r16			; compare value with max value

		brlo skip_iter		; if current value < max -> skip iteration

		mov r16, r18		; else copy value
		mov r17, zl			; and its index
		subi r17, low(processed) ; fix index

skip_iter:
		cpi zl, low(processed+5) ; if channel is 5
		brge exit_process	; exit from find direction

		inc zl				; increment processed value

		rjmp find_direction

exit_process:
		ldi zl, low(direction) ; store direction
		ldi zh, high(direction)
		st z, r17

		pop r18
		pop r16
		pop r17
		pop yh
		pop yl
		ret

; Transmit interrupt handler ==================================================
UTXC_handler:
		pushr16sr
		push zl
		push zh

		uart_sends_invoke uart_sends, channel_values_msg

		ldi zl, low(processed)	; Get address of ADC channel storage
		ldi zh, high(processed)

print_values:
		ld r16, z				; load channel value
		rcall bin_2_dec8		; convert from binary to decimal and ouput it
								; to serial port
		cpi zl, low(processed+5)	; if channel is 5
		brge show_direction		; exit

		inc zl					; else increment channel
		push zh					; store index register
		push zl

		uart_sends_invoke uart_sends, channel_delim_msg ; print delimiter
		pop zl					; restore index register
		pop zh

		rjmp print_values		; print next channels

show_direction:
		uart_sends_invoke uart_sends, channel_delim_msg

		ldi zl, low(direction)	; load direction
		ldi zh, high(direction)
		ld r16, z

		cpi r16, front
		breq display_front
		cpi r16, back
		breq display_back
		cpi r16, left
		breq display_left
		cpi r16, right
		breq display_right
		cpi r16, front_left
		breq display_front_left

		uart_sends_invoke uart_sends, front_right_msg
		rjmp exit

display_front:
		uart_sends_invoke uart_sends, front_msg
		rjmp exit
display_back:
		uart_sends_invoke uart_sends, back_msg
		rjmp exit
display_left:
		uart_sends_invoke uart_sends, left_msg
		rjmp exit
display_right:
		uart_sends_invoke uart_sends, right_msg
		rjmp exit
display_front_left:
		uart_sends_invoke uart_sends, front_left_msg

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
	.db "Light Follower Navigation demo", 0xd, 0xa, 0
channel_values_msg:
	.db "processed channels values: ", 0
channel_delim_msg:
	.db ", ", 0
new_line:
	.db 0xd, 0xa, 0
front_msg:
	.db "front", 0xd, 0xa, 0
front_left_msg:
	.db "front left", 0xd, 0xa, 0
front_right_msg:
	.db "front right", 0xd, 0xa, 0
back_msg:
	.db "back", 0xd, 0xa, 0
left_msg:
	.db "left", 0xd, 0xa, 0
right_msg:
	.db "right", 0xd, 0xa, 0
;******************************************************************************
; Eeprom Data
;******************************************************************************
.eseg