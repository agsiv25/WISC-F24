// Original test: ./eharris/hw4/problem6/xor_2.asm
// Author: eharris
// Test source code follows


// Tests BEQZ functionality with branch prediction. 
lbi  r0, 2      // set to 0 so branch is taken
beqz r0, 0x06
lbi  r1, 0x0A
lbi  r2, 0x0B
halt
lbi  r5, 0xFF  //only load if branch is taken
halt