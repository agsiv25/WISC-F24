/*
   CS/ECE 552 Spring '22
  
   Filename        : f2d_ff.v
   Description     : This is the flip flop between the fetch and decode cycles.
*/
`default_nettype none
module f2d_ff (instructionF, incPCF, errF, clk, rst, branchInstF, instructionD, incPCD, branchInstD, instrValidD, instrValidF);

input wire [15:0] instructionF;
input wire [15:0] incPCF;
input wire errF;
input wire clk;
input wire rst;
input wire branchInstF;
input wire instrValidF;

output wire [15:0] instructionD;
output wire [15:0] incPCD;
output wire branchInstD;
output wire instrValidD;

// on reset signal, latch instruction to NOP instead of HALT
dff instructLatch[15:0](.q(instructionD[15:1]), .d(instructionF[15:1]), .clk(clk), .rst(rst));

dff incPCLatch[15:0](.q(incPCD), .d(incPCF), .clk(clk), .rst(rst));

dff branchInstLatch(.q(branchInstD), .d(branchInstF), .clk(clk), .rst(rst));

dff instrValidLatch(.q(instrValidD), .d(instrValidF), .clk(clk), .rst(rst));

endmodule
`default_nettype wire
