// Original test: ./eharris/hw4/problem6/xor_2.asm
// Author: eharris
// Test source code follows


// Tests a simple hazard without NOPs inserted manually. 
lbi  r1, 0     //mem location tests first mem location
lbi  r2, 8      //value to store
lbi  r3, 0      //clear r3
NOP
NOP
st   r2, r1, 0  //store at mem location
ld   r3, r1, 0  //load from mem location
halt