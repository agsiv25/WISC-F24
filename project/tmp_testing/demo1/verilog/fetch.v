/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (newPC, createDump, rst, clk, incPC, instruction, err);

input wire [15:0]newPC;
input wire createDump;
input wire rst;
input wire clk;

output wire [15:0]instruction;
output wire [15:0]incPC;
output wire err;

wire [15:0]pcRegAddr; 
wire [15:0]nextPC;
wire pcIncErr;
wire pcRegErr;

cla_16b pc_inc(.sum(incPC), .c_out(), .ofl(pcIncErr), .a(pcRegAddr), .b(16'h2), .c_in(1'b0), .sign(1'b0));

reg16 PC(.readData(pcRegAddr), .err(pcRegErr), .clk(clk), .rst(rst), .writeData(newPC), .writeEn(~createDump));


// assign error signal to be an OR between the PC adder and the PC register
assign err = pcRegErr | pcIncErr;

memory2c instruction_memory(.data_out(instruction), .data_in(16'b0), .addr(pcRegAddr), .enable(1'b1), .wr(1'b0), .createdump(createDump), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
