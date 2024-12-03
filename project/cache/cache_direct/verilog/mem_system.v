/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

`default_nettype none
module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input wire [15:0] Addr;
   input wire [15:0] DataIn;
   input wire        Rd;
   input wire        Wr;
   input wire        createdump;
   input wire        clk;
   input wire        rst;
   
   output wire [15:0] DataOut;
   output reg        Done;
   output reg        Stall;
   output reg        CacheHit;
   output wire        err;

   wire err_cache, err_mem;
   wire [15:0] data_out_cntrl, data_out_mem, data_in_mem, data_in_cntrl, data_out_cache, addr_in_mem, data_temp;
   wire [4:0] tag_out, tag_cntrl;
   wire hit_cache, dirty_cache, valid_cache, done_state;
   wire enable_cntrl, comp_cntrl, write_cntrl, valid_in_cntrl;
   wire write_mem, read_mem;
   wire  stall_mem;
   wire [2:0] offset_cntrl;
   wire [3:0] busy_mem;
   wire [7:0] idx_cntrl;
   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out),
                          .data_out             (data_out_cache),
                          .hit                  (hit_cache),
                          .dirty                (dirty_cache),
                          .valid                (valid_cache),
                          .err                  (err_cache),
                          // Inputs
                          .enable               (enable_cntrl),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_cntrl),
                          .index                (idx_cntrl),
                          .offset               (offset_cntrl),
                          .data_in              (data_in_cntrl),
                          .comp                 (comp_cntrl),
                          .write                (write_cntrl),
                          .valid_in             (valid_in_cntrl));

   four_bank_mem mem(// Outputs
                     .data_out          (data_out_mem),
                     .stall             (stall_mem),
                     .busy              (busy_mem),
                     .err               (err_mem),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (addr_in_mem),
                     .data_in           (data_in_mem),
                     .wr                (write_mem),
                     .rd                (read_mem));

   cache_cntrl controller(
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .data_temp         (data_temp),
                     .addr              (Addr),
                     .data_in           (DataIn),
                     .rd                (Rd),
                     .wr                (Wr),
                     .hit_cache         (hit_cache),
                     .dirty_cache       (dirty_cache),
                     .tag_out           (tag_out),
                     .data_out_cache    (data_out_cache),
                     .valid_cache       (valid_cache),
                     .data_out_mem      (data_out_mem),
                     .enable_cntrl      (enable_cntrl),
                     .idx_cntrl         (idx_cntrl),
                     .offset_cntrl      (offset_cntrl),
                     .comp_cntrl        (comp_cntrl),
                     .write_cntrl       (write_cntrl),
                     .tag_cntrl         (tag_cntrl),
                     .data_in_cntrl     (data_in_cntrl),
                     .valid_in_cntrl    (valid_in_cntrl),
                     .addr_in_mem       (addr_in_mem),
                     .data_in_mem       (data_in_mem),
                     .write_mem         (write_mem),
                     .read_mem          (read_mem),
                     .Done              (Done),
                     .Stall             (Stall),
                     .CacheHit          (CacheHit),
                     .data_out_cntrl    (data_out_cntrl),
                     .end_state         (done_state));
   
   // your code here
   assign err = err_cache | err_mem;

   dff dff_data[15:0](.clk(clk), .rst(rst), .q(data_temp), .d(data_out_cntrl));

   assign DataOut = done_state ? data_out_cntrl : data_temp;
endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:
