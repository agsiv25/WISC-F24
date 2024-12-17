/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (dataAddr, wrtData, memWrt, createDump, clk, rst, memOut, readEn, istall, istallM);

   // TODO: Your code here

   input wire [15:0]dataAddr;
   input wire [15:0]wrtData;
   input wire memWrt;
   input wire createDump;
   input wire clk;
   input wire rst;
   input wire readEn;

   output wire [15:0]memOut;

   // icache
   input wire istall;
   input wire istallM;


   memory2c data_mem(.data_out(memOut), .data_in(wrtData), .addr(dataAddr), .enable(~createDump), .wr(memWrt), .createdump(createDump), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
