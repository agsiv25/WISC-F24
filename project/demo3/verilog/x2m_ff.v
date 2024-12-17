/*
   CS/ECE 552 Spring '22
  
   Filename        : x2m.v
   Description     : This is the flip flop between the execute and memory cycles.
*/
`default_nettype none
module  x2m_ff(clk, rst, aluFinalX, addPCX, aluOutX, wrtDataX, memWrtX, readEnX, wbDataSelX, wrtDataM, memWrtM, aluFinalM, addPCM, aluOutM, readEnM, wbDataSelM, imm8X, imm8M, regWrtX, regWrtM, wrtRegX, wrtRegM, instructionX, instructionM, createDumpX, createDumpM, branch_mispredictionX, branch_mispredictionM, istall, istallM, dstall);

input wire clk;
input wire rst;

input wire [15:0] aluFinalX;
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

output wire [15:0]wrtDataM;
output wire memWrtM;
output wire readEnM;
output wire [15:0] aluFinalM;
output wire [15:0] addPCM;
output wire [15:0] aluOutM;
output wire [1:0] wbDataSelM;
output wire [15:0] imm8M;
output wire regWrtM;
output wire [2:0] wrtRegM;
output wire [15:0] instructionM;
output wire createDumpM;

// cache
input wire branch_mispredictionX;
output wire branch_mispredictionM;
input wire istall;
output wire istallM;
input wire dstall;
wire cacheClk;
assign cacheClk = (istall | dstall) ? 1'b0 : clk;

dff aluFinalLatch [15:0] (.q(aluFinalM), .d(aluFinalX), .clk(cacheClk), .rst(rst));
dff addPCLatch [15:0] (.q(addPCM), .d(addPCX), .clk(cacheClk), .rst(rst));
dff aluOutLatch [15:0] (.q(aluOutM), .d(aluOutX), .clk(cacheClk), .rst(rst));
dff wrtDataLatch [15:0] (.q(wrtDataM), .d(wrtDataX), .clk(cacheClk), .rst(rst));
dff memWrtLatch(.q(memWrtM), .d(memWrtX), .clk(cacheClk), .rst(rst));
dff readEnLatch(.q(readEnM), .d(readEnX), .clk(cacheClk), .rst(rst));
dff wbDataSelLatch [1:0] (.q(wbDataSelM), .d(wbDataSelX), .clk(cacheClk), .rst(rst));
dff imm8Latch [15:0] (.q(imm8M), .d(imm8X), .clk(cacheClk), .rst(rst));
dff regWrtLatch (.q(regWrtM), .d(regWrtX), .clk(cacheClk), .rst(rst));
dff wrtRegLatch [2:0] (.q(wrtRegM), .d(wrtRegX), .clk(cacheClk), .rst(rst));
dff instructionLatch [15:0] (.q(instructionM), .d(instructionX), .clk(cacheClk), .rst(rst));
dff createDumpLatch (.q(createDumpM), .d(createDumpX), .clk(cacheClk), .rst(rst));

dff branchMispredictionLatch (.q(branch_mispredictionM), .d(branch_mispredictionX), .clk(cacheClk), .rst(rst));

dff istallMemoryLatch (.q(istallM), .d(istall), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
