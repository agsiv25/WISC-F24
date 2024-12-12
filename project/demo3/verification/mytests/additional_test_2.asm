// Original test: ./eharris/hw4/problem6/xor_2.asm
// Author: eharris
// Test source code follows


// Tests a simple hazard without NOPs inserted manually. 
//lbi r0, 0
slbi r0, 0x0B   // r0 contains address of ".Here"
lbi r1, 15
st r1, r0, 0      // .Here should have the value 15
//ld r2, r0, 0      // r2 = 15
halt