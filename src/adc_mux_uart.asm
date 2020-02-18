;****************************************************************
.include "m48def.inc"
.include "service.inc"
.include "display.inc"

;****************************************************************
; Data
;****************************************************************
.dseg
.org SRAM_START ; because avra ignores device specific segment placement address
RX_sel:
		.byte 1		; Send status
ADCH_sel:
		.byte 1		; Current ADC channel
ADCCH:
		.byte 8		; 8th bytes of ADC result

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
		rjmp RX_OK ; USART, RX Complete Handler
		reti 		;		rjmp USART_UDRE ; USART, UDR Empty Handler
		rjmp TX_OK ; USART, TX Complete Handler
		rjmp ADC_OK ; ADC Conversion Complete Handler
		reti 		;		rjmp EE_RDY ; EEPROM Ready Handler
		reti 		;		rjmp ANA_COMP ; Analog Comparator Handler
		reti 		;		rjmp TWI ; 2-wire Serial Interface Handler
		reti 		;		rjmp SPM_RDY ; Store Program Memory Ready Handler

; Receive interrupt handler =====================================
RX_OK:
		pushf			; Store SREG and r16

		uin r16, UDR0	; Get received byte from uart

		cpi r16, '0'	; case 0
		breq Ch_0
		cpi r16, '1'	; case 1
		breq Ch_1
		cpi r16, '2'	; case 2
		breq Ch_2

		ldi r16, 3		; default

		rjmp exit_rx

Ch_0:
		ldi r16, 0
		rjmp exit_rx

Ch_1:
		ldi r16, 1
		rjmp exit_rx

Ch_2:
		ldi r16, 2
		rjmp exit_rx

exit_rx:
		sts RX_sel, r16	; store selected channel
		push r16

; send selected channel information
		uart_snd_sbh_m Z, channel_sel_msg, uart_snds
		pop r16
		clr r22
		rcall bin_2_dec8

		uart_snd_sbh_m Z, channel_sel_msg_2, uart_snds

		popf

		reti

; Transmit interrupt handler ====================================
TX_OK:
		pushf
		push r17

		lds r17, RX_sel

		cpi r17, 0
		breq Send_0
		cpi r17, 1
		breq Send_1
		cpi r17, 2
		breq Send_2

		rjmp exit_tx

Send_0:
		lds r16, ADCCH
		rjmp send_data
Send_1:
		lds r16, ADCCH+1
		rjmp send_data
Send_2:
		lds r16, ADCCH+2
		rjmp send_data

send_data:
		push r16 ; store r16 with channel value
		push r17 ; store r17 with channel pointer

		uart_snd_sbh_m Z, channel_sel_msg, uart_snds
		pop r16 ; restore channel pointer into r17
		clr r22
		rcall bin_2_dec8

		uart_snd_sbh_m Z, channel_send_msg, uart_snds
		pop r16 ; restore channel value into r16
		clr r22
		rcall bin_2_dec8

		uart_snd_sbh_m Z, new_line, uart_snds
exit_tx:
		pop r17
		popf

		reti

; ADC Conversion Complete Handler ===============================
ADC_OK:
		pushf
		push zl
		push zh
		push r17

		uin r16, ADMUX		; Get value from ADMUX
		andi r16, 0x07		; Clear not mux bits

		mov r17, r16		; Store selected channel copy

		ldi zl, low(ADCCH)	; Get address of ADC channel storage
		ldi zh, high(ADCCH)

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
		andi r17, 0x7		; clear not needed part of bits

		or r16, r17			; add channel number to ADMUX configuration
		uout ADMUX, r16		; and store in to ADMUX

; start ADC conversion
		outi ADCSRA, r16, 1 << ADEN | 1 << ADIE | 1 << ADSC | 0 << ADATE | 3 << ADPS0
; restore registers, flags and exit
		pop r17
		pop zh
		pop zl
		popf

		reti

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

; ADC setup
; REFS0 - reference from AVcc with external capacitor at AREF pin
; ADLAR - left adjust result
; MUX0 = 0 - channel 0 selected
		outi ADMUX, r16, 1 << REFS0 | 1 << ADLAR | 0 << MUX0

		sei
;================================================================

; Eternal hardware init =========================================
;================================================================

; Run ===========================================================
start:
		uart_snd_sbh_m Z, start_msg, uart_snds

		; ADC init
; ADEN - enable ADC
; ADIE - allow interrupts
; ADSC - start conversion
; ADPS2..0 = 3 - clock divided by 8
		outi ADCSRA, r16, 1 << ADEN | 1 << ADIE | 1 << ADSC | 0 << ADATE | 3 << ADPS0
; Infinity end loop =============================================
		rjmp pc
;================================================================
; uart send function
uart_snd:
uart_snd_b_m r16, r21
; uart send string function
uart_snds:
uart_snd_sb_m Z, r16, uart_snd

bin_2_dec8:		; display 8-bit dec
	clr r17
bin_2_dec16:	; display 16-bit dec
bin_to_dec_m r16, r17, r18, r19, r20, r22, uart_snd

start_msg:
	.db "ADC muxed channel demo", 0xd, 0xa, 0
channel_sel_msg:
	.db "ADC channel #", 0
channel_sel_msg_2:
	.db " selected", 0xd, 0xa, 0
channel_send_msg:
	.db ": ", 0
new_line:
	.db 0xd, 0xa, 0

;****************************************************************
; Eeprom Data
;****************************************************************
.eseg