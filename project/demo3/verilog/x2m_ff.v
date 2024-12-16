/*
   CS/ECE 552 Spring '22
  
   Filename        : x2m.v
   Description     : This is the flip flop between the execute and memory cycles.
*/
`default_nettype none
module  x2m_ff(clk, rst, aluFinalX, newPCX, addPCX, aluOutX, wrtDataX, memWrtX, readEnX, wbDataSelX, wrtDataM, memWrtM, aluFinalM, newPCM, addPCM, aluOutM, readEnM, wbDataSelM, imm8X, imm8M, regWrtX, regWrtM, wrtRegX, wrtRegM, instructionX, instructionM, createDumpX, createDumpM, branchInstX, branchInstM, memAccessX, memAccessM, Stall);

input wire clk;
input wire rst;

input wire [15:0] aluFinalX;
input wire [15:0] newPCX;
input wire [15:0] addPCX;
input wire [15:0] aluOutX;
input wire [15:0] wrtDataX;
input wire memWrtX;
input wire readEnX;
input wire [1:0]wbDataSelX;
input wire [15:0] imm8X;
input wire regWrtX;
input wire [2:0] wrtRegX;
input wire [15:0] instructionX;
input wire createDumpX;
input wire branchInstX;

output wire [15:0]wrtDataM;
output wire memWrtM;
output wire readEnM;
output wire [15:0] aluFinalM;
output wire [15:0] newPCM;
output wire [15:0] addPCM;
output wire [15:0] aluOutM;
output wire [1:0] wbDataSelM;
output wire [15:0] imm8M;
output wire regWrtM;
output wire [2:0] wrtRegM;
output wire [15:0] instructionM;
output wire createDumpM;
output wire branchInstM;

//align
input wire memAccessX;
output wire memAccessM;

// stall signal
input wire Stall;
wire [15:0]aluFinalQ;
wire [15:0]newPCQ;
wire [15:0]addPCQ;
wire [15:0]aluOutQ;
wire [15:0]wrtDataQ;
wire memWrtQ;
wire readEnQ;
wire [1:0]wbDataSelQ;
wire [15:0]imm8Q;
wire regWrtQ;
wire [2:0]wrtRegQ;
wire [15:0]instructionQ;
wire createDumpQ;
wire branchInstQ;
wire memAccessQ;


assign aluFinalQ = (Stall) ? aluFinalM : aluFinalX;
dff aluFinalLatch [15:0] (.q(aluFinalM), .d(aluFinalQ), .clk(clk), .rst(rst));
assign newPCQ = (Stall) ? newPCM : newPCX;
dff newPCLatch [15:0] (.q(newPCM), .d(newPCQ), .clk(clk), .rst(rst));
assign addPCQ = (Stall) ? addPCM : addPCX;
dff addPCLatch [15:0] (.q(addPCM), .d(addPCQ), .clk(clk), .rst(rst));
assign aluOutQ = (Stall) ? aluOutM : aluOutX;
dff aluOutLatch [15:0] (.q(aluOutM), .d(aluOutQ), .clk(clk), .rst(rst));
assign wrtDataQ = (Stall) ? wrtDataM : wrtDataX;
dff wrtDataLatch [15:0] (.q(wrtDataM), .d(wrtDataQ), .clk(clk), .rst(rst));
assign memWrtQ = (Stall) ? memWrtM : memWrtX;
dff memWrtLatch(.q(memWrtM), .d(memWrtQ), .clk(clk), .rst(rst));
assign readEnQ = (Stall) ? readEnM : readEnX;
dff readEnLatch(.q(readEnM), .d(readEnQ), .clk(clk), .rst(rst));
assign wbDataSelQ = (Stall) ? wbDataSelM : wbDataSelX;
dff wbDataSelLatch [1:0] (.q(wbDataSelM), .d(wbDataSelQ), .clk(clk), .rst(rst));
assign imm8Q = (Stall) ? imm8M : imm8X;
dff imm8Latch [15:0] (.q(imm8M), .d(imm8Q), .clk(clk), .rst(rst));
assign regWrtQ = (Stall) ? regWrtM : regWrtX;
dff regWrtLatch (.q(regWrtM), .d(regWrtQ), .clk(clk), .rst(rst));
assign wrtRegQ = (Stall) ? wrtRegM : wrtRegX;
dff wrtRegLatch [2:0] (.q(wrtRegM), .d(wrtRegQ), .clk(clk), .rst(rst));
assign instructionQ = (Stall) ? instructionM : instructionX;
dff instructionLatch [15:0] (.q(instructionM), .d(instructionQ), .clk(clk), .rst(rst));
assign createDumpQ = (Stall) ? createDumpM : createDumpX;
dff createDumpLatch (.q(createDumpM), .d(createDumpQ), .clk(clk), .rst(rst));
assign branchInstQ = (Stall) ? branchInstM : branchInstX;
dff branchInstLatch (.q(branchInstM), .d(branchInstQ), .clk(clk), .rst(rst));
assign memAccessQ = (Stall) ? memAccessM : memAccessX;
dff memAccessLatch (.q(memAccessM), .d(memAccessQ), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
