; TIMER
; no args
TIMER_OFFSET = $3000
DELAY = $20000
TIMER:
  mov r0, BASE
  orr r0, TIMER_OFFSET ; timer address
  mov r1, DELAY ; store delay
  ldrd r2, r3, [r0, #4] ; store the start time
  mov r4, r2 ; store least significant 32-bits of start time in r4
  
  timerdelay:
    ldrd r2, r3, [r0, #4] ; store the current time
    sub r5, r2, r4 ; r5 = current time - start time
    cmp r5, r1
  bls timerdelay ; goto timerdelay if r5 <= delay
bx lr
