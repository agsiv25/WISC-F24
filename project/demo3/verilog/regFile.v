/*
   CS/ECE 552, Fall '22
   Homework #3, Problem #1
  
   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
module regFile (
                // Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                );

   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   /* YOUR CODE HERE */

	wire [7:0] regErr;
	wire [15:0] readData [7:0]; // 8 elements, each 16-bit wide
	wire [7:0] regWriteEn;

	reg16 reg0 (.readData(readData[0]), .err(regErr[0]), .clk(clk), .rst(rst), .writeData(writeData), .writeEn(regWriteEn[0]));
	reg16 reg1 (.readData(readData[1]), .err(regErr[1]), .clk(clk), .rst(rst), .writeData(writeData), .writeEn(regWriteEn[1]));
	reg16 reg2 (.readData(readData[2]), .err(regErr[2]), .clk(clk), .rst(rst), .writeData(writeData), .writeEn(regWriteEn[2]));
	reg16 reg3 (.readData(readData[3]), .err(regErr[3]), .clk(clk), .rst(rst), .writeData(writeData), .writeEn(regWriteEn[3]));
	reg16 reg4 (.readData(readData[4]), .err(regErr[4]), .clk(clk), .rst(rst), .writeData(writeData), .writeEn(regWriteEn[4]));
	reg16 reg5 (.readData(readData[5]), .err(regErr[5]), .clk(clk), .rst(rst), .writeData(writeData), .writeEn(regWriteEn[5]));
	reg16 reg6 (.readData(readData[6]), .err(regErr[6]), .clk(clk), .rst(rst), .writeData(writeData), .writeEn(regWriteEn[6]));
	reg16 reg7 (.readData(readData[7]), .err(regErr[7]), .clk(clk), .rst(rst), .writeData(writeData), .writeEn(regWriteEn[7]));


	// assign correct read1Data signal
	assign read1Data = (read1RegSel == 3'b000) ? readData[0] :
            (read1RegSel == 3'b001) ? readData[1] :
            (read1RegSel == 3'b010) ? readData[2] :
            (read1RegSel == 3'b011) ? readData[3] :
            (read1RegSel == 3'b100) ? readData[4] :
            (read1RegSel == 3'b101) ? readData[5] :
            (read1RegSel == 3'b110) ? readData[6] :
            readData[7]; // Default case when read1RegSel == 3'b111


	// assign correct read2Data signal
	assign read2Data = (read2RegSel == 3'b000) ? readData[0] :
            (read2RegSel == 3'b001) ? readData[1] :
            (read2RegSel == 3'b010) ? readData[2] :
            (read2RegSel == 3'b011) ? readData[3] :
            (read2RegSel == 3'b100) ? readData[4] :
            (read2RegSel == 3'b101) ? readData[5] :
            (read2RegSel == 3'b110) ? readData[6] :
            readData[7]; // Default case when read2RegSel == 3'b111


	// assign correct writeEn signal to high
	assign regWriteEn = (writeRegSel == 3'b000 & writeEn) ? 8'h01 : 
	    (writeRegSel == 3'b001 & writeEn) ? 8'h02 :
	    (writeRegSel == 3'b010 & writeEn) ? 8'h04 :
	    (writeRegSel == 3'b011 & writeEn) ? 8'h08 :
	    (writeRegSel == 3'b100 & writeEn) ? 8'h10 :
	    (writeRegSel == 3'b101 & writeEn) ? 8'h20 :
	    (writeRegSel == 3'b110 & writeEn) ? 8'h40 :
	    (writeRegSel == 3'b111 & writeEn) ? 8'h80 :
	    8'h00; // writeEn is 0

	assign err = (~rst & (regErr != 8'b0)) ? 1'b1 : 1'b0;

endmodule
