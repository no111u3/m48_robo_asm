;****************************************************************
.include "m48def.inc"
.include "service.inc"

;****************************************************************
; Data
;****************************************************************
.dseg
variables:		.byte 3
variables2:		.byte 1
;****************************************************************
; Code
;****************************************************************
.cseg

.org 0x000
		rjmp reset

reset:
; Initialization of stack
		ldi r16, low(RAMEND)
		out spl, r16

		ldi r16, high(RAMEND)
		out sph, r16

; Read variable
		lds r16, variables 		; first byte
		lds r17, variables+1	; second byte
		lds r18, variables+2	; third byte

; AVR doesn't can adding the constant (only substraction)
		subi r16,(-1)
		sbci r17,(-1)
		sbci r18,(-1)

		sts variables, r16
		sts variables+1, r17
		sts variables+2, r18

; Second method of calc
; Read variable address to Y register
		ldi yl, low(variables)
		ldi yh, high(variables)

; Load variables with incrementing address
		ld r16, y+
		ld r17, y+
		ld r18, y+

; AVR doesn't can adding the constant (only substraction)
		subi r16,(-1)
		sbci r17,(-1)
		sbci r18,(-1)		

; Reverse store variables with decrementing address
		st -y, r18
		st -y, r17
		st -y, r16

		ldi r17, variables2
		push r17
		pop r0

		ldil r0, 18

; Load variable from program memory (mul 2 because address in program words)
		ldi zl, low(data*2)
		ldi zh, high(data*2)

		lpm r16, z

		rjmp pc

data:
		.db 12, 34, 45, 23

;****************************************************************
; Eeprom Data
;****************************************************************
.eseg