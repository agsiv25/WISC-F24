/*
   CS/ECE 552 Spring '22
  
   Filename        : d2x_ff.v
   Description     : This is the flip flop between the decode and execute cycles.
*/
`default_nettype none
module d2x_ff (clk, rst, imm8D, imm11D, aluJmpD, SLBIselD, memWrtD, brchSigD, CinD, invAD, invBD, wbDataSelD, immSrcD, aluOpD, jalSelD, sOpSelD, readEnD, aluPCD, inAD, inBD, wrtDataD, SLBIselX, incPCX, immSrcX, imm8X, imm11X, brchSigX, CinX, inAX, inBX, invAX, invBX, aluOpX, aluJmpX, jalSelX, sOpSelX, aluPCX, memWrtX, wbDataSelX, readEnX, wrtDataX, incPCD, regWrtD, regWrtX, wrtRegD, wrtRegX, branchInstD, branchInstX, instructionD, instructionX, createDumpD, createDumpX, fwCntrlAD, fwCntrlBD, fwCntrlAX, fwCntrlBX, memAccessD, memAccessX, Stall);

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

// forwarding
input wire [4:0] fwCntrlAD, fwCntrlBD;
output wire [4:0] fwCntrlAX, fwCntrlBX;

//align
input wire memAccessD;
output wire memAccessX;

// stall signal
input wire Stall;
wire [15:0] imm8Q;
wire [15:0] imm11Q;
wire aluJmpQ;
wire SLBIselQ;
wire memWrtQ;
wire [2:0] brchSigQ;
wire CinQ;
wire invAQ;
wire invBQ;
wire immSrcQ;
wire [3:0] aluOpQ;
wire jalSelQ;
wire sOpSelQ;
wire aluPCQ;
wire [1:0] wbDataSelQ;
wire readEnQ;
wire [15:0] inAQ;
wire [15:0] inBQ;
wire wrtDataQ;
wire [15:0] incPCQ;
wire regWrtQ;
wire [2:0] wrtRegQ;
wire branchInstQ;
wire [15:0] instructionQ;
wire createDumpQ;
wire memAccessQ;
wire [4:0] AForwardingQ;
wire [4:0] BForwardingQ;


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
assign imm8Q = (Stall) ? imm8X : imm8D;
dff imm8Latch [15:0] (.q(imm8X), .d(imm8Q), .clk(clk), .rst(rst));
assign imm11Q = (Stall) ? imm11X : imm11D;
dff imm11Latch [15:0] (.q(imm11X), .d(imm11Q), .clk(clk), .rst(rst));
assign aluJmpQ = (Stall) ? aluJmpX : aluJmpD;
dff aluJmpLatch(.q(aluJmpX), .d(aluJmpQ), .clk(clk), .rst(rst));
assign SLBIselQ = (Stall) ? SLBIselX : SLBIselD;
dff SLBIselLatch(.q(SLBIselX), .d(SLBIselQ), .clk(clk), .rst(rst));
assign brchSigQ = (Stall) ? brchSigX : brchSigD;
dff brchSigLatch [2:0] (.q(brchSigX), .d(brchSigQ), .clk(clk), .rst(rst));
assign CinQ = (Stall) ? CinX : CinD;
dff CinLatch(.q(CinX), .d(CinQ), .clk(clk), .rst(rst));
assign invAQ = (Stall) ? invAX : invAD;
dff invALatch(.q(invAX), .d(invAQ), .clk(clk), .rst(rst));
assign invBQ = (Stall) ? invBX : invBD;
dff invBLatch(.q(invBX), .d(invBQ), .clk(clk), .rst(rst));
assign immSrcQ = (Stall) ? immSrcX : immSrcD;
dff immSrcLatch(.q(immSrcX), .d(immSrcQ), .clk(clk), .rst(rst));
assign aluOpQ = (Stall) ? aluOpX : aluOpD;
dff aluOpLatch [3:0] (.q(aluOpX), .d(aluOpQ), .clk(clk), .rst(rst));
assign jalSelQ = (Stall) ? jalSelX : jalSelD;
dff jalSelLatch(.q(jalSelX), .d(jalSelQ), .clk(clk), .rst(rst));
assign sOpSelQ = (Stall) ? sOpSelX : sOpSelD;
dff sOpSelLatch(.q(sOpSelX), .d(sOpSelQ), .clk(clk), .rst(rst));
assign aluPCQ = (Stall) ? aluPCX : aluPCD;
dff aluPCLatch(.q(aluPCX), .d(aluPCQ), .clk(clk), .rst(rst));
assign memWrtQ = (Stall) ? memWrtX : memWrtD;
dff memWrtLatch(.q(memWrtX), .d(memWrtQ), .clk(clk), .rst(rst));
assign wbDataSelQ = (Stall) ? wbDataSelX : wbDataSelD;
dff wbDataSelLatch [1:0] (.q(wbDataSelX), .d(wbDataSelQ), .clk(clk), .rst(rst));
assign readEnQ = (Stall) ? readEnX : readEnD;
dff readEnLatch(.q(readEnX), .d(readEnQ), .clk(clk), .rst(rst));
assign inAQ = (Stall) ? inAX : inAD;
dff inALatch [15:0] (.q(inAX), .d(inAQ), .clk(clk), .rst(rst));
assign inBQ = (Stall) ? inBX : inBD;
dff inBLatch [15:0] (.q(inBX), .d(inBQ), .clk(clk), .rst(rst));
assign wrtDataQ = (Stall) ? wrtDataX : wrtDataD;
dff wrtDataLatch [15:0] (.q(wrtDataX), .d(wrtDataQ), .clk(clk), .rst(rst));
assign incPCQ = (Stall) ? incPCX : incPCD;
dff incPCLatch [15:0] (.q(incPCX), .d(incPCQ), .clk(clk), .rst(rst));
assign regWrtQ = (Stall) ? regWrtX : regWrtD;
dff regWrtLatch(.q(regWrtX), .d(regWrtQ), .clk(clk), .rst(rst));
assign wrtRegQ = (Stall) ? wrtRegX : wrtRegD;
dff wrtRegLatch [2:0] (.q(wrtRegX), .d(wrtRegQ), .clk(clk), .rst(rst));
assign branchInstQ = (Stall) ? branchInstX : branchInstD;
dff branchInstLatch(.q(branchInstX), .d(branchInstQ), .clk(clk), .rst(rst));
assign instructionQ = (Stall) ? instructionX : instructionD;
dff instructionLatch [15:0] (.q(instructionX), .d(instructionQ), .clk(clk), .rst(rst));
assign createDumpQ = (Stall) ? createDumpX : createDumpD;
dff createDumpLatch(.q(createDumpX), .d(createDumpQ), .clk(clk), .rst(rst));
assign AForwardingQ = (Stall) ? fwCntrlAX : fwCntrlAD;
dff AForwardingLatch [4:0] (.q(fwCntrlAX), .d(AForwardingQ), .clk(clk), .rst(rst));
assign BForwardingQ = (Stall) ? fwCntrlBX : fwCntrlBD;
dff BForwardingLatch [4:0] (.q(fwCntrlBX), .d(BForwardingQ), .clk(clk), .rst(rst));
assign memAccessQ = (Stall) ? memAccessX : memAccessD;
dff memAccessLatch(.q(memAccessX), .d(memAccessQ), .clk(clk), .rst(rst));


endmodule
`default_nettype wire
