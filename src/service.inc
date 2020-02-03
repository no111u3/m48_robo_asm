;****************************************************************

;****************************************************************
; Setup stack pointer
;****************************************************************
.macro sset
		ldi r16, low(@0); load to r16 low address of stack begin
		out spl, r16	; store it to stack pointer low

		ldi r16, high(@0); load to r16 high address of stack begin
		out sph, r16	; store it to stack pointer high
.endm

;****************************************************************
; Setup registers and ram
;****************************************************************
.macro regram_clear
; Clearing RAM
		ldi zl, low(@0)	; Begin clearing RAM address
		ldi zh, high(@0)
		clr r16			; clear r16
Flush:
		st z+, r16		; store 0 to memory address
		cpi zh, high(@1); compare with high address of end RAM
		brne Flush

		cpi zl, low(@1)	; compare with low address of end RAM
		brne Flush

		clr zl
		clr zh
; Clearing registers
		ldi zl, 30		; Address of higher register
		clr zh
		dec zl			; decrementing address
		st z, zh		; store 0 to register
		brne pc-2
.endm

;****************************************************************
; Universal port output
;****************************************************************
.macro uout
.if		@0 < 0x40		; check out register address
		out	@0, @1		; out operation if address less than 0x40
.else
		sts	@0, @1		; sts operation if address more or equal 0x40
.endif
.endm

;****************************************************************
; Universal port input
;****************************************************************
.macro uin
.if		@1 < 0x40		; check in register address
		in	@0, @1		; in operation if address less than 0x40
.else
		lds	@0, @1		; lds operation if address more or equal 0x40
.endif
.endm

;****************************************************************
; LDI low register
;****************************************************************
.macro ldil
		push r17		; load higher register to stack
		ldi r17, @1		; load value to it
		mov @0, r17		; move from it to needed register
		pop r17			; restore it value
.endm
