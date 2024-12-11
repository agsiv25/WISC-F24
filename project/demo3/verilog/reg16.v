/*
   CS/ECE 552, Fall '24
   Homework #3, Problem #1
  
   This module creates a 16-bit register. 
*/
module reg16 (
                // Outputs
                readData, err,
                // Inputs
                clk, rst, writeData, writeEn
                );

	parameter OPERAND_WIDTH = 16;

   input        clk, rst;
   input [OPERAND_WIDTH-1:0] writeData;
   input        writeEn;

   output	[OPERAND_WIDTH-1:0] readData;
   output	err;

   /* YOUR CODE HERE */
	
	wire [OPERAND_WIDTH-1:0] dff_in;
	dff bits [OPERAND_WIDTH-1:0](.q(readData), .d(dff_in), .clk(clk), .rst(rst));

	assign dff_in = (writeEn) ? writeData : readData;

	assign err = (rst & (writeData === 16'hxxxx ^ writeEn === 1'bx)) ? 1'b1 : 1'b0;

endmodule