// Original test: ./eharris/hw4/problem6/xor_2.asm
// Author: eharris
// Test source code follows


// Tests a simple hazard without NOPs inserted manually. 
lbi r1, 0xff    //expected value in r1 = -1
lbi r2, 1       //expected value in r2 = 1
// sco r3, r1, r2  //expected value in r3 = 1
// sco r3, r2, r3  //expected value in r3 = 0
sco r4, r3, r1  //expected value in r4 = 0
halt
halt