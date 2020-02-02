;****************************************************************

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
; LDI low register
;****************************************************************
.macro ldil
		push r17		; load higher register to stack
		ldi r17, @1		; load value to it
		mov @0, r17		; move from it to needed register
		pop r17			; restore it value
.endm
