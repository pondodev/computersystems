; ldr r0, =0x3F200000 ; GPIO start address
; 
; mov r1, #1          ; enable write to GPIO18
; lsl r1, #24         ; bit 24 is the bit we write to for GPIO18 (see ref sheet)
; str r1, [r0,#4]     ; bit 24 is found from register at offset 4 (see ref sheet)
; 
; mov r1, #1          ; write 1 to GPIO18
; lsl r1, #18
; str r1, [r0,#28]    ; register to write bit to GPIO18 is located at offset 28 (see ref sheet)
BASE = $20000000
GPIO_OFFSET = $200000

mov r0, BASE
orr r0, GPIO_OFFSET ; sets r0 to 0x20200000
mov r1, #1
lsl r1, #18         ; writes 1 into r1, lsl 18 times to move the bit to 1 bit 18
str r1, [r0, #4]    ; write it into the 2nd (4/4+1) block of function register

mov r1, #1
lsl r1, #16         ; write 1 into r1, lsl 16 times to move 1 to bit 16
str r1, [r0, #40]   ; write it into the first block of pull-down register

loop$:
b loop$             ; loop forever
