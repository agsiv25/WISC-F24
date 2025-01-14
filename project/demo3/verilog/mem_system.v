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
   output wire        Done;
   output wire        Stall;
   output wire        CacheHit;
   output wire        err;

   // added signals 
   
   wire err_cache_1, err_cache_2, err_mem;
   wire hit_cache_1, hit_cache_2, cache_hit_final, dirty_cache_1, dirty_cache_2, valid_cache_1, valid_cache_2, done_state, flop_victim_cntrl, comp_rw, victim_cntrl;
   wire enable_cntrl_1, enable_cntrl_2, enable_cntrl, comp_cntrl, write_cntrl, valid_in_cntrl;
   wire write_mem, read_mem;
   wire stall_mem;
   
   wire [15:0] data_out_cntrl, data_out_mem, data_in_mem, data_in_cntrl, data_out_cache_1, data_out_cache_2, addr_in_mem, data_temp, data_out_final;
   wire [7:0] idx_cntrl;
   wire [4:0] tag_out_1, tag_out_2, tag_cntrl, tag_out_final;
   wire [3:0] busy_mem;
   wire [2:0] offset_cntrl;
   
   

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out_1),
                          .data_out             (data_out_cache_1),
                          .hit                  (hit_cache_1),
                          .dirty                (dirty_cache_1),
                          .valid                (valid_cache_1),
                          .err                  (err_cache_1),
                          // Inputs
                          .enable               (enable_cntrl_1),
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
   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (tag_out_2),
                          .data_out             (data_out_cache_2),
                          .hit                  (hit_cache_2),
                          .dirty                (dirty_cache_2),
                          .valid                (valid_cache_2),
                          .err                  (err_cache_2),
                          // Inputs
                          .enable               (enable_cntrl_2),
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
   
   cache_cntrl_assoc control(
                     // Inputs
                     .clk                      (clk),
                     .rst                      (rst),
                     .createdump               (createdump),
                     .data_temp                (data_temp),
                     .addr                     (Addr),
                     .data_in                  (DataIn),
                     .rd                       (Rd),
                     .wr                       (Wr),
                     .tag_out_final            (tag_out_final),
                     .data_out_final           (data_out_final),
                     .hit_cache_final          (cache_hit_final),
                     .hit_cache_1              (hit_cache_1),
                     .dirty_cache_1            (dirty_cache_1),
                     .valid_cache_1            (valid_cache_1),
                     .hit_cache_2              (hit_cache_2),
                     .dirty_cache_2            (dirty_cache_2),
                     .valid_cache_2            (valid_cache_2),
                     .data_out_mem             (data_out_mem),
                     .flop_victim_cntrl        (flop_victim_cntrl),
                     
                     // Outputs
                     .enable_cntrl             (enable_cntrl),
                     .tag_cntrl                (tag_cntrl),
                     .idx_cntrl                (idx_cntrl),
                     .offset_cntrl             (offset_cntrl),
                     .data_in_cntrl            (data_in_cntrl),
                     .comp_cntrl               (comp_cntrl),
                     .write_cntrl              (write_cntrl),
                     .valid_in_cntrl           (valid_in_cntrl),
                     .addr_in_mem              (addr_in_mem),
                     .data_in_mem              (data_in_mem),
                     .write_mem                (write_mem),
                     .read_mem                 (read_mem),
                     .data_out_cntrl           (data_out_cntrl), 
                     .Done                     (Done), 
                     .Stall                    (Stall), 
                     .CacheHit                 (CacheHit), 
                     .end_state                (done_state),
                     .victim_cntrl             (victim_cntrl),
                     .comp_rw                  (comp_rw));
   
   
   assign err = err_cache_1 | err_cache_2 | err_mem;
   assign enable_cntrl_1 = comp_rw | enable_cntrl;
   assign enable_cntrl_2 = comp_rw | ~enable_cntrl;
   assign DataOut = done_state ? data_out_cntrl : data_temp;
   assign cache_hit_final = valid_cache_1 & hit_cache_1 | valid_cache_2 & hit_cache_2;
   assign tag_out_final = enable_cntrl ? tag_out_1 : tag_out_2;
   assign data_out_final = enable_cntrl ? data_out_cache_1 : data_out_cache_2;

   dff dff_data[15:0](.clk(clk), .rst(rst), .q(data_temp), .d(data_out_cntrl));
   dff victimway(.clk(clk), .rst(rst), .q(flop_victim_cntrl), .d(victim_cntrl));
   
endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9: