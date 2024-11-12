/*
   CS/ECE 552 Spring '22
  
   Filename        : d2x_ff.v
   Description     : This is the flip flop between the decode and execute cycles.
*/
`default_nettype none
module d2x_ff (clk, rst, imm8D, imm11D, aluJmpD, SLBIselD, memWrtD, brchSigD, CinD, invAD, invBD, wbDataSelD, immSrcD, aluOpD, jalSelD, sOpSelD, readEnD, aluPCD, inAD, inBD, wrtDataD, SLBIselX, incPCX, immSrcX, imm8X, imm11X, brchSigX, CinX, inAX, inBX, invAX, invBX, aluOpX, aluJmpX, jalSelX, sOpSelX, aluPCX, memWrtX, wbDataSelX, readEnX, wrtDataX, incPCD, regWrtD, regWrtX);

input wire clk;
input wire rst;

// from instruction decoder stage  
input wire [15:0] imm8D;
input wire [15:0] imm11D;

input wire aluJmpD;
input wire SLBIselD;
input wire memWrtD;           // memory write or read signal 
input wire [2:0] brchSigD;
input wire CinD;
input wire invAD;             // invert ALU input A
input wire invBD;             // invert ALU input B
input wire [1:0] wbDataSelD;           // choose source of writeback data 
input wire immSrcD;                    // used to choose which immediate to add to PC
input wire [3:0]aluOpD;                     // signal to ALU to choose operation
input wire jalSelD;              // select signal for jal and slbiu conflict
input wire sOpSelD;
input wire readEnD;
input wire aluPCD;
input wire [15:0]incPCD;

input wire [15:0] inAD;
input wire [15:0] inBD;

input wire [15:0] wrtDataD;
input wire regWrtD;

// to execute stage 
output wire regWrtX;
output wire SLBIselX;
output wire [15:0] incPCX;
output wire immSrcX;
output wire [15:0] imm8X;
output wire [15:0] imm11X;
output wire [2:0] brchSigX;
output wire CinX;
output wire [15:0] inAX;
output wire [15:0] inBX;
output wire invAX;
output wire invBX;
output wire [3:0] aluOpX;
output wire aluJmpX;
output wire jalSelX;
output wire sOpSelX;
output wire aluPCX;

// outputs to stages other than execute
output wire memWrtX;
output wire wbDataSelX;
output wire readEnX;
output wire [15:0] wrtDataX;

// latches
dff imm8Latch [15:0] (.Q(imm8X), .D(imm8D), .clk(clk), .rst(rst));
dff imm11Latch [15:0] (.Q(imm11X), .D(imm11D), .clk(clk), .rst(rst));

dff aluJmpLatch(.Q(aluJmpX), .D(aluJmpD), .clk(clk), .rst(rst));
dff SLBIselLatch(.Q(SLBIselX), .D(SLBIselD), .clk(clk), .rst(rst));
dff brchSigLatch [2:0] (.Q(brchSigX), .D(brchSigD), .clk(clk), .rst(rst));
dff CinLatch(.Q(CinX), .D(CinD), .clk(clk), .rst(rst));
dff invALatch(.Q(invAX), .D(invAD), .clk(clk), .rst(rst));
dff invBLatch(.Q(invBX), .D(invBD), .clk(clk), .rst(rst));
dff immSrcLatch(.Q(immSrcX), .D(immSrcD), .clk(clk), .rst(rst));
dff aluOpLatch [3:0] (.Q(aluOpX), .D(aluOpD), .clk(clk), .rst(rst));
dff jalSelLatch(.Q(jalSelX), .D(jalSelD), .clk(clk), .rst(rst));
dff sOpSelLatch(.Q(sOpSelX), .D(sOpSelD), .clk(clk), .rst(rst));
dff aluPCLatch(.Q(aluPCX), .D(aluPCD), .clk(clk), .rst(rst));

dff memWrtLatch(.Q(memWrtX), .D(memWrtD), .clk(clk), .rst(rst));
dff wbDataSelLatch [1:0] (.Q(wbDataSelX), .D(wbDataSelD), .clk(clk), .rst(rst));
dff readEnLatch(.Q(readEnX), .D(readEnD), .clk(clk), .rst(rst));

dff inALatch [15:0] (.Q(inAX), .D(inAD), .clk(clk), .rst(rst));
dff inBLatch [15:0] (.Q(inBX), .D(inBD), .clk(clk), .rst(rst));

dff wrtDataLatch [15:0] (.Q(wrtDataD), .D(wrtDataD), .clk(clk), .rst(rst));

dff incPCLatch [15:0] (.Q(incPCX), .D(incPCD), .clk(clk), .rst(rst));

dff regWrtLatch(.Q(regWrtX), .D(regWrtD), .clk(clk), .rst(rst));

endmodule
`default_nettype wire
