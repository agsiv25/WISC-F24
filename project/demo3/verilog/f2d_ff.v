/*
   CS/ECE 552 Spring '22
  
   Filename        : f2d_ff.v
   Description     : This is the flip flop between the fetch and decode cycles.
*/
`default_nettype none
module f2d_ff (instructionF, incPCF, errF, clk, rst, instructionD, incPCD, instrValidD, instrValidF, fwCntrlAF, fwCntrlBF, fwCntrlAD, fwCntrlBD, istall);

input wire [15:0] instructionF;
input wire [15:0] incPCF;
input wire errF;
input wire clk;
input wire rst;
input wire instrValidF;

// forwarding
input wire [4:0] fwCntrlAF, fwCntrlBF;
output wire [4:0] fwCntrlAD, fwCntrlBD;

// icache
input wire istall;
wire cacheClk;
assign cacheClk = (istall) ? 1'b0 : clk;

output wire [15:0] incPCD;
output wire [15:0] instructionD;
output wire instrValidD;

// on reset signal, latch instruction to NOP instead of HALT
dff instructLatch[15:0](.q(instructionD[15:0]), .d(instructionF[15:0]), .clk(cacheClk), .rst(rst));

dff incPCLatch[15:0](.q(incPCD), .d(incPCF), .clk(cacheClk), .rst(rst));

dff instrValidLatch(.q(instrValidD), .d(instrValidF), .clk(cacheClk), .rst(rst));

dff AForwardingLatch [4:0] (.q(fwCntrlAD), .d(fwCntrlAF), .clk(cacheClk), .rst(rst));
dff BForwardingLatch [4:0] (.q(fwCntrlBD), .d(fwCntrlBF), .clk(cacheClk), .rst(rst));

endmodule
`default_nettype wire
