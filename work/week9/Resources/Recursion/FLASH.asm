; flash function -- will flash the LED on GPIO18 a set amount of times
; r0 = GPIO base address
; r1 = num of times to flash
; returns nothing
flash:
  loop$:
    mov r2,#1
    lsl r2,#18
    str r2,[r0,#28]  ; turn LED on
    mov r3,$0F0000

    push {lr, r0, r1, r2, r3, r4, r5}
    bl TIMER
    pop {lr, r0, r1, r2, r3, r4, r5}
    
    mov r2,#1
    lsl r2,#18
    str r2,[r0,#40]  ; turn LED off
    mov r3,$0F0000

    push {lr, r0, r1, r2, r3, r4, r5}
    bl TIMER
    pop {lr, r0, r1, r2, r3, r4, r5}

  sub r1,#1
  cmp r1,#0
  bne  loop$  ; end of outer loop. Runs r1 times
bx lr