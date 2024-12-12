// Original test: ./eharris/hw4/problem6/xor_2.asm
// Author: eharris
// Test source code follows


// Tests a simple hazard without NOPs inserted manually. 
lbi r0, U.Here
slbi r0, L.Here   // r0 contains address of ".Here"
lbi r1, 15
st r1, r0, 0      // .Here should have the value 15
ld r2, r0, 0      // r2 = 15
halt