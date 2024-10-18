/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (newPC, halt, rst, clk, incPC, instruction);


output [15:0]instruction;
output [15:0]incPC;

input [15:0]newPC;
input halt;
input rst;
input clk;

wire [15:0]ReadAddr; 
wire [15:0]nextPC;

cla_16 pc_inc(.sum(incPC), .cout(), .ofl(), .a(ReadAddr), .b(16'h2), .c_in(1'b0), .sign(1'b0));

reg16 PC(.readData(ReadAddr), .err(), .clk(clk), .rst(rst), .writeData(nextPC), .writeEnable(1'b1));

mux2_1 pc_halt_mux(.Out(nextPC), .S(halt), .InpA(newPC), .InpB(ReadAddr));

memory2c instruction_memory(.data_out(instruction), .data_in(16'b0), .addr(ReadAddr), .enable(1'b1), .wr(0), .createdump(1'b0), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
