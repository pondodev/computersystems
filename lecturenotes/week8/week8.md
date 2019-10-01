# computer systems week 7 lecture notes

## if tests

- called "compare" in arm asm
  - subtracts 2nd value from first, and sets flags accordingly
  - loads the **application program status register** (APSR) with the results of the comparison (done by the ALU)
  - the APSR flags include:
    - N -- ALU result was negative (not equal)
    - Z -- ALU result was zero (equal)
    - C -- ALU set the carry bit
    - V -- ALU result caused overflow
- we can use certain suffixes to only perform something if a condition is met
  - eg. `movne r1, #12` where we add `ne` to the `mov` instruction
  - `ne` in this case is the flag for not equal or `!=`
- we use conditions on branches most commonly
  - eg. `bne` for branch if not equal
- we use `cmp` to compare values
  - eg. `cmp r1, r2` which essentially does `r1 - r2`
- keep in mind that you should always keep `cmp` and their related instructions next to each other cause the APSR isn't always cleared on a read and isn't cleared on each cycle. ignoring this could cause issues!

this is a slower way of looping 10 times

```assembly
mov r1, #0   ; assign 0 to r1
mov r2, #10  ; assign 10 to r2

loop:        ; loop label
  add r2, #1 ; increment r2 by 1
  cmp r1, r2 ; compare r1 and r2
bne loop     ; goto label "loop" if not equal
```

this is a faster way of looping 10 times

```assembly
mov r1, #10  ; assign 10 to r1

loop:        ; loop label
  sub r1, #1 ; decrement r1 by 1
  cmp r1, #0 ; compare r1 and 0
bne loop     ; goto label "loop" if not equal
```

the above is faster because we compare with 0 which the ALU can handle better than a value in a register

## ALUs

- contains:
  - programmable shift register
  - full adder
  - counter
  - registers (accumulator)

## flashing an LED

- the pseudocode will essentially be:

```
loop:
  turn on
  wait
  turn off
  wait
goto loop
```

### a dumb timer

``` assembly
mov r0, $3F0000 ; some arbitrary huge number
loop:
  sub r0, #1    ; take 1 away from that huge number
  cmp r0, #0    ; compare it to 0
bne loop        ; if it isn't == 0 then loop again
```

- has no real link to time
- even if we timed it properly for our hardware, it wouldn't work the same on all CPUs
- it keeps 100% of CPU time

### a better timer

- rpi has a dedicated timer register
  - independant of clock speed
  - housed in the same chip as the cpu, the gpio, ram, and most other things
  - this chip is called the SoC
- timer register starts at base address + 0x3004
  - this is a register that increments at 1MHz
- using this as a timer is better because it measures in real time
- *however* do note that it still takes 100% of cpu time (bound by a loop)

- variables:
  - r3
    - base address of timer
  - r4
    - desired delay
  - r6, r7
    - where the current time will be stored
    - required cause our registers are 32 bit while we are storing a 64 bit value
  - r5
    - start time
  - r8
    - elapsed time  (r6 - r7)
- we can use the instruction `ldrd` which is a version of `ldr` that allows for storing of double words, or in our case 64 bit values
  - eg. `ldrd r6, r7, [r3, #4]` where we copy into r6 (least significant) and r7 (most significant)

```assembly
BASE = $3F000000
TIMER_OFFSET = $3000

mov r3, BASE            ; assign based address to r3
orr r3, TIMER_OFFSET    ; add offset to r3 so we have the timer registers
mov r4, $80000          ; our delay

ldrd r6, r7, [r3, #4]   ; store our current timestamp into r6 and r7
move r5, r6             ; move start time into r5 (essentially keeping track of our start time)

loop:
  ldrd r6, r7, [r3, #4] ; read current time
  sub r8, r6, r5        ; remaining time (r8) == current time (r6) - start time (r5)
  cp r8, r4             ; compare remaining (r8) and delay (r4)
bls loop                ; goto loop if remaning time (r8) <= delay (r4)
```

- keep in mind that all labels need to be unique, so once we've used one for a loop we need to create a new unique label

## managing numbers with mov

- the `mov` opcode is really fast -- 1 clock cycle
- it combines the operation and the operand in the one 32-bit byte which is why it's so fast
- the ALU/CPU can process this immediately
  - no copying from memory (using pointers. use `ldr` instead)
  - no construction of instruction for the ALU
- however, it doesn't have enough capacity for full 32-bit values
  - it requires numbers that have 24 consecutive bits set to 0
  - this leaves us essentially 8-bits for the value
  - 20 bits are for the op code
  - 4 bits are for the rotation (defining how many times the bits need to be rotated)
    - `ROR` is achieved with a hardware shift register called a **barrel shifter** (essentially just a shift register that wraps around on itself)
- so in the full 32-bit word for `mov` we have:
  - 20 bits for the opcode
  - 4 bits (values from 0 - 15) to indicate how much to `ROR`
  - 8 bits for the actual value we want to work with
- all of this allows for it to handle the full instruction in one clock cycle

### barrel shifter

- arm cpus have a barrel shifter
  - a shift register where the overflow feeds back into the underflow
  - this allows it to "rotate" the bits
- the barrel shifter can:
  - logical shift left/right
  - arithmetic shift right
    - respects the sign bits if you have a signed number
    - may be better if youre trying to do a double/halve of a number that is signed
  - rotate

### orr

- `orr` allows for us to add onto our registers what `mov` cannot due to its limitations
- the `orr` instruction does not have the same restriction as `mov`, meaning we can `orr` in any value we want with no restriction
- if we cannot `mov` a number into a register we can break it up into 1 byte chunks

```assembly
mov r0, SOME_ADDRESS               ; won't work

mov r0, SOME_ADDRESS and $000000FF ; will work
orr r0, SOME_ADDRESS and $0000FF00
orr r0, SOME_ADDRESS and $00FF0000
orr r0, SOME_ADDRESS and $FF000000
```

## stacks

- arm computers have a software stack
- separate area of ram is available for temp values
- a value in a register can be pushed onto the stack to preserve it for later
- it cacn be popped off later (LIFO order)
- we can get the memory location by checking the SP (r13) register
