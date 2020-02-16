;*************************************************************
; Bin to hex conversion
; @0 - store input byte
; @1 - output byte function
;*************************************************************
.macro bin_to_hex_m
bin_to_hex:
	swap @0			; swap nibbles because output in inverted order
	rcall bin_to_hex_convert ; calling conversion for high nibble
	swap @0			; swap nibbles for conversion lower nibble

bin_to_hex_convert:
	push @0
	andi @0, 0x0f	; clear high nibble
	cpi @0, 10		; check for lower than 10 (0xa)
	brcs non_high_10
	subi @0, -7		; add 7 to change from digit to letter

non_high_10:
	subi @0, -0x30	; add 0x30 for start from '0'
	rcall @1		; calling output function @0 store current digit
	pop @0

	ret
.endm

;****************************************************************
; Uart blocking send byte
; @0 - output byte
; @1 - check tmp register
;****************************************************************
.macro uart_snd_b_m
uart_snd_b:
		uin @1, UCSR0A
		sbrs @1, UDRE0		; Skip if not ready to receive
		rjmp uart_snt

		uout UDR0, @0			; send byte

		cbi PORTB, 1

		ret
.endm

;****************************************************************
; Uart blocking send string from flash helper
; @0 - index output register
; @1 - string pointer in flash
; @2 - output string function
;****************************************************************
.macro uart_snd_sbh_m
		ldi @0l, low(2*@1)	; load pointer to string into register Z
		ldi @0h, high(2*@1)
		rcall @2
.endm

;****************************************************************
; Uart blocking send string from flash
; @0 - index output register
; @1 - store data register
; @2 - output byte function
;****************************************************************
.macro uart_snd_sb_m
uart_snd_sb:
		lpm @1, @0+		; load byte from flash

		cpi @1, 0		; compare with 0 (end of string)
		breq stop_transmit

		rcall @2; send byte trough function

stop_transmit:
		ret
.endm

;****************************************************************
; Uart - blocking receive byte
; @0 - input register
; @1 - check tmp register
;****************************************************************
.macro uart_rcv_b_m
uart_rcv_b:
		uin @1, UCSR0A
		sbrs @1, RXC0		; Skip if not ready to transmit
		rjmp uart_rcv_b

		uin @0, UDR0

		ret
.endm