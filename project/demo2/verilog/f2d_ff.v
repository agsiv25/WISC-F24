/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the flip flop between the fetch and decode cycles.
*/
`default_nettype none
module f2d_ff (instructionF, incPCF, errF, clk, rst, instructionD, wbDataD);

input wire [15:0] instructionF;
input wire [15:0] incPCF;
input wire errF;
input wire clk;
input wire rst;

output wire [15:0] instructionD;
output wire [15:0] incPCD;

dff instructLatch[15:0](.Q(instructionD), .D(instructionF), .clk(clk), .rst(rst));

dff incPCLatch[15:0](.Q(incPCD), .D(incPCF), .clk(clk), .rst(rst));


   
endmodule
`default_nettype wire
