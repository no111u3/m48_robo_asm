;****************************************************************
.include "m48def.inc"

;****************************************************************
; Data
;****************************************************************
.dseg
.org SRAM_START ; because avra ignores device specific segment placement address
data:
	.byte 2

;****************************************************************
; Code
;****************************************************************
.cseg
	rjmp reset

reset:
		lds r16, data
		lds r17, data+1
		sts data, r16
		sts data+1, r17


		rjmp pc

;****************************************************************
; Eeprom Data
;****************************************************************
.eseg