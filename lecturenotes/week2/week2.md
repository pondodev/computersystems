# computer systems week 2 lecture notes

- half adder
  - two input bits
  - xor gate calculates the cum
  - and gate calculates the carry
- full adder
  - still only two input bits but with an added carry bit input
  - has two half adders
  - deals with a + b and then adds that result with the carry bit input
  - two outputs
  - second output can be linked up to the carry bit input of another full adder to add another "column"
- xor gates can be thought of as a controlled inverter
  - when input b is off, input a will be reflected by the output
  - when input b is on, input a will be inverted and then reflected by the output
- and gates can be thought of as a logical switch
  - when input b is off, the output will never be on
  - when input b is on, the output will reflect input a

## multi bit addition

- the first column will always be a half adder since there is no carry input
- then we link full adders past that, linking up the previous adder's carry output to the new carry input

- circuits are unstable!
- circuits will take a finite amount of time to perform actions
- we can use clocks to synchronize circuits
- clocks are just consistent square waves that represent on and off
- cpus require some memory to remember certain things during processing
- cpus contain registers which allow for it to remember small amounts of things very close to the cpu itself (not using ram or other memory that is outside the cpu)

## flip flops

- there are two main flip flops with clocked inputs that we used:
  - d flip flops
  - jk flip flops
- d flip flops tend to be used for registers
- jk flip flops are a more general "programmable" flip flop

### d flip flop

| D<sub>n</sub> | Q<sub>n+1</sub> |
| ------------- | --------------- |
| 0             | 0               |
| 1             | 1               |

- note that the n means "at the clock" while n+1 means "after the clock"
- now we are essentially synchronising the output change with the clock cycle

### jk flip flop

| J | K | Q<sub>n+1</sub> |
| - | - | --------------- |
| 0 | 0 | Q<sub>n</sub>   |
| 0 | 1 | 0               |
| 1 | 0 | 1               |
| 1 | 1 | Q'<sub>n</sub>  |

- previously a state where both inputs are on would be a problem state, but now this essentially turns it into a toggle flip flop

### t flip flop

| T | Q<sub>n+1     |
| - | ------------- |
| 0 | Q<sub>n       |
| 1 | Q'<sub>n</sub>|

## more on flip flops

- sometimes it is useful to provide both clocked and non-clocked inputs
- when power is applied to a flip flop its state cannot be predicted
- the asynchronous inputs are used as master reset or set inputs and override the clocked inputs if we should try to use one of these at the same time as the clock edge
