BASE = $3F000000      ; base address for rpi 3B
GPIO_OFFSET = $200000 ; GPIO offset

mov r0, BASE
orr r0, GPIO_OFFSET   ; adding the offset to the base address

                      ; turning on GPIO18
mov r1, #1            ; write 1 into register 1
lsl r1, #24           ; shift it 24 times to get to the start bit for pin
str r1, [r0, #4]      ; write to the register

mov r1, #1            ; write 1 into register 1
lsl r1, #18           ; shift it 18 times to get to the write bit for the pin
str r1, [r0, #28]     ; enable write to the pin

                      ; turning on GPIO23
mov r1, #1            ; same deal as above but for pin 23
lsl r1, #9
str r1, [r0, #8]

mov r1, #1
lsl r1, #23
str r1, [r0, #28]

loop:                 ; loop infinitely so the program doesnt crash
b loop