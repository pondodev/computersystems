format binary as 'img'	;must be first
mov sp,$1000 ;initialise stack pointer
;momentary switch swaps LEDs
org $8000
;GPIOs:
;pin 17: +3.3v
;pin 19: GPI10	(input)

;NC: pin 19 not connected (GPIO 10)
;Pull-up: pin 19 connected to +3.3V (pin 17)


BASE = $3F000000 ; Use $3F000000 for 2
GPIO_OFFSET = $200000
mov r0,BASE
orr r0,GPIO_OFFSET ;Base address of GPIO
ldr r1,[r0,#4] ;read function register for GPIO 10 - 19
bic r1,r1,#27  ;bit clear  27 = 9 * 3	 = read access
str r1,[r0,#4];10 input
;set up outputs
ldr r10,[r0,#12]  ;RED LED
orr r10, $8000	;set bit 15
str r10,[r0,#12] ; 35 output

ldr r2,[r0,#16]    ;green LED
orr r2, $200000  ;set bit 21
str r2,[r0,#16] ; 47 output
;set up input
mov r1,#1
lsl r1,#10  ;bit 10 to enable input GPIO10
;activate LED
mov r2,#1
lsl r2,#15  ;bit 15 = 47-32 to enable green
;disable red
mov r10,#1
lsl r10,#3   ;bit 3 = 35-32	 red
;poll GPIO10 and swap LEDS if high
loop$:
;read first block of GPIOs
ldr r9,[r0,#52] ;read gpios 0-31
tst r9,#1024  ; use tst to check bit 10
bne red ;if ==0
;else green
str r2,[r0,#32] ;Turn on ACT LED
b cont
red:
str r10,[r0,#32] ;Turn on RED LED
cont:
;call timer
push {r0-r3}
mov r0,BASE
mov r1,$70000
orr r1,$0A100
orr r1,$00020	;TIMER_MICROSECONDS = 500,000
bl Delay
pop {r0-r3}
;str r1,[r0,#40]  ;turn off ACT LED
ldr r9,[r0,#52] ;read gpios 0-31
tst r9,#1024  ; use tst to check bit 10
bne red2 ; if ==0
;else
str r2,[r0,#44] ;Turn off Green LED
b cont2
red2:
str r10,[r0,#44] ;Turn off RED LED
cont2:

;call timer
push {r0-r3}
mov r0,BASE
mov r1,$70000
orr r1,$0A100
orr r1,$00020	;TIMER_MICROSECONDS = 500,000
bl Delay
pop {r0-r3}

b loop$

include "timer2_2Param.asm"
