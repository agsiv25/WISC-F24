// Original test: ./eharris/hw4/problem6/xor_2.asm
// Author: eharris
// Test source code follows


// Tests a simple hazard without NOPs inserted manually. 
lbi r1, 0xF0 //r1 = 0xFFF0
//lbi r2, 0x0F //r2 = 0x000F
NOP
lbi r5, 0x11 // 0x0011
xor r4, r5, r1
// add r5, r4, r4
halt