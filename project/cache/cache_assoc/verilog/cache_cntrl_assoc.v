`default_nettype none
module cache_cntrl_assoc(
// inputs 
clk, rst, createdump, data_temp, addr, data_in, rd, wr, hit_cache_1, hit_cache_2, tag_out_1, tag_out_2, dirty_cache_1, dirty_cache_2, valid_cache_1, valid_cache_2, data_out_cache_1, data_out_cache_2, data_out_mem, 
// outputs
enable_cntrl, idx_cntrl, offset_cntrl, comp_cntrl, write_cntrl_1, write_cntrl_2, tag_cntrl, data_in_cntrl, 
valid_in_cntrl, addr_in_mem, data_in_mem, write_mem, read_mem, Done, Stall, CacheHit, data_out_cntrl, end_state);


input wire clk, rst, createdump, rd, wr, hit_cache_1, hit_cache_2, dirty_cache_1, dirty_cache_2, valid_cache_1, valid_cache_2;
input wire [15:0] addr, data_in, data_out_mem, data_out_cache_1, data_out_cache_2, data_temp;
input wire [4:0] tag_out_1, tag_out_2;

output reg enable_cntrl, comp_cntrl, write_cntrl_1, write_cntrl_2, valid_in_cntrl, write_mem, read_mem, Done, Stall, CacheHit, end_state;
output reg [15:0] data_in_cntrl, addr_in_mem, data_in_mem, data_out_cntrl;
output reg [7:0] idx_cntrl;
output reg [4:0] tag_cntrl;
output reg [2:0] offset_cntrl;


localparam IDLE = 4'b0000; // 0 
localparam COMP_RD = 4'b0001; // 1
localparam COMP_WR = 4'b0010; // 2
localparam ACCESS_RD_0 = 4'b0011; // 3
localparam ACCESS_RD_1 = 4'b0100; // 4
localparam ACCESS_RD_2 = 4'b0101; // 5
localparam ACCESS_RD_3 = 4'b0110; // 6
localparam ACCESS_WR_0 = 4'b0111; // 7
localparam ACCESS_WR_1 = 4'b1000; // 8
localparam ACCESS_WR_2 = 4'b1001; // 9
localparam ACCESS_WR_3 = 4'b1010; // 10
localparam ACCESS_WR_4 = 4'b1011; // 11
localparam ACCESS_WR_5 = 4'b1100; // 12
localparam DONE = 4'b1101; // 13

wire [3:0] state, flop_state;
reg [3:0] nxt_state;
wire flop_hit, flop_write, flop_read;
reg hit, write, read;
dff dff_hit(.clk(clk), .rst(rst), .q(flop_hit), .d(hit));
dff dff_write(.clk(clk), .rst(rst), .q(flop_write), .d(write));
dff dff_read(.clk(clk), .rst(rst), .q(flop_read), .d(read));
dff dff_state[3:0](.clk(clk), .rst(rst), .q(flop_state), .d(nxt_state));
assign state = rst ? IDLE : flop_state;

// assoc logic signals 
reg hit_cache;
reg cache_done;
reg valid_cache;
reg dirty_cache;
reg way_to_vict;

// victimway signal
reg cur_victimway;
reg victimway_invert;

wire cur_victimway_wire;

always @(*) begin
    nxt_state = IDLE;
    enable_cntrl = 1'b0;
    idx_cntrl = 8'b0;
    offset_cntrl = 3'b0;
    comp_cntrl = 1'b0;
    write_cntrl_1 = 1'b0;
    write_cntrl_2 = 1'b0;
    tag_cntrl = 5'bx;
    data_in_cntrl = 16'bx;
    valid_in_cntrl = 1'b0;
    addr_in_mem = 16'bx;
    data_in_mem = 16'bx;
    write_mem = 1'b0;
    read_mem = 1'b0;
    Done = 1'b0;
    Stall = 1'b1;
    CacheHit = 1'b0;
    end_state = 1'b0;
    hit_cache = 1'b0;
    cache_done = 1'b0;
    valid_cache = 1'b0;
    dirty_cache = 1'b0;
    cur_victimway = cur_victimway_wire;

    case(state)
        IDLE: begin
            Stall = 1'b0;
            write = 1'b0;
            read = 1'b0;
            nxt_state = rd ? COMP_RD : (wr ? COMP_WR : IDLE);
            way_to_vict = 1'b0;

        end
        COMP_RD: begin
            enable_cntrl = 1'b1;
            comp_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = addr[2:0];
            tag_cntrl = addr[15:11];
            data_out_cntrl = hit_cache_1 ? data_out_cache_1 : data_out_cache_2;
            hit = 1'b1;
            read = 1'b1;

            // associative logic 
            hit_cache = hit_cache_1 | hit_cache_2;
            cache_done = (valid_cache_1 & hit_cache_1) | (valid_cache_2 & hit_cache_2);
            valid_cache = valid_cache_1 | valid_cache_2;
            dirty_cache = dirty_cache_1 | dirty_cache_2;
            victimway_invert = cur_victimway ? 1'b0 : 1'b1;

            //nxt_state = valid_cache ? (hit_cache ? DONE : (dirty_cache ? ACCESS_RD_0 : ACCESS_WR_0)) : ACCESS_WR_0;

            nxt_state = cache_done ? DONE : (valid_cache ? (dirty_cache ? ACCESS_RD_0 : ACCESS_WR_0) : ACCESS_WR_0) ;
        end
        COMP_WR: begin
            enable_cntrl = 1'b1;
            comp_cntrl = 1'b1;
            // write_cntrl = 1'b1;        // why is this asserted here but not in ACCES_WR_0 or ACCESS_WR_1??
            data_in_cntrl = data_in;
            idx_cntrl = addr[10:3];
            offset_cntrl = addr[2:0];
            tag_cntrl = addr[15:11];
            hit = 1'b1;
            write = 1'b1;

            // associative logic 
            hit_cache = hit_cache_1 | hit_cache_2;
            cache_done = (valid_cache_1 & hit_cache_1) | (valid_cache_2 & hit_cache_2);
            valid_cache = valid_cache_1 | valid_cache_2;
            dirty_cache = dirty_cache_1 | dirty_cache_2;
            victimway_invert = cur_victimway ? 1'b0 : 1'b1;

            //nxt_state = valid_cache ? (hit_cache ? DONE : (dirty_cache ? ACCESS_RD_0 : ACCESS_WR_0)) : ACCESS_WR_0;

            nxt_state = cache_done ? DONE : (valid_cache ? (dirty_cache ? ACCESS_RD_0 : ACCESS_WR_0) : ACCESS_WR_0) ;
        end
        ACCESS_RD_0: begin
            enable_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b000;

            // victimization logic 
            way_to_vict = valid_cache_1 ? (valid_cache_2 ? cur_victimway : 1'b1) : 1'b0;

            addr_in_mem = way_to_vict ? {tag_out_2, idx_cntrl, offset_cntrl} : {tag_out_1, idx_cntrl, offset_cntrl}; 
            data_in_mem = way_to_vict ? data_out_cache_2 : data_out_cache_1;
            write_mem = 1'b1;
            nxt_state = ACCESS_RD_1;               
        end
        ACCESS_RD_1: begin
            enable_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b010;

            addr_in_mem = way_to_vict ? {tag_out_2, idx_cntrl, offset_cntrl} : {tag_out_1, idx_cntrl, offset_cntrl}; 
            data_in_mem = way_to_vict ? data_out_cache_2 : data_out_cache_1;
            write_mem = 1'b1;
            nxt_state = ACCESS_RD_2;    
        end
        ACCESS_RD_2: begin
            enable_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b100;

            addr_in_mem = way_to_vict ? {tag_out_2, idx_cntrl, offset_cntrl} : {tag_out_1, idx_cntrl, offset_cntrl}; 
            data_in_mem = way_to_vict ? data_out_cache_2 : data_out_cache_1;
            write_mem = 1'b1;
            nxt_state = ACCESS_RD_3;    
        end
        ACCESS_RD_3: begin
            enable_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b110;

            addr_in_mem = way_to_vict ? {tag_out_2, idx_cntrl, offset_cntrl} : {tag_out_1, idx_cntrl, offset_cntrl}; 
            data_in_mem = way_to_vict ? data_out_cache_2 : data_out_cache_1;
            write_mem = 1'b1;
            nxt_state = ACCESS_WR_0;
        end
        ACCESS_WR_0: begin
            enable_cntrl = 1'b1;
            read_mem = 1'b1;
            addr_in_mem = {addr[15:3], 3'b000};
            hit = 1'b0;
            nxt_state = ACCESS_WR_1;

            // victimization logic 
            way_to_vict = valid_cache_1 ? (valid_cache_2 ? cur_victimway : 1'b1) : 1'b0;
        end
        ACCESS_WR_1: begin
            enable_cntrl = 1'b1;
            read_mem = 1'b1;
            addr_in_mem = {addr[15:3], 3'b010};
            nxt_state = ACCESS_WR_2;
        end
        ACCESS_WR_2: begin
            enable_cntrl = 1'b1;
            read_mem = 1'b1;
            addr_in_mem = {addr[15:3], 3'b100};

            // assoc write logic 
            write_cntrl_1 = way_to_vict ? 1'b0 : 1'b1;
            write_cntrl_2 = way_to_vict;

            valid_in_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b000;
            tag_cntrl = addr[15:11];
            data_in_cntrl = (wr & (addr[2:0] == 3'b000)) ? data_in : data_out_mem;
            data_out_cntrl = (rd & (addr[2:0] == 3'b000)) ? data_out_mem : data_temp;
            nxt_state = ACCESS_WR_3;
        end
        ACCESS_WR_3: begin
            enable_cntrl = 1'b1;
            read_mem = 1'b1;
            addr_in_mem = {addr[15:3], 3'b110};

            // assoc write logic 
            write_cntrl_1 = way_to_vict ? 1'b0 : 1'b1;
            write_cntrl_2 = way_to_vict;
            
            valid_in_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b010;
            tag_cntrl = addr[15:11];
            data_in_cntrl = (wr & (addr[2:0] == 3'b010)) ? data_in : data_out_mem;
            data_out_cntrl = (rd & (addr[2:0] == 3'b010)) ? data_out_mem : data_temp;
            nxt_state = ACCESS_WR_4;
        end
        ACCESS_WR_4: begin
            enable_cntrl = 1'b1;

            // assoc write logic 
            write_cntrl_1 = way_to_vict ? 1'b0 : 1'b1;
            write_cntrl_2 = way_to_vict;
            
            valid_in_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b100;
            tag_cntrl = addr[15:11];
            data_in_cntrl = (wr & (addr[2:0] == 3'b100)) ? data_in : data_out_mem;
            data_out_cntrl = (rd & (addr[2:0] == 3'b100)) ? data_out_mem : data_temp;
            nxt_state = ACCESS_WR_5;
        end
        ACCESS_WR_5: begin
            enable_cntrl = 1'b1;
            comp_cntrl = flop_write ? 1'b1 : 1'b0;

            // assoc write logic 
            write_cntrl_1 = way_to_vict ? 1'b0 : 1'b1;
            write_cntrl_2 = way_to_vict;
            
            valid_in_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b110;
            tag_cntrl = addr[15:11];
            data_in_cntrl = (flop_write & (addr[2:0] == 3'b110)) ? data_in : data_out_mem;
            data_out_cntrl = (flop_read & (addr[2:0] == 3'b110)) ? data_out_mem : data_temp;
            Done = 1'b1;
            nxt_state = IDLE;
            end_state = 1'b1;
        end
        DONE: begin
            Done = 1'b1;
            CacheHit = flop_hit ? 1'b1 : 1'b0;
            nxt_state = IDLE;
        end
        default: begin
            nxt_state = IDLE;
        end
    endcase
end

dff victimway(.clk(clk), .rst(rst), .q(cur_victimway_wire), .d(victimway_invert));


endmodule
`default_nettype wire