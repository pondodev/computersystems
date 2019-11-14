# computer systems week 1 lecture notes

- email chris outside of labs instead of tutors for questions
- keep an eye on announcements
- on canvas:
  - click people
  - join group that is your lab
- lab work submitted through canvas

## ILOs

- read and write assembly language programs for a simple microcomputer
- identify the hardware components of a computer and the fucntion they perform
- describe the overall behaviours of compilers, assemblers, linkers and interpreters
- agrue some of the tradeoffs between hardware and software that occur in computer system design

- there are tutorials chris has made on youtube for the labs

## assessments

- lab work 10% (mostly just an attendance mark)
- assignment 1 15%
- assignment 2 15%
- exam 60%
- you require 50% overall to pass the unit

- get a raspberry pi 3B/+ (seriously do not get the 4)
- [arm information center](http://infocenter.arm.com/index.html)
  - 3B/+ use the armv8 instruction set
- hdmi to dvi-d cable
- logisim evolution (logic simulation)
- fasarm ide and compiler (asm ide and compiler)

- information is represented in 1s and 0s
- determined by voltage ranges with space between for robustness
- byte
  - 8 bit string
  - lowest/smallest addressable unit
- word
  - register size used by the cpu
  - can be 8/16/32/64 bits
- use hex notation as shorthand for binary
  - 2 hex chars == 1 byte
  - 11111111 == 0xFF

## what is a computer system?

- fast memory (ram)
  - program and data
- persistent memory
  - disks and other non-volatile memory
- central processing unit (cpu)
- motherboard
- graphics
- input/output channels
- accel cards
- keyboard
- mouse

### basic machine instructions

- CISC
  - complex instruction set cpu
- RISC
  - reduced instruction set cpu
- native code runs really fast on the "bare metal"

### bios

- basic input output system
- factory set code
- you can't change
- handles startup stuff

### operating system

- dos (disk operating system), linux
- gui (graphical user interface) windows, osx

### applications

- code that operates on top of the os

## issues

- storing information
  - how do we represent types of data?
  - big endian vs little endian
    - big endian
      - left most value is the most significant
      - eg date/time (2014-08-07_11:30:00)
    - little endian
      - right most value is the most significant
      - eg date/time (30 mins past 11 oclock 6th of august 2014)

## digital vs analouge

- digital tries to emulate analouge
- digital is more robust
- analouge is more accurate

## number systems

- numbers are "positional"
  - multiples based on the columns
  - eg 14 == 10 10s and 4 1s
- binary then uses columns of 1, 2, 4, 8, etc...
- hex goes from 0-F
- A = 11 B = 12 etc...


## bitwise operations

- can base decisions on a single bit

## gates

- gates are electronic components that has an output dependant on inputs
- usually transistors connected together

- not gate
  - inverts input

| a | c |
| - | - |
| 1 | 0 |
| 0 | 1 |

- or gate
  - addition

| a | b | c |
| - | - | - |
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 1 |

- and gate
  - multiplication

| a | b | c |
| - | - | - |
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

- nand gate
  - and gate with a not gate on the end
    
| a | b | c |
| - | - | - |
| 0 | 0 | 1 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

- xor gate
  - basis for modulo-2 binary addition

| a | b | c |
| - | - | - |
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

## diagram conventions

- wire has the same voltage
- don't care about the power input

- half adder
  - takes in two inputs
  - has two outputs (sum and carry bits)
  - x/y == inputs s == sum c == carry bits

| x | y | s | c |
| - | - | - | - |
| 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 1 |

- full adder
  - three inputs
  - two outputs
