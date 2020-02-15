;****************************************************************
.include "m48def.inc"
.include "service.inc"


.macro sendm
		ldi @0, low(2*@2) ; get string address
		ldi @1, high(2*@2)

		sts StrPtr, @0		; store it to ram
		sts StrPtr+1, @1

		outi UCSR0B, @0, 1 << RXEN0 | 1 << TXEN0 | 1 << RXCIE0 | 1 << TXCIE0 | 1 << UDRIE0

wait:
		uin r17, UCSR0B
		sbrc r17, UDRIE0		; Skip if not ready to transmit
		rjmp wait
.endm


;****************************************************************
; Data
;****************************************************************
.dseg
.org SRAM_START ; because avra ignores device specific segment placement address
StrPtr:
		.byte 2

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
		rjmp RX_OK 	; USART, RX Complete Handler
		rjmp UD_OK 	; USART, UDR Empty Handler
		rjmp TX_OK	; USART, TX Complete Handler
		reti 		;		rjmp ADC ; ADC Conversion Complete Handler
		reti 		;		rjmp EE_RDY ; EEPROM Ready Handler
		reti 		;		rjmp ANA_COMP ; Analog Comparator Handler
		reti 		;		rjmp TWI ; 2-wire Serial Interface Handler
		reti 		;		rjmp SPM_RDY ; Store Program Memory Ready Handler

; Receive interrupt handler ====================================
RX_OK:
		pushf			; push sreg and r16

		uin r16, UDR0	; get value from UDR0

Rx_Exit:
		popf			; pop sreg and r16
		reti

; UDR0 Empty interrupt handler =================================
UD_OK:
		sbi PORTB, 1
		pushf			; push sreg and r16
		push zl			; store register Z
		push zh

		lds zl, StrPtr	; load pointer to string into register Z
		lds zh, StrPtr+1

		lpm r16, Z+		; load byte from flash

		cpi r16, 0		; compare with 0 (end of string)
		breq STOP_RX

		uout UDR0, r16	; send byte trough uart

		sts StrPtr, zl	; store pointer of string to RAM
		sts StrPtr+1, zh

Exit_RX:
		pop zh			; restore from stack everything
		pop zl
		popf

		cbi PORTB, 1

		reti
; End of transmit
STOP_RX:
		; disable interrupt UDR0
		outi UCSR0B, r16, 1 << RXEN0 | 1 << TXEN0 | 1 << RXCIE0 | 1 << TXCIE0 | 0 << UDRIE0
		rjmp Exit_RX

; Transmit interrupt handler ====================================
TX_OK:
		reti

Hello_Message:
		.db "EEPROM write tests", 0xa, 0xd, 0
Write_Message:
		.db "Write 0x42 to EEPROM", 0xa, 0xd, 0
Read_Message:
		.db "Read 0x42 from EEPROM", 0xa, 0xd, 0
Read_Message_Failure:
		.db "Read 0x42 from EEPROM failed", 0xa, 0xd, 0

reset:
		sset RAMEND
		regram_clear SRAM_START, RAMEND+1
start:
; Internal hardware init ========================================
		.equ XTAL = 8000000
		.equ baudrate = 19200
		.equ bauddivider = XTAL / 16 / baudrate-1

uart_init:
		setb DDRB, 1, r16	; DDRB.1 = 1
		setb DDRB, 2, r16	; DDRB.2 = 1

		sbi PORTB, 1
		sbi PORTB, 2

		outi UBRR0H, r16, high(bauddivider)
		outi UBRR0L, r16, low(bauddivider)
		
		

		outi UCSR0A, r16, 0
; Interrupts enabled, receive-transmit enabled
		outi UCSR0B, r16, 1 << RXEN0 | 1 << TXEN0 | 1 << RXCIE0 | 1 << TXCIE0 | 0 << UDRIE0
; Frame format - 8 bit
		outi UCSR0C, r16, 1 << UCSZ00 | 1 << UCSZ01

		sei
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

Main:
		sendm r16, r17, Hello_Message
; Write 0x42 to eeprom
		sendm r16, r17, Write_Message

		ldi r16, 0x0 	; Write to address 0x0
		ldi r17, 0x0
		ldi r21, 0x42 	; Write 0x42 to address 0x0
		rcall EEWrite

; Read 0x42 from eeprom
		sendm r16, r17, Read_Message

		ldi r16, 0x0 ; Read from address 0x0
		ldi r17, 0x0
		ldi r21, 0x0
		rcall EERead

; Check writed byte to equal 0x42
		cpi r21, 0x42 ; Check to equal 0x42
		breq Exit

		sendm r16, r17, Read_Message_Failure

Exit:
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

; Write byte to eeprom
EEWrite:
		sbic EECR, EEWE		; Wait to write ready eeprom
		rjmp EEWrite

		cli					; disable interrupts

		out EEARL, r16		; write address of eeprom low and high
		out EEARH, r17		; byte address
		out EEDR, r21		; write data

		sbi EECR, EEMWE		; disable write protection
		sbi EECR, EEWE		; write data to eeprom

		sei					; enable interrupts

		ret

; Read byte from eeprom
EERead:
		sbic EECR, EEWE		; Wait to write read eeprom
		rjmp EERead

		out EEARL, r16		; write address of eeprom low and high
		out EEARH, r17		; byte address

		sbi EECR, EERE		; read data from eeprom
		in r21, EEDR		; read data to register

		ret

;================================================================

;****************************************************************
; Eeprom Data
;****************************************************************
.eseg