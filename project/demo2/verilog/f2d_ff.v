/*
   CS/ECE 552 Spring '22
  
   Filename        : f2d_ff.v
   Description     : This is the flip flop between the fetch and decode cycles.
*/
`default_nettype none
module f2d_ff (instructionF, incPCF, errF, clk, rst, instructionD, incPCD);

input wire [15:0] instructionF;
input wire [15:0] incPCF;
input wire errF;
input wire clk;
input wire rst;

output wire [15:0] instructionD;
output wire [15:0] incPCD;

dff instructLatch[15:1](.q(instructionD[15:1]), .d(instructionF[15:1]), .clk(clk), .rst(rst));

dff_high_rst rst_instructLatch(.q(instructionD[0]), .d(instructionF[0]), .clk(clk), .rst(rst));

dff incPCLatch[15:0](.q(incPCD), .d(incPCF), .clk(clk), .rst(rst));

endmodule
`default_nettype wire
