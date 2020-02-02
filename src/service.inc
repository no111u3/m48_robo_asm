;****************************************************************

;****************************************************************
; Universal port output
;****************************************************************
.macro uout
.if		@0 < 0x40
		out	@0, @1
.else
		sts	@0, @1
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
