/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (dataAddr, wrtData, memWrt, createDump, clk, rst, memOut);

   // TODO: Your code here

   input [15:0]dataAddr;
   input [15:0]wrtData;
   input memWrt;
   input createDump;
   input clk;
   input rst;

   output [15:0]memOut;

   memory2c data_mem(.data_out(memOut), .data_in(wrtData), .addr(dataAddr), .enable(1'b1), .wr(memWrt), .createdump(createDump), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
