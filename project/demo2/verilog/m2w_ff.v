/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the flip flop between the memory and write back cycles.
*/
`default_nettype none
module  m2w_ff(clk, rst, memOutM, wbDataSelM, addPCM, aluFinalM, imm8M, wbDataSelW, addPCW, memOutW, aluFinalW, imm8W, regWrtW, regWrtM);

input wire clk;
input wire rst;

input wire [15:0]memOutM;
input wire [1:0]wbDataSelM;
input wire [15:0]addPCM;
input wire [15:0]aluFinalM;
input wire [15:0]imm8M;
input wire regWrtM;

output wire [1:0]wbDataSelW;
output wire [15:0]addPCW;
output wire [15:0]memOutW;
output wire [15:0]aluFinalW;
output wire [15:0]imm8W;
output wire regWrtW;

dff wbDataSelLatch[1:0](.q(wbDataSelW), .d(wbDataSelM), .clk(clk), .rst(rst));
dff addPCLatch[15:0](.q(addPCW), .d(addPCM), .clk(clk), .rst(rst));
dff memOutLatch[15:0](.q(memOutW), .d(memOutM), .clk(clk), .rst(rst));
dff aluFinalLatch[15:0](.q(aluFinalW), .d(aluFinalM), .clk(clk), .rst(rst));
dff imm8Latch[15:0](.q(imm8W), .d(imm8M), .clk(clk), .rst(rst));
dff regWrtLatch(.q(regWrtW), .d(regWrtM), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
