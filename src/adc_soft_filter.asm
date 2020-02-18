;****************************************************************
.include "m48def.inc"
.include "service.inc"
.include "display.inc"

; Some definitions for usefully
.def ADSH = r15		; higher byte of summ
.def ADSL = r14		; lower byte of summ
.def ACT = r13		; counter of average values
.def SUMH = r12		; out register high byte
.def SUML = r11		; out register low byte

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
		rjmp RX_OK ; USART, RX Complete Handler
		reti 		;		rjmp USART_UDRE ; USART, UDR Empty Handler
		rjmp TX_OK ; USART, TX Complete Handler
		rjmp ADC_OK ; ADC Conversion Complete Handler
		reti 		;		rjmp ANA_COMP ; Analog Comparator Handler
		reti 		;		rjmp TWI ; 2-wire Serial Interface Handler
		reti 		;		rjmp SPM_RDY ; Store Program Memory Ready Handler


; Transmit interrupt handler ====================================
TX_OK:
		pushf
; Average operation: divide by 64 - 2^6=64, 6 shifts
		clc
		ror SUMH
		ror SUML

		clc
		ror SUMH
		ror SUML

		clc
		ror SUMH
		ror SUML

		clc
		ror SUMH
		ror SUML

		clc
		ror SUMH
		ror SUML

		clc
		ror SUMH
		ror SUML
; After average we get 10 bit number in registers, but we need 8bit
; for output
		clc
		ror SUMH
		ror SUML

		clc
		ror SUMH
		ror SUML
; Output value to serial port
		uart_snd_sbh_m Z, channel_send_msg, uart_snds
		mov r16, SUML
		clr r22
		rcall bin_2_dec8

		uart_snd_sbh_m Z, new_line, uart_snds

		popf

		reti

; Receive interrupt handler =====================================
RX_OK:
		pushf			; Store SREG and r16

		uin r16, UDR0
		cpi r16, 's'	; if s - stop ADC
		breq StopADC

		cpi r16, 'r'	; else if r - run it
		breq RunADC

; Start ADC for continuous conversion and start UART for receive
RunADC:
		outi UCSR0B, r16, 1 << RXEN0 | 1 << TXEN0 | 1 << RXCIE0 | 1 << TXCIE0
		outi ADCSRA, r16, 1 << ADEN | 1 << ADIE | 1 << ADSC | 1 << ADATE | 3 << ADPS0
		outi UDR0, r16, 'R'
		rjmp ExitRX

; Stop ADC and disable UART
StopADC:
		outi ADCSRA, r16, 0 << ADEN | 0 << ADIE | 0 << ADSC | 0 << ADATE | 3 << ADPS0
		outi UCSR0B, r16, 1 << RXEN0 | 1 << TXEN0 | 1 << RXCIE0 | 0 << TXCIE0
		outi UDR0, r16, 'S'
		rjmp ExitRX

ExitRX:
		popf

		reti

; ADC Conversion Complete Handler ===============================
ADC_OK:
		pushf

		uin r16, ADCL		; Get value from ADC
		uin r17, ADCH
; Adding pair r16:r17 with n-1 value.

		add ADSL, r16
		adc ADSH, r17
; in ADSH:ADSL will be accumulated summ ADSH:ADSL(n) + ADSH:ADSL(n+1)
; max value of 10 bit ADC is 1024, 65536/1024 = 64
; we count to 64 and upload value from summator to output registers.
		dec ACT		; Count samples
		brne Exit

		mov SUML, ADSL	; Store to output register
		mov SUMH, ADSH

		clr ADSL		; Clear summator
		clr ADSH

		ldi r16, 64		; Store to counter new value
		mov ACT, r16

Exit:

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
		outi UCSR0B, r16, 1 << RXEN0 | 1 << TXEN0 | 1 << RXCIE0 | 0 << TXCIE0 | 0 << UDRIE0
; Frame format - 8 bit
		outi UCSR0C, r16, 1 << UCSZ00 | 1 << UCSZ01

; ADC setup
; REFS0 - reference from AVcc with external capacitor at AREF pin
; MUX0 = 0 - channel 0 selected
		outi ADMUX, r16, 1 << REFS0 | 0 << MUX0

		ldi r16, 64		; Store to counter new value
		mov ACT, r16

		sei
;================================================================

; Eternal hardware init =========================================
;================================================================

; Run ===========================================================
start:
		uart_snd_sbh_m Z, start_msg, uart_snds
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
	.db "ADC soft filter demo", 0xd, 0xa, 0
channel_send_msg:
	.db "ADC channel filtered value: ", 0
new_line:
	.db 0xd, 0xa, 0

;****************************************************************
; Eeprom Data
;****************************************************************
.eseg