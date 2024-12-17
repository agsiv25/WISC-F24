// j_0.asm

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