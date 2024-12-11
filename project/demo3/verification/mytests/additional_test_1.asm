// Author: wiedemeier
// Test source code follows


//Tests a simple hazard with NOPs inserted manually. 
lbi r1, 0xF0 //r1 = 0xFFF0
lbi r2, 0x0F //r2 = 0x000F
lbi r5, 0x11 // r2 to decode 
NOP          // r2 to execute 
NOP          // r2 to memory 
xor r4, r2, r1
halt