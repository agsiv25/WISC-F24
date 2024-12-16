/*
   CS/ECE 552 Spring '22
  
   Filename        : f2d_ff.v
   Description     : This is the flip flop between the fetch and decode cycles.
*/
`default_nettype none
module f2d_ff (instructionF, incPCF, errF, clk, rst, instructionD, incPCD, instrValidD, instrValidF, fwCntrlAF, fwCntrlBF, fwCntrlAD, fwCntrlBD, Stall);

input wire [15:0] instructionF;
input wire [15:0] incPCF;
input wire errF;
input wire clk;
input wire rst;
input wire instrValidF;

// stall signal
input wire Stall;

// forwarding
input wire [4:0] fwCntrlAF, fwCntrlBF;
output wire [4:0] fwCntrlAD, fwCntrlBD;

output wire [15:0] incPCD;
output wire [15:0] instructionD;
output wire instrValidD;

wire [15:0] instQ;
wire [15:0] incPCQ;
wire instrValidQ;
wire [4:0] AForwardingQ;
wire [4:0] BForwardingQ;

// on reset signal, latch instruction to NOP instead of HALT
assign instQ = (Stall) ? instructionD : instructionF;
dff instructLatch[15:0](.q(instructionD[15:0]), .d(instQ), .clk(clk), .rst(rst));

assign incPCQ = (Stall) ? incPCD : incPCF;
dff incPCLatch[15:0](.q(incPCD), .d(incPCQ), .clk(clk), .rst(rst));

assign instrValidQ = (Stall) ? instrValidD : instrValidF;
dff instrValidLatch(.q(instrValidD), .d(instrValidQ), .clk(clk), .rst(rst));

assign AForwardingQ = (Stall) ? fwCntrlAD : fwCntrlAF;
dff AForwardingLatch [4:0] (.q(fwCntrlAD), .d(AForwardingQ), .clk(clk), .rst(rst));

assign BForwardingQ = (Stall) ? fwCntrlBD : fwCntrlBF;
dff BForwardingLatch [4:0] (.q(fwCntrlBD), .d(BForwardingQ), .clk(clk), .rst(rst));

endmodule
`default_nettype wire
