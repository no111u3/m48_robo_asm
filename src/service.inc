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
; Push r16 and status register
;****************************************************************
.macro pushf
		push r16
		in r16, sreg
		push r16
.endm

;****************************************************************
; Pop r16 and status register
;****************************************************************
.macro popf
		pop r16
		out sreg, r16
		pop r16
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
; Set bit with stack
;****************************************************************
.macro setbm
.if		@0 < 0x20
		sbi @0, @1
.else
		push r17
		uin r17, @0
		ori r17, 1 << @1
		uout @0, r17
		pop r17
.endif
.endm

;****************************************************************
; Set bit with reg
;****************************************************************
.macro setb
.if		@0 < 0x20
		sbi @0, @1
.else
		uin @2, @0
		ori @2, 1 << @1
		uout @0, @2
.endif
.endm

;****************************************************************
; Clear bit with stack
;****************************************************************
.macro clrbm
.if		@0 < 0x20
		cbi @0, @1
.else
		push r17
		uin r17, @0
		andi r17, ~(1 << @1)
		uout @0, r17
		pop r17
.endif
.endm

;****************************************************************
; Clear bit with reg
;****************************************************************
.macro clrb
.if		@0 < 0x20
		cbi @0, @1
.else
		uin @2, @0
		andi @2, ~(1 << @1)
		uout @0, @2
.endif
.endm

;****************************************************************
; Invert bit with stack
;****************************************************************
.macro invbm
		push r16
		push r17
		uin r16, @0
		ldi r17, 1 << @1
		eor r17, r16
		uout @0, r17
		pop r17
		pop r16
.endm

;****************************************************************
; Invert bit with reg
;****************************************************************
.macro invb
		uin @2, @0
		ldi @3, 1 << @1
		eor @3, @2
		uout @0, @3
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
