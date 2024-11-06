/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the flip flop between the execute and memory cycles.
*/
`default_nettype none
module  x2wm_ff();

input wire [15:0] aluFinalX;
input wire [15:0] newPCX;
input wire [15:0] addPCX;
input wire [15:0] aluOutX;
input wire [15:0] dataAddrX;
input wire [15:0] wrtDataX;
input wire memWrtX;
input wire createDumpX;
input wire readEnX;
input wire wbDataSelX;
input wire clk;
input wire rst;

output wire [15:0]dataAddrM;
output wire [15:0]wrtDataM;
output wire memWrtM;
output wire createDumpM;
output wire readEnM;
output wire [15:0] aluFinalM;
output wire [15:0] newPCM;
output wire [15:0] addPCM;
output wire [15:0] aluOutM;
output wire readEnM;
output wire [1:0] wbDataSelM;

dff aluFinalLatch[15:0](.Q(aluFinalM), .D(aluFinalX), .clk(clk), .rst(rst));
dff newPCLatch[15:0](.Q(newPCM), .D(newPCX), .clk(clk), .rst(rst));
dff addPCLatch[15:0](.Q(addPCM), .D(addPCX), .clk(clk), .rst(rst));
dff aluOutLatch[15:0](.Q(aluOutM), .D(aluOutX), .clk(clk), .rst(rst));
dff dataAddrLatch[15:0](.Q(dataAddrM), .D(dataAddrX), .clk(clk), .rst(rst));
dff wrtDataLatch[15:0](.Q(wrtDataM), .D(wrtDataX), .clk(clk), .rst(rst));
dff memWrtLatch(.Q(memWrtM), .D(memWrtX), .clk(clk), .rst(rst));
dff createDumpLatch(.Q(createDumpM), .D(createDumpX), .clk(clk), .rst(rst));
dff readEnLatch(.Q(readEnM), .D(readEnX), .clk(clk), .rst(rst));
dff wbDataSelLatch[1:0](.Q(wbDataSelM), .D(wbDataSelX), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
