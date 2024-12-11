/*
   CS/ECE 552 Spring '22
  
   Filename        : d2x_ff.v
   Description     : This is the flip flop between the decode and execute cycles.
*/
`default_nettype none
module d2x_ff (clk, rst, imm8D, imm11D, aluJmpD, SLBIselD, memWrtD, brchSigD, CinD, invAD, invBD, wbDataSelD, immSrcD, aluOpD, jalSelD, sOpSelD, readEnD, aluPCD, inAD, inBD, wrtDataD, SLBIselX, incPCX, immSrcX, imm8X, imm11X, brchSigX, CinX, inAX, inBX, invAX, invBX, aluOpX, aluJmpX, jalSelX, sOpSelX, aluPCX, memWrtX, wbDataSelX, readEnX, wrtDataX, incPCD, regWrtD, regWrtX, wrtRegD, wrtRegX, branchInstD, branchInstX, instructionD, instructionX, createDumpD, createDumpX, x2xACntrlD, x2xBCntrlD, x2xACntrlX, x2xBCntrlX, m2xACntrlD, m2xBCntrlD, m2xACntrlX, m2xBCntrlX);

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
input wire [2:0] wrtRegD;

input wire branchInstD;
input wire [15:0] instructionD;
input wire createDumpD;

// EX to EX forwarding
input wire x2xACntrlD;
input wire x2xBCntrlD;
output wire x2xACntrlX;
output wire x2xBCntrlX;

// MEM to EX forwarding
input wire m2xACntrlD;
input wire m2xBCntrlD;
output wire m2xACntrlX;
output wire m2xBCntrlX;

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
output wire [1:0]wbDataSelX;
output wire readEnX;
output wire [15:0] wrtDataX;
output wire [2:0] wrtRegX;

output wire branchInstX;
output wire [15:0] instructionX;
output wire createDumpX;

// latches
dff imm8Latch [15:0] (.q(imm8X), .d(imm8D), .clk(clk), .rst(rst));
dff imm11Latch [15:0] (.q(imm11X), .d(imm11D), .clk(clk), .rst(rst));

dff aluJmpLatch(.q(aluJmpX), .d(aluJmpD), .clk(clk), .rst(rst));
dff SLBIselLatch(.q(SLBIselX), .d(SLBIselD), .clk(clk), .rst(rst));
dff brchSigLatch [2:0] (.q(brchSigX), .d(brchSigD), .clk(clk), .rst(rst));
dff CinLatch(.q(CinX), .d(CinD), .clk(clk), .rst(rst));
dff invALatch(.q(invAX), .d(invAD), .clk(clk), .rst(rst));
dff invBLatch(.q(invBX), .d(invBD), .clk(clk), .rst(rst));
dff immSrcLatch(.q(immSrcX), .d(immSrcD), .clk(clk), .rst(rst));
dff aluOpLatch [3:0] (.q(aluOpX), .d(aluOpD), .clk(clk), .rst(rst));
dff jalSelLatch(.q(jalSelX), .d(jalSelD), .clk(clk), .rst(rst));
dff sOpSelLatch(.q(sOpSelX), .d(sOpSelD), .clk(clk), .rst(rst));
dff aluPCLatch(.q(aluPCX), .d(aluPCD), .clk(clk), .rst(rst));

dff memWrtLatch(.q(memWrtX), .d(memWrtD), .clk(clk), .rst(rst));
dff wbDataSelLatch [1:0] (.q(wbDataSelX), .d(wbDataSelD), .clk(clk), .rst(rst));
dff readEnLatch(.q(readEnX), .d(readEnD), .clk(clk), .rst(rst));

dff inALatch [15:0] (.q(inAX), .d(inAD), .clk(clk), .rst(rst));
dff inBLatch [15:0] (.q(inBX), .d(inBD), .clk(clk), .rst(rst));

dff wrtDataLatch [15:0] (.q(wrtDataX), .d(wrtDataD), .clk(clk), .rst(rst));

dff incPCLatch [15:0] (.q(incPCX), .d(incPCD), .clk(clk), .rst(rst));

dff regWrtLatch(.q(regWrtX), .d(regWrtD), .clk(clk), .rst(rst));

dff wrtRegLatch [2:0] (.q(wrtRegX), .d(wrtRegD), .clk(clk), .rst(rst));

dff branchInstLatch(.q(branchInstX), .d(branchInstD), .clk(clk), .rst(rst));

dff instructionLatch [15:0] (.q(instructionX), .d(instructionD), .clk(clk), .rst(rst));

dff createDumpLatch(.q(createDumpX), .d(createDumpD), .clk(clk), .rst(rst));

dff x2xAForwardingLatch(.q(x2xACntrlX), .d(x2xACntrlD), .clk(clk), .rst(rst));
dff x2xBForwardingLatch(.q(x2xBCntrlX), .d(x2xBCntrlD), .clk(clk), .rst(rst));

dff m2xAForwardingLatch(.q(m2xACntrlX), .d(m2xACntrlD), .clk(clk), .rst(rst));
dff m2xBForwardingLatch(.q(m2xBCntrlX), .d(m2xBCntrlD), .clk(clk), .rst(rst));

endmodule
`default_nettype wire
