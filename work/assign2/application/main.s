.section .data
fizz:     .ascii "fizz\n"
buzz:     .ascii "buzz\n"
fizzbuzz: .ascii "fizzbuzz\n"
number:   .ascii "number\n"

.section .text
.globl _start

_start:
  // we'll just go from 1-30 for this program
  mov r0, #1 // this will be our index to check against
  loop:
    push {r0} // store index on the stack while we don't need it

    // this will work by checking for both fizz and buzz. if we get fizz, we add 1 to r1.
    // if we get buzz, we add 2 to r1. so that way we can deduce the following:
    // 0 = number
    // 1 = fizz
    // 2 = buzz
    // 3 = fizzbuzz
    // based on the value of r1 then, we will be able to print the appropriate word to screen

    // check out values
    mov r1, #0
    bl checkfizz
    bl checkbuzz

    // now we can start printing stuff
    cmp r1, #0
    bleq saynumber
    cmp r1, #1
    bleq sayfizz
    cmp r1, #2
    bleq saybuzz
    cmp r1, #3
    bleq sayfizzbuzz

    pop {r0}   // get our index back
    add r0, #1 // increment index by 1
    cmp r0, #31
    bne loop   // loop back if we're not done

  b return     // once we are done with the application
  
sayfizz:
  push {lr}
  ldr r1, =fizz
  mov r2, #5 // length of word
  bl print
  pop {lr}
  bx lr

saybuzz:
  push {lr}
  ldr r1, =buzz
  mov r2, #5 // length of word
  bl print
  pop {lr}
  bx lr

sayfizzbuzz:
  push {lr}
  ldr r1, =fizzbuzz
  mov r2, #9 // length of word
  bl print
  pop {lr}
  bx lr

saynumber:
  push {lr}
  ldr r1, =number
  mov r2, #7 // length of word
  bl print
  pop {lr}
  bx lr

print:
  mov r7, #4  // sys_write
  mov r0, #1  // stdout
  swi 0
  bx lr

// parameters:
// r0 = number
// r1 = current result
//
// return values:
// r1 = result
checkfizz:
  push {lr}
  push {r0, r1}
  mov r1, #3
  bl isdivisible // check if r0 is divisible by 3
  pop {r0, r1}
  cmp r3, #1
  addeq r1, #1   // add 1 to result if is divisible
  pop {lr}
  bx lr

// parameters:
// r0 = number
// r1 = current result
//
// return values:
// r1 = result
checkbuzz:
  push {lr}
  push {r0, r1}
  mov r1, #5
  bl isdivisible // check if r0 is divisible by 5
  pop {r0, r1}
  cmp r3, #1
  addeq r1, #2   // add 2 to result if is divisible
  pop {lr}
  bx lr

// parameters:
// r0 = number
// r1 = divisor
//
// return values:
// r3 = true (1) false (0)
isdivisible:
  push {r0, r2}
  udiv r2, r0, r1 // store division result in r2
  mul r2, r1      // multiply result by divisor
  mov r3, #0      // store a false return value
  cmp r2, r0      // check if r2 == r0
  addeq r3, #1    // add one to our return value if they are equal
  pop {r0, r2}
  bx lr

return:
  mov r7, #1
  swi 0
