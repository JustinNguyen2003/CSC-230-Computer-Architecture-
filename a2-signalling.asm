; a2-signalling.asm
; CSC 230: Fall 2022
;
; Student name: Justin Nguyen
; Student ID: V00978867
; Date of completed work: October 31st, 2022
;
; *******************************
; Code provided for Assignment #2
;
; Author: Mike Zastre (2022-Oct-15)
;
 
; This skeleton of an assembly-language program is provided to help you
; begin with the programming tasks for A#2. As with A#1, there are "DO
; NOT TOUCH" sections. You are *not* to modify the lines within these
; sections. The only exceptions are for specific changes changes
; announced on Brightspace or in written permission from the course
; instructor. *** Unapprov   ed changes could result in incorrect code
; execution during assignment evaluation, along with an assignment grade
; of zero. ****

.include "m2560def.inc"
.cseg
.org 0

; ***************************************************
; **** BEGINNING OF FIRST "STUDENT CODE" SECTION ****
; ***************************************************

	; initializion code will need to appear in this
    ; section
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16

	ldi r16, 0xFF
	sts DDRL, r16
	out DDRB, r16


; ***************************************************
; **** END OF FIRST "STUDENT CODE" SECTION **********
; ***************************************************

; ---------------------------------------------------
; ---- TESTING SECTIONS OF THE CODE -----------------
; ---- TO BE USED AS FUNCTIONS ARE COMPLETED. -------
; ---------------------------------------------------
; ---- YOU CAN SELECT WHICH TEST IS INVOKED ---------
; ---- BY MODIFY THE rjmp INSTRUCTION BELOW. --------
; -----------------------------------------------------

	rjmp test_part_e
	; Test code


test_part_a:
	ldi r16, 0b00100001
	rcall set_leds
	rcall delay_long

	clr r16
	rcall set_leds
	rcall delay_long

	ldi r16, 0b00111000
	rcall set_leds
	rcall delay_short

	clr r16
	rcall set_leds
	rcall delay_long

	ldi r16, 0b00100001
	rcall set_leds
	rcall delay_long

	clr r16
	rcall set_leds

	rjmp end


test_part_b:
	ldi r17, 0b00101010
	rcall slow_leds
	ldi r17, 0b00010101
	rcall slow_leds
	ldi r17, 0b00101010
	rcall slow_leds
	ldi r17, 0b00010101
	rcall slow_leds

	rcall delay_long
	rcall delay_long

	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds

	rjmp end

test_part_c:
	ldi r16, 0b11111000
	push r16
	rcall leds_with_speed
	pop r16

	ldi r16, 0b11011100
	push r16
	rcall leds_with_speed
	pop r16

	ldi r20, 0b00100000
test_part_c_loop:
	push r20
	rcall leds_with_speed
	pop r20
	lsr r20
	brne test_part_c_loop

	rjmp end


test_part_d:
	ldi r21, 'E'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	ldi r21, 'A'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long


	ldi r21, 'M'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	ldi r21, 'H'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	rjmp end


test_part_e:
	ldi r25, HIGH(WORD00 << 1)
	ldi r24, LOW(WORD00 << 1)
	rcall display_message
	rjmp end

end:
    rjmp end






; ****************************************************
; **** BEGINNING OF SECOND "STUDENT CODE" SECTION ****
; ****************************************************

set_leds:

	push ZH
	push ZL
	push r16
	push r17
	push r18

	in ZH, SPH
	in ZL, SPL

	ldd r16, Z+3
	
	clr r17
	clr r18

	sbrc r16, 5
	ori r17, 0b00000010

	sbrc r16, 4
	ori r17, 0b00001000

	sbrc r16, 3
	ori r18, 0b00000010

	sbrc r16, 2
	ori r18, 0b00001000

	sbrc r16, 1
	ori r18, 0b00100000

	sbrc r16, 0
	ori r18, 0b10000000

	out PORTB, r17
	sts PORTL, r18

	pop r18
	pop r17
	pop r16
	pop ZL
	pop ZH


	ret


slow_leds:
	push ZH
	push ZL
	push r16
	push r17

	in ZH, SPH
	in ZL, SPL

	ldd r17, Z+1 

	mov r16, r17

	rcall set_leds
	rcall delay_long

	clr r16
	rcall set_leds

	pop r16
	pop r17
	pop ZL
	pop ZH
	ret


fast_leds:
	push ZH
	push ZL
	push r16
	push r17

	in ZH, SPH
	in ZL, SPL

	ldd r17, Z+1
	
	mov r16, r17

	rcall set_leds
	rcall delay_short


	

	clr r16
	rcall set_leds

	pop r17
	pop r16
	pop ZL
	pop ZH

	ret


leds_with_speed:
	push ZH
	push ZL
	push r16
	push r17
	push r18

	in ZH, SPH
	in ZL, SPL

	ldd r18, Z+9

	mov r17, r18
	mov r16, r18

	sbrc r18, 7
	;mov r16,r16
	;sbrc r18, 6
	rcall slow_leds
	;sbrs r18,7
	;mov r16,r16
	sbrs r18,6
	rcall fast_leds

	pop r18
	pop r17
	pop r16
	pop ZL
	pop ZH

	ret


