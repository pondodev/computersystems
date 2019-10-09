BASE = $3F000000

;Calculate
mov r1,#4 ; input
mov sp,$1000 ; make room on the stack
mov r0,r1  
bl FACTORIAL
mov r7,r0 ; store answer
bl init ; initialise GPIO base address and GPIO18 for output

mov r1, r7 ; store amount of flashes
bl flash ; flash the LED
wait:
b wait

include "TIMER.asm"
include "factorialj.asm"
include "INIT.asm"
include "FLASH.asm"