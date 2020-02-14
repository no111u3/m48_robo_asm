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
		.equ XTAL = 8000000
		.equ baudrate = 38400
		.equ bauddivider = XTAL / 16 / baudrate-1

uart_init:
		setb DDRB, 1, r16	; DDRB.1 = 1
		setb DDRB, 2, r16	; DDRB.2 = 1

		sbi PORTB, 1
		sbi PORTB, 2

		outi UBRR0H, r16, high(bauddivider)
		outi UBRR0L, r16, low(bauddivider)
		
		

		outi UCSR0A, r16, 0
; Interrupts disabled, receive-transmit enabled
		outi UCSR0B, r16, 1 << RXEN0 | 1 << TXEN0 | 0 << RXCIE0 | 0 << TXCIE0 | 0 << UDRIE0
; Frame format - 8 bit
		outi UCSR0C, r16, 1 << UCSZ00 | 1 << UCSZ01
;================================================================

; Eternal hardware init =========================================
;================================================================

; Run ===========================================================
		cbi PORTB, 1
		cbi PORTB, 2



		ldi r16, 'E'		; load to temp register 'E' constant code
		rcall uart_snt
		ldi r16, 'X'
		rcall uart_snt


		;rjmp pc
Main:
		rcall uart_rcv		; wait byte from UART

		inc r16 			; increment received byte

		rcall uart_snt		; send byte to UART

		rjmp Main

		rjmp pc

; Send byte
uart_snt:
		sbi PORTB, 1

		uin r17, UCSR0A
		sbrs r17, UDRE0		; Skip if not ready to receive
		rjmp uart_snt

		uout UDR0, r16			; send byte

		cbi PORTB, 1

		ret

; Receive byte
uart_rcv:
		sbi PORTB, 2

		uin r17, UCSR0A
		sbrs r17, RXC0		; Skip if not ready to transmit
		rjmp uart_rcv

		uin r16, UDR0

		cbi PORTB, 2

		ret
;================================================================

;****************************************************************
; Eeprom Data
;****************************************************************
.eseg