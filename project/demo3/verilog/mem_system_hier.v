/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

`default_nettype none
module mem_system_hier(/*AUTOARG*/
                       // Outputs
                       DataOut, Done, Stall, CacheHit, err,
                       // Inputs
                       Addr, DataIn, Rd, Wr, createdump, clk, rst
                       );
   
   input wire  [15:0] Addr;
   input wire  [15:0] DataIn;
   input wire         Rd;
   input wire         Wr;
   input wire         createdump;
   input wire         clk;
   input wire         rst;
   
   output wire [15:0] DataOut;
   output wire        Done;
   output wire        Stall;
   output wire        CacheHit;
   output wire         err;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter mem_type = 0;


   
   // Does not matter until you hook this up into your final processor
   
   mem_system #(mem_type) m0(/*AUTOINST*/
                      // Outputs
                      .DataOut          (DataOut[15:0]),
                      .Done             (Done),
                      .Stall            (Stall),
                      .CacheHit         (CacheHit),
                      .err              (err),
                      // Inputs
                      .Addr             (Addr[15:0]),
                      .DataIn           (DataIn[15:0]),
                      .Rd               (Rd),
                      .Wr               (Wr),
                      .createdump       (createdump),
                      .clk              (clk),
                      .rst              (rst));
   
endmodule // mem_system_hier
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:
