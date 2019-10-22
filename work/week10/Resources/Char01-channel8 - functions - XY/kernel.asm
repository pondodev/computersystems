; Raspberry Pi B+,2 'Bare Metal' 16BPP Draw Pixel at any XY:
; 1. Setup Frame Buffer
;    assemble struct with screen requirements
;    receive pointer to screen or NULL
; 2. Start loop
;    Send pixel colour to location on screen
;    increment counter and loop if < 640

;note: r6 (colour) is 32-bit/4 byte register.
;at 16 bits/pixel, writing 32bits to adjacent pixels overwrites every second pixel.
; soln: write lower 2 bytes only (STRH) or lower byte(STRB).
;r0 = pointer + x * BITS_PER_PIXEL/8 + y * SCREEN_X * BITS_PER_PIXEL/8
format binary as 'img'
;constants

;memory addresses of BASE
BASE = $3F000000 ; 2
;BASE = $20000000 ; B+

org $8000
mov sp,$1000

mov r0,BASE
bl FB_Init
;r0 now contains address of screen
;SCREEN_X and BITS_PER_PIXEL are global constants populated by FB_Init
mov r7,r0 ;back-up a copy of the screen address

; Draw Pixel at (X,Y)
;r0 = address of screen we write to (r7 = backup of screen start address)

mov r4, #1 ;x ordinate
mov r5, #1 ;y

;set colour - while for 8BPP, Yellow for 16BPP
mov r9,BITS_PER_PIXEL
 cmp r9,#8; if BITS_PER_PIXEL == 8
 beq sp_eight
 ;assume 16
  mov r6,$FF00
  orr r6,$000E	; yellow
  b sp_endif
sp_eight:
  mov r6,#1   ;white for 8-bit colour
sp_endif:


lineloop:
   push {r0-r3}
   mov r0,r7	;screen address
   mov r1,r4 ;x
   mov r2,r5 ;y
   mov r3,r6 ;colour
      ;assume BITS_PER_PIXEL, SCREEN_X are shared constants
       bl drawpixel
   pop {r0-r3}

  ;call timer
  push {r0-r10}
   mov r0,BASE
   mov r1,$100
    bl TIMER
  pop {r0-r10}

;increment and test
  add r4,#1
  mov r8,SCREEN_X AND $FF00
  orr r8,SCREEN_X AND $00FF    ;640 = 0x0280
  cmp r4,r8
bls lineloop	  ;branch less than or same

;flash the LED to show we're almost finished
push {r0-r9}
 mov r0,BASE
 bl FLASH
pop {r0-r9}

;draw corners of screen
   push {r0-r3}
   mov r0,r7	;screen address
   mov r1,#1 ;x
   mov r2,#479 ;y
   mov r3,r6 ;colour
      ;assume BITS_PER_PIXEL, SCREEN_X are shared constants
       bl drawpixel
   pop {r0-r3}

   push {r0-r3}
   mov r0,r7	;screen address
   mov r1,#639 ;x
   mov r2,#479 ;y
   mov r3,r6 ;colour
      ;assume BITS_PER_PIXEL, SCREEN_X are shared constants
       bl drawpixel
   pop {r0-r3}


Loop:
  b Loop  ;wait forever

include "FBinit8.asm"
include "timer2_2Param.asm"
include "flash.asm"
include "drawpixel.asm"


