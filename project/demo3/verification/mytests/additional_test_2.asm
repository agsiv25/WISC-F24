// Original test: ./eharris/hw4/problem6/xor_2.asm
// Author: eharris
// Test source code follows


// Tests a simple hazard without NOPs inserted manually. 
lbi  r4, 50     //mem location
lbi  r2, 8      //value to store
lbi  r3, 0      //clear r3
st   r2, r1, 10  //store at mem location +10
ld   r3, r1, 10  //load from mem location +10
halt