/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (dataAddr, wrtData, memWrt, createDump, clk, rst, memOut, readEn, istall, istallM, dstall, dcacheErr);

   // TODO: Your code here

   input wire [15:0]dataAddr;
   input wire [15:0]wrtData;
   input wire memWrt;
   input wire createDump;
   input wire clk;
   input wire rst;
   input wire readEn;

   output wire [15:0]memOut;

   // cache
   input wire istall;
   input wire istallM;
   output wire dstall;
   output wire dcacheErr;
   wire enable;
   wire done;
   wire dstall_local;

   assign enable = ~createDump & ~(istall & istallM & readEn);
   assign dstall = (dstall_local | dcacheErr)

// memory2c data_mem(.data_out(memOut), .data_in(wrtData), .addr(dataAddr), .enable(enable), .wr(memWrt), .createdump(createDump), .clk(clk), .rst(rst));
   
// D-CACHE (mem_type param set to 1):
mem_system #(1) m0(/*AUTOINST*/
                      // Outputs
                      .DataOut          (memOut),
                      .Done             (done),
                      .Stall            (dstall_local),
                      .CacheHit         (cacheHit),
                      .err              (dcacheErr),
                      // Inputs
                      .Addr             (dataAddr),
                      .DataIn           (wrtData),
                      .Rd               (enable & ~memWrt),
                      .Wr               (enable & memWrt),
                      .createdump       (createDump | dcacheErr),
                      .clk              (clk),
                      .rst              (rst));

endmodule
`default_nettype wire
