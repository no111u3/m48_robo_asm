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
; Internal hardware init ========================================
;================================================================

; Eternal hardware init =========================================
;================================================================

; Run ===========================================================
start:
		uart_snd_sbh_m Z, new_line, uart_snds
		uart_snd_sbh_m Z, start_msg, uart_snds
		uart_snd_sbh_m Z, new_line, uart_snds
; Display string from eeprom
		uart_snd_sbh_m Z, string_display, uart_snds
		rcall send_string_from_eeprom
		uart_snd_sbh_m Z, new_line, uart_snds
; Display counter, increment and store
		uart_snd_sbh_m Z, counter_display, uart_snds
		rcall send_counter_from_eeprom_increment
		uart_snd_sbh_m Z, new_line, uart_snds

; Infinity end loop =============================================
		rjmp pc
;================================================================
; uart send function
uart_snd_b_m r16, r21
; uart send string function
uart_snds:
uart_snd_sb_m Z, r16, uart_snd_b

bin_2_dec8:		; display 8-bit dec
	clr r17
bin_2_dec16:	; display 16-bit dec
bin_to_dec_m r16, r17, r18, r19, r20, r22, uart_snd_b

start_msg:
	.db "Display external eeprom writes by user ISP", 0xd, 0xa, 0
string_display:
	.db "String from eeprom: ", 0
counter_display:
	.db "Counter: ", 0
new_line:
	.db 0xd, 0xa, 0

; Display string from eeprom
send_string_from_eeprom:
		ldi r16, low(string)
		ldi r17, high(string)
send_loop:
		rcall EE_Read
		push r16
		push r17
		mov r16, r21
		mov r18, r21
		rcall uart_snd_b
		pop r17
		pop r16
		subi r16, (-1)
		sbci r17, (-1)
		cpi r18, 0
		brne send_loop

		ret

; Display counter from eeprom, increment and store
send_counter_from_eeprom_increment:
		ldi r16, low(counter)
		ldi r17, high(counter)
		rcall EE_Read
		mov r24, r21
		inc r16
		rcall EE_Read
		mov r25, r21
		mov r16, r24
		mov r17, r25
		rcall bin_2_dec16
		adiw r24, 1
		ldi r16, low(counter)
		ldi r17, high(counter)
		mov r21, r24
		rcall EE_Write
		inc r16
		mov r21, r25
		rcall EE_Write

		ret

; Write byte to eeprom
EE_Write:
		sbic EECR, EEWE		; Wait to write ready eeprom
		rjmp EE_Write

		cli					; disable interrupts

		out EEARL, r16		; write address of eeprom low and high
		out EEARH, r17		; byte address
		out EEDR, r21		; write data

		sbi EECR, EEMWE		; disable write protection
		sbi EECR, EEWE		; write data to eeprom

		sei					; enable interrupts

		ret

; Read byte from eeprom
EE_Read:
		sbic EECR, EEWE		; Wait to write read eeprom
		rjmp EE_Read

		out EEARL, r16		; write address of eeprom low and high
		out EEARH, r17		; byte address

		sbi EECR, EERE		; read data from eeprom
		in r21, EEDR		; read data to register

		ret

;****************************************************************
; Eeprom Data
;****************************************************************
.eseg
counter:
		.byte 2
string:
		.db "Hello, World!", 0xd, 0xa, "From eeprom", 0xd, 0xa, 0