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
mov r4, 524288            ; store delay

loop:
  str r1, [r0, #28]       ; turn on GPIO18

  ldrd r6, r7, [r3, #4]   ; store current time
  mov r5, r6              ; store our start time

  timerone:
    ldrd r6, r7, [r3, #4] ; get current time
    sub r8, r6, r5        ; subtract start time from current time and store in r8
    cmp r8, r4            ; check if remaining time is == to delay
  bls timerone            ; loop back if remaining time <= delay

  str r1, [r0, #40]       ; turn GPIO18 off

  ldrd r6, r7, [r3, #4]   ; reuse timer
  mov r5, r6

  timertwo:
    ldrd r6, r7, [r3, #4] ; same deal with the previous timer
    sub r8, r6, r5
    cmp r8, r4
  bls timertwo
b loop