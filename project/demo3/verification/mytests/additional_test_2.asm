// Original test: ./eharris/hw4/problem6/xor_2.asm
// Author: eharris
// Test source code follows


// Tests a simple hazard without NOPs inserted manually. 
lbi r1, 0xFF
slbi r1, 0x0
addi r2, r1, 0x01
halt