/*
   CS/ECE 552 Spring '22
  
   Filename        : x2m.v
   Description     : This is the flip flop between the execute and memory cycles.
*/
`default_nettype none
module  x2m_ff(clk, rst, aluFinalX, newPCX, addPCX, aluOutX, wrtDataX, memWrtX, readEnX, wbDataSelX, wrtDataM, memWrtM, readEnM, aluFinalM, newPCM, addPCM, aluOutM, readEnM, wbDataSelM, imm8X, imm8M, regWrtX, regWrtM);

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

dff aluFinalLatch [15:0] (.q(aluFinalM), .d(aluFinalX), .clk(clk), .rst(rst));
dff newPCLatch [15:0] (.q(newPCM), .d(newPCX), .clk(clk), .rst(rst));
dff addPCLatch [15:0] (.q(addPCM), .d(addPCX), .clk(clk), .rst(rst));
dff aluOutLatch [15:0] (.q(aluOutM), .d(aluOutX), .clk(clk), .rst(rst));
dff wrtDataLatch [15:0] (.q(wrtDataM), .d(wrtDataX), .clk(clk), .rst(rst));
dff memWrtLatch(.q(memWrtM), .d(memWrtX), .clk(clk), .rst(rst));
dff readEnLatch(.q(readEnM), .d(readEnX), .clk(clk), .rst(rst));
dff wbDataSelLatch [1:0] (.q(wbDataSelM), .d(wbDataSelX), .clk(clk), .rst(rst));
dff imm8Latch [15:0] (.q(imm8M), .d(imm8X), .clk(clk), .rst(rst));
dff regWrtLatch (.q(regWrtM), .d(regWrtX), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
