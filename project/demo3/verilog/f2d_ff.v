/*
   CS/ECE 552 Spring '22
  
   Filename        : f2d_ff.v
   Description     : This is the flip flop between the fetch and decode cycles.
*/
`default_nettype none
module f2d_ff (instructionF, incPCF, errF, clk, rst, instructionD, incPCD, instrValidD, instrValidF, x2xACntrlF, x2xBCntrlF, x2xACntrlD, x2xBCntrlD);

input wire [15:0] instructionF;
input wire [15:0] incPCF;
input wire errF;
input wire clk;
input wire rst;
input wire instrValidF;

// EX to EX forwarding
input wire x2xACntrlF;
input wire x2xBCntrlF;

output wire x2xACntrlD;
output wire x2xBCntrlD;

output wire [15:0] incPCD;
output wire [15:0] instructionD;
output wire instrValidD;

// on reset signal, latch instruction to NOP instead of HALT
dff instructLatch[15:0](.q(instructionD[15:0]), .d(instructionF[15:0]), .clk(clk), .rst(rst));

dff incPCLatch[15:0](.q(incPCD), .d(incPCF), .clk(clk), .rst(rst));

dff instrValidLatch(.q(instrValidD), .d(instrValidF), .clk(clk), .rst(rst));

dff x2xAForwardingLatch(.q(x2xACntrlD), .d(x2xACntrlF), .clk(clk), .rst(rst));
dff x2xBForwardingLatch(.q(x2xBCntrlD), .d(x2xBCntrlF), .clk(clk), .rst(rst));

endmodule
`default_nettype wire
