# computer systems week 9 lecture notes

## functions

- not native to assembly
  - but we can simulate it easily
- application binary interface (ABI) sets standard way of using arm registers
  - r0-3 for function args and return values
    - r0 and r1 are for passing the first two args to functions, and return results of functions. if the function doesn't use them for a return value they can take any value after a function.
  - r4-12 promised not to be altered by functions
    - general purpose
  - r14 is the return address
  - **lr** and **sp** used for stack management
    - sp == r13
  - **pc** is the next instruction -- we can use it to exit a function call
    - pc == r15
- sometimes we need to use registers in pairs for 64 bit values

## calling functions

- by convention, the first two function arguments are loaded into r0 and r1
- the next two are put into r2 and r3
- the return value of the function is written into r0 and r1 (little endian)
- the function promises to not alter r4-12
- however if we need more space to work with, we can use the stack
  - push the registers to keep onto the stack pop them off when the function returns

```assembly
push {r0, r1} ; push r0 and r1 onto the stack
; do some stuff here
pop {r0, r1}  ; must be the same order as when we pushed

push {r0} ; however if we do this...
pop {r1}  ; ... this would put r0's value into r1
```

- arm asm doesn't have call and return operations
  - we need to simulate it with branch operations
- **lr** (link register) contains the address of the next instruction after a function call
  - we use this to tell the  code what to runs after a function finished
  - the current address of code to be run is stored in the program counter (**pc**). setting this to the value in **lr** makes the program resume after a function has finished

```assembly
functionlabel:
  ; do stuff
  mov pc, lr ; set pc to the next line of the caller
```

- or we can also

```assembly
functionlabel:
  push {lr}
  ; do something
  pop {pc}
```

- then when we want to call it

```assembly
bl functionlabel
```

## a delay function

```assembly
delay:
  push {lr}
  mov r3, $3F000000
  orr r3, $00003000
  mov r4, $800000       ; ~0.5s delay
  ldrd r6, r7, [r3, #4]
  mov r5, r6

  loopt1:
    ldrd r6, r7, [r3, #4]
    sub r8, r6, r5
    cmp r8, r4
  bls loopt1
  pop {pc}              ; return
```

## passing arguments

- to re-use registers we need to:
  - back up registers we need to re-use in a function
  - store args for the function in r0-3
  - call the function
  - read the return values from r0-1
  - restore the registers we backed up

```assembly
str r1, [r0, #32]
push {r0, r1} ; store the values we have in r0 and r1 on the stack
mov r0, BASE ; get our arguments
mov r1, $80000
bl delay ; call our delay function

pop {r0, r1} ; restore the registers to how they were before
```

- args allow us to re-use code which is good design. this allows for the code to be more portable between different models of rpi

## stack

- because the rpi has a software stack, we need to initialise it before we can push/pop

```assembly
mov sp, $1000 ; value we mov in is the space allocated. keep it to a power of 2
```

## includes

- allows us to use multiple source files
- `include` will combine each of the files with the main one and compile it all at the same time

## recursion

- see: recursion
- the function will call itself
- the function must pass a parameter to itself
- the parameter must change in a systematic way
- the function must have an exit condition

```assembly
factorial:
  sub r1, r1, #1
  cmp r1, #1     ; exit if r1 == 1
  beq exit
  mul r0, r0, r1 ; total = total * arg
  push {r1, lr}  ; push onto stack, preserving pc

bl factorial     ; call factorial

exit:
  pop {r1, lr}   ; pop from the stack
  bx lr          ; return
```

## bx instruction

- stands for "branch exchange"
- it exchange the arm instruction set for the "thumb" instruction set
- arm instructions don't support stack operatoins (push, pop), so we need thumb mode instructions
  - thumb mode has fewer registers (0-7) but it runs faster (it's 16 bit)
  - recursive functions must be in thumb state because they use the stack
  - any function that calls another function must also be in the thumb state
