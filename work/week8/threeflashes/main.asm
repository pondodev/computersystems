BASE = $3F000000          ; base address for rpi 3B
GPIO_OFFSET = $200000     ; GPIO offset
TIMER_OFFSET = $3000      ; timer offset

mov r0, BASE
orr r0, GPIO_OFFSET

mov r1, #1                ; prep registers for writing to GPIO18
lsl r1, #24
str r1, [r0, #4]
mov r1, #1
lsl r1, #18               ; for turning on/off GPIO18

mov r3, BASE
orr r3, TIMER_OFFSET      ; get to timer register

loop:
  mov r2, #3 ; the amount of times we want to loop through
  mov r4, $20000            ; store delay

  innerloop:
    str r1, [r0, #28]

    ldrd r6, r7, [r3, #4]
    mov r5, r6

    timerone:
      ldrd r6, r7, [r3, #4]
      sub r8, r6, r5
      cmp r8, r4
    bls timerone

    str r1, [r0, #40]

    ldrd r6, r7, [r3, #4]
    mov r5, r6

    timertwo:
      ldrd r6, r7, [r3, #4]
      sub r8, r6, r5
      cmp r8, r4
    bls timertwo

    sub r2, #1 ; take 1 away from our count
    cmp r2, #0 ; check if we have looped the set amount of times
  bne innerloop

  mov r4, $80000 ; set new, longer delay
  ldrd r6, r7, [r3, #4]
  mov r5, r6

  timerthree:
    ldrd r6, r7, [r3, #4]
    sub r8, r6, r5
    cmp r8, r4
  bls timerthree
b loop