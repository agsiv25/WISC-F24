/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (dataAddr, wrtData, memWrt, createDump, clk, rst, memOut, readEn, alignErr, memAccessM, alignErr_ff);

   // TODO: Your code here

   input wire [15:0]dataAddr;
   input wire [15:0]wrtData;
   input wire memWrt;
   input wire createDump;
   input wire clk;
   input wire rst;
   input wire readEn;
   input wire memAccessM;

   output wire [15:0]memOut;
   output wire alignErr;

   output wire alignErr_ff;


   memory2c_align data_mem(.data_out(memOut), .data_in(wrtData), .addr(dataAddr), .enable(~createDump & memAccessM), .wr(memWrt), .createdump(createDump | alignErr_ff), .clk(clk), .rst(rst), .err(alignErr));

   dff alignErr_ff_dff(.q(alignErr_ff), .d(alignErr), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
