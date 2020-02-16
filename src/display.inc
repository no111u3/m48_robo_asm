;*************************************************************
; Bin to hex conversion (8 bit value to be converted)
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

;*************************************************************
; Bin to hex conversion append (n*8 bit value to be converted)
; @0 - store input byte
; @1 - hex conversion function
; @2 - append register input Nth byte
;*************************************************************
.macro bin_to_hex_append_m
		push @0
		mov @0, @2
		rcall @1
		pop @0
.endm

;*************************************************************
; Bin to dec conversion (16 bin value to be converted)
; Use Horner's algorithm for converting
; @0 - store lower part of number
; @1 - store higher part of number
; @2 - first tmp value
; @3 - second tmp value
; @4 - third tmp value
; @5 - string len
; @6 - output byte function
;*************************************************************
.macro bin_to_dec_m
bin_to_dec:			;16 bit entry
		clr @4      ;digit counter
bd1:
		inc @4      ;---- decimal string generating loop
		clr @2      ;@1 /= 10;
		ldi @3,16   ;
bd2:
		lsl @0      ; V(D)/10
		rol @1      ; @1:@0 - quotient
		rol @2      ; @2 -  remnant
		cpi @2,10   ; check to 10
		brcs bd3    ;
		subi @2,10  ; substract 10 to calculate number
		inc @0      ; add @0 for end polynome
bd3:
		dec @3      ;
		brne bd2    ;/
		subi @2,-'0';Push the remander (a decimal digit)
		push @2     ;/
		cp @0, @3   ;if(var =! 0)
		cpc @1, @3  ; continue digit loop;
		brne bd1    ;/
bd4:
		cp @4,@5    ;Adjust string length (this can be removed for auto-length)
		brcc bd5    ;
		inc @4      ;
		ldi @0,' '  ;
		push @0     ;
		rjmp bd4    ;/
bd5:
		pop @0      ;Put decimal string
		rcall @6    ;<-- Put a char (@0) to memory, console or any display device
		dec @4      ;
		brne bd5    ;/

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
		rjmp uart_snd_b

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

		rjmp uart_snd_sb

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