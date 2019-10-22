# computer systems week 10 lecture notes

## detecting input

- we can read inputs from gpio pins just like we can create outputs
- the input will be a voltage going into the pin
  - ensure that the pin is only connected up to the 3.3V pin on the rpi!
- when we turn a gpio pin on for output, we set it's bits to 001 to program it's register
- for input we then need to write the bits 000 instead
  - we can't use the same `lsl` approach as before since if we do that then we will end up overwriting other gpio registers with 0
  - instead we can use `bic` to set the bits to 0

## bic

- `bic` is the instruction for bit clear

```assembly
BASE = $3F000000
GPIO_OFFSET = $200000
mov r0, BASE
orr r0, GPIO_OFFSET

ldr r1, [r0, #4] ; read the function register for gpio10-19
bic r1, r1, #7   ; first 3 bits are for gpio10, so we can just clear the first 3 bits
                 ; 7 in binary is 111, clearing the 3 bits we want to clear
str r1, [r0, #4] ; enable writing
```

- syntax for `bic` is:

```assembly
bic x, y, z
```

- where:
  - x is the destination
  - y is the register holding the value to perform the operation on
  - z is the bitmask to be used

## tst

- `tst` is then used to **test** if the gpio pin is being pulled high
- the result is stored in the apsr just like `cmp`

```assembly
ldr r9, [r0, #52]
tst r9, #1024
bne red ; if the gpio is pulled low turn on red light
b green ; if the gpio is pulled high turn on green light
```

- syntax for `tst` is:

```assembly
tst x, y
```

- where:
  - x is the register holding the value we are testing
  - y is the bitmask to perform the bitwise and operation with

## arrays

- start with a label
- follow with the data type and then list the array elements delimited by a comma

```assembly
myArray:
int 1, 2, 3, 4

myName:
db "dan\0"

myNum:
dw $F0002000
```

- to iterate through an array we can do:

```assembly
mov r5, #0         ; current index
mov r4, myArray    ; get the pointer for the array
loop:
  ldr r0, [r4, r5] ; gets pointer of the value we want and stores value in r0
  ; do stuff with r0
  add r5, #1       ; increment index by one
b loop
```

## writing to the screen
- **continue from 1:05:35 in the lecture**