; Note -- this function will only ever be tested
; with upper-case letters, but it is a good idea
; to anticipate some errors when programming (i.e. by
; accidentally putting in lower-case letters). Therefore
; the loop does explicitly check if the hyphen/dash occurs,
; in which case it terminates with a code not found
; for any legal letter.

encode_letter:
	push YH
	push YL
	push ZH
	push ZL
	push r19
	push r20
	push r21

	in YH, SPH
	in YL, SPL

	ldd r19, Y+11
	clr r21
	clr r25

	ldi ZH, high(PATTERNS<<1)
	ldi ZL, low(PATTERNS<<1)

	lpm r20, Z
	ldi r21, 0b00100000

	find_letter:
		cp r20,r19
		breq set_lights
		adiw Z, 8
		lpm r20, Z
		rjmp find_letter

	set_lights:
		adiw Z, 1
		lpm r20, Z
		cpi r21, 0
		breq duration
		cpi r20, 0x6f
		breq light_on
		lsr r21
		rjmp set_lights
	
	light_on:
		or r25, r21
		lsr r21
		rjmp set_lights

	duration:
		lpm r20, Z+1
		sbrc r20, 0
		ori r25, 0b11000000
		
	pop r21
	pop r20
	pop r19
	pop ZL
	pop ZH
	pop YL
	pop YH
	
	ret 


display_message:
	push ZH
	push ZL
	push r24
	push r25

	in ZH, SPH
	in ZL, SPL

	mov ZH, r25
	mov ZL, r24

	lpm r20, Z

	word_loop:
		;lpm r20, Z
		;push ZH
		;push ZL
		;push r24
		push r20
		rcall encode_letter
		pop r20
		push r25
		rcall leds_with_speed
		rcall delay_short
		rcall delay_short
		;rcall delay_long
		pop r25
		;pop r20
		;pop r24
		;pop ZL
		;pop ZH
		;TST r20
		;brne word_loop
		cpi r20,0
		breq done
		adiw Z, 1
		lpm r20, Z
		rjmp word_loop
		

	done:
		pop r25
		pop r24
		pop ZL
		pop ZH
	ret


; ****************************************************
; **** END OF SECOND "STUDENT CODE" SECTION **********
; ****************************************************




; =============================================
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; =============================================

; about one second
delay_long:
	push r16

	ldi r16, 14
delay_long_loop:
	rcall delay
	dec r16
	brne delay_long_loop

	pop r16
	ret


; about 0.25 of a second
delay_short:
	push r16

	ldi r16, 4
delay_short_loop:
	rcall delay
	dec r16
	brne delay_short_loop

	pop r16
	ret

; When wanting about a 1/5th of a second delay, all other
; code must call this function
;
delay:
	rcall delay_busywait
	ret


; This function is ONLY called from "delay", and
; never directly from other code. Really this is
; nothing other than a specially-tuned triply-nested
; loop. It provides the delay it does by virtue of
; running on a mega2560 processor.
;
delay_busywait:
	push r16
	push r17
	push r18

	ldi r16, 0x08
delay_busywait_loop1:
	dec r16
	breq delay_busywait_exit

	ldi r17, 0xff
delay_busywait_loop2:
	dec r17
	breq delay_busywait_loop1

	ldi r18, 0xff
delay_busywait_loop3:
	dec r18
	breq delay_busywait_loop2
	rjmp delay_busywait_loop3

delay_busywait_exit:
	pop r18
	pop r17
	pop r16
	ret


; Some tables
.cseg
.org 0x600

PATTERNS:
	; LED pattern shown from left to right: "." means off, "o" means
    ; on, 1 means long/slow, while 2 means short/fast.
	.db "A", "..oo..", 1
	.db "B", ".o..o.", 2
	.db "C", "o.o...", 1
	.db "D", ".....o", 1
	.db "E", "oooooo", 1
	.db "F", ".oooo.", 2
	.db "G", "oo..oo", 2
	.db "H", "..oo..", 2
	.db "I", ".o..o.", 1
	.db "J", ".....o", 2
	.db "K", "....oo", 2
	.db "L", "o.o.o.", 1
	.db "M", "oooooo", 2
	.db "N", "oo....", 1
	.db "O", ".oooo.", 1
	.db "P", "o.oo.o", 1
	.db "Q", "o.oo.o", 2
	.db "R", "oo..oo", 1
	.db "S", "....oo", 1
	.db "T", "..oo..", 1
	.db "U", "o.....", 1
	.db "V", "o.o.o.", 2
	.db "W", "o.o...", 2
	.db "W", "oo....", 2
	.db "Y", "..oo..", 2
	.db "Z", "o.....", 2
	.db "-", "o...oo", 1   ; Just in case!

WORD00: .db "HELLOWORLD", 0, 0
WORD01: .db "THE", 0
WORD02: .db "QUICK", 0
WORD03: .db "BROWN", 0
WORD04: .db "FOX", 0
WORD05: .db "JUMPED", 0, 0
WORD06: .db "OVER", 0, 0
WORD07: .db "THE", 0
WORD08: .db "LAZY", 0, 0
WORD09: .db "DOG", 0

; =======================================
; ==== END OF "DO NOT TOUCH" SECTION ====
; =======================================

