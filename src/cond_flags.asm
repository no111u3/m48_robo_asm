;****************************************************************
.include "m48def.inc"
.include "service.inc"

;****************************************************************
; Data
;****************************************************************
.dseg

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
start:
		cpi r16, 1	; compare r16 with 1
		breq ActionA; branch if equal
					; go forward if not
		cpi r16, 2	; compare r16 with 2
		breq ActionB; branch if equal
					; go forward if not
		cpi r16, 3	; compare r16 with 3
		breq ActionC; branch if equal
					; go forward if not
		rjmp NoAction; go to exit

ActionA:
		nop
		nop
		nop
		rjmp NoAction; go to exit

;---------------------------------------------------------------
Near:
		jmp FarFar_away
;---------------------------------------------------------------

ActionB:
		nop
		nop
		nop
		rjmp NoAction; go to exit

ActionC:
		nop
		nop
		nop

NoAction:
		nop

		sbrc r16, 3	; check bit 3 in r16 to clear and jump through cmd if yes
		rjmp bit_3_of_R16_Not_Zer0

		nop

		sbrs r16, 3	; check bit 3 in r16 to set and jump through cmd if yes
		rjmp bit_3_of_R16_Zer0

		nop

		uin r16, UCSR0C ; Read peripheral register to r16
		andi r16, 1 << 3; Apply mask 00001000 and set Z if bit 3 is clear

		breq bit_3_of_R16_Zer0



bit_3_of_R16_Not_Zer0:
bit_3_of_R16_Zer0:
		nop

FarFar_away:
		rjmp pc

;****************************************************************
; Eeprom Data
;****************************************************************
.eseg