lbi r3, 0
beqz r3, .GoHere
halt
halt
halt
halt

.GoHere:
ld r3, r2, 0       // r3 = 0x005e
bnez r3, .GoThere
halt
halt
halt
halt

.GoThere:
lbi r0, U.GoGoGo
slbi r0, L.GoGoGo
jalr r0, 0
.RetAddr:
halt
halt
halt
halt

.GoGoGo:
st r7, r2, -2      // .Data1-2 = .RetAddr (0x00a4)
halt
halt
halt
