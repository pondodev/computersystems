; init function -- sets up GPIO18 for writing and retrieves GPIO base address
; no arguments
; returns BASE + GPIO_OFFSET
GPIO_OFFSET = $200000
init:
  mov r0,BASE
  orr r0,GPIO_OFFSET
  mov r1,#1
  lsl r1,#24
  str r1,[r0,#4] ; set GPIO18 to output
bx lr