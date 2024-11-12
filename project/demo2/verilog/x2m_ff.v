/*
   CS/ECE 552 Spring '22
  
   Filename        : x2m.v
   Description     : This is the flip flop between the execute and memory cycles.
*/
`default_nettype none
module  x2m_ff(clk, rst, aluFinalX, newPCX, addPCX, aluOutX, wrtDataX, memWrtX, createDumpX, readEnX, wbDataSelX, wrtDataM, memWrtM, createDumpM, readEnM, aluFinalM, newPCM, addPCM, aluOutM, readEnM, wbDataSelM, imm8X, imm8M, regWrtX, regWrtM);

input wire clk;
input wire rst;

input wire [15:0] aluFinalX;
input wire [15:0] newPCX;
input wire [15:0] addPCX;
input wire [15:0] aluOutX;
input wire [15:0] wrtDataX;
input wire memWrtX;
input wire readEnX;
input wire wbDataSelX;
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

dff aluFinalLatch [15:0] (.Q(aluFinalM), .D(aluFinalX), .clk(clk), .rst(rst));
dff newPCLatch [15:0] (.Q(newPCM), .D(newPCX), .clk(clk), .rst(rst));
dff addPCLatch [15:0] (.Q(addPCM), .D(addPCX), .clk(clk), .rst(rst));
dff aluOutLatch [15:0] (.Q(aluOutM), .D(aluOutX), .clk(clk), .rst(rst));
dff wrtDataLatch [15:0] (.Q(wrtDataM), .D(wrtDataX), .clk(clk), .rst(rst));
dff memWrtLatch(.Q(memWrtM), .D(memWrtX), .clk(clk), .rst(rst));
dff readEnLatch(.Q(readEnM), .D(readEnX), .clk(clk), .rst(rst));
dff wbDataSelLatch [1:0] (.Q(wbDataSelM), .D(wbDataSelX), .clk(clk), .rst(rst));
dff imm8Latch [15:0] (.Q(imm8M), .D(imm8X), .clk(clk), .rst(rst));
dff regWrtLatch (.Q(regWrtM), .D(regWrtX), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
