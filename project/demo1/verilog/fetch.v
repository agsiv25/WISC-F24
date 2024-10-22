/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (newPC, halt, rst, clk, incPC, instruction, err);

input [15:0]newPC;
input halt;
input rst;
input clk;

output [15:0]instruction;
output [15:0]incPC;
output err;

wire [15:0]pcRegAddr; 
wire [15:0]nextPC;
wire pcIncErr;
wire pcRegErr;

cla_16 pc_inc(.sum(incPC), .cout(), .ofl(pcIncErr), .a(ReadAddr), .b(16'h2), .c_in(1'b0), .sign(1'b0));

reg16 PC(.readData(pcRegAddr), .err(pcRegErr), .clk(clk), .rst(rst), .writeData(nextPC), .writeEnable(1'b1));

//mux2_1 pc_halt_mux(.Out(nextPC), .S(halt), .InpA(newPC), .InpB(pcRegAddr));
assign nextPC = (halt) ? pcRegAddr : newPC;

// assign error signal to be an OR between the PC adder and the PC register
assign err = pcRegErr | pcIncErr;

memory2c instruction_memory(.data_out(instruction), .data_in(16'b0), .addr(pcRegAddr), .enable(1'b1), .wr(0), .createdump(1'b0), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
