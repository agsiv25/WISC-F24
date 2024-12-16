/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the flip flop between the memory and write back cycles.
*/
`default_nettype none
module  m2w_ff(clk, rst, memOutM, wbDataSelM, addPCM, aluFinalM, imm8M, wbDataSelW, addPCW, memOutW, aluFinalW, imm8W, regWrtW, regWrtM, wrtRegM, wrtRegW, instructionM, instructionW, newPCM, newPCW, branchInstM, branchInstW, Stall);

input wire clk;
input wire rst;

input wire [15:0]memOutM;
input wire [1:0]wbDataSelM;
input wire [15:0]addPCM;
input wire [15:0]aluFinalM;
input wire [15:0]imm8M;
input wire regWrtM;
input wire [2:0] wrtRegM;
input wire [15:0] instructionM;
input wire [15:0] newPCM;
input wire branchInstM;

output wire [1:0]wbDataSelW;
output wire [15:0]addPCW;
output wire [15:0]memOutW;
output wire [15:0]aluFinalW;
output wire [15:0]imm8W;
output wire regWrtW;
output wire [2:0] wrtRegW;
output wire [15:0] instructionW;
output wire [15:0] newPCW;
output wire branchInstW;

// stall signal
input wire Stall;
wire [1:0] wbDataSelQ;
wire [15:0] addPCQ;
wire [15:0] memOutQ;
wire [15:0] aluFinalQ;
wire [15:0] imm8Q;
wire regWrtQ;
wire [2:0] wrtRegQ;
wire [15:0] instructionQ;
wire [15:0] newPCQ;
wire branchInstQ;

assign wbDataSelQ = (Stall) ? wbDataSelW : wbDataSelM;
dff wbDataSelLatch[1:0](.q(wbDataSelW), .d(wbDataSelQ), .clk(clk), .rst(rst));
assign addPCQ = (Stall) ? addPCW : addPCM;
dff addPCLatch[15:0](.q(addPCW), .d(addPCQ), .clk(clk), .rst(rst));
assign memOutQ = (Stall) ? memOutW : memOutM;
dff memOutLatch[15:0](.q(memOutW), .d(memOutQ), .clk(clk), .rst(rst));
assign aluFinalQ = (Stall) ? aluFinalW : aluFinalM;
dff aluFinalLatch[15:0](.q(aluFinalW), .d(aluFinalQ), .clk(clk), .rst(rst));
assign imm8Q = (Stall) ? imm8W : imm8M;
dff imm8Latch[15:0](.q(imm8W), .d(imm8Q), .clk(clk), .rst(rst));
assign regWrtQ = (Stall) ? regWrtW : regWrtM;
dff regWrtLatch(.q(regWrtW), .d(regWrtQ), .clk(clk), .rst(rst));
assign wrtRegQ = (Stall) ? wrtRegW : wrtRegM;
dff wrtRegLatch[2:0](.q(wrtRegW), .d(wrtRegQ), .clk(clk), .rst(rst));
assign instructionQ = (Stall) ? instructionW : instructionM;
dff instructionLatch[15:0](.q(instructionW), .d(instructionQ), .clk(clk), .rst(rst));
assign newPCQ = (Stall) ? newPCW : newPCM;
dff newPCLatch[15:0](.q(newPCW), .d(newPCQ), .clk(clk), .rst(rst));
assign branchInstQ = (Stall) ? branchInstW : branchInstM;
dff branchInstLatch(.q(branchInstW), .d(branchInstQ), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
