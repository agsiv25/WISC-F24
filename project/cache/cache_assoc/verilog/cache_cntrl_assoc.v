`default_nettype none
module cache_cntrl_assoc(
// inputs 
clk, rst, createdump, data_temp, addr, data_in, rd, wr, hit_cache_1, hit_cache_2, tag_out_1, tag_out_2, dirty_cache_1, dirty_cache_2, valid_cache_1, valid_cache_2, data_out_cache_1, data_out_cache_2, data_out_mem, 
// outputs
enable_cntrl, idx_cntrl, offset_cntrl, comp_cntrl, write_cntrl, tag_cntrl, data_in_cntrl, 
valid_in_cntrl, addr_in_mem, data_in_mem, write_mem, read_mem, Done, Stall, CacheHit, data_out_cntrl, end_state, flop_victim_cntrl, comp_rw, victim_cntrl, tag_out_final, data_out_final, hit_cache_final);


input wire clk, rst, createdump, rd, wr, hit_cache_1, hit_cache_2, dirty_cache_1, dirty_cache_2, valid_cache_1, valid_cache_2, victim_cntrl;
input wire [15:0] addr, data_in, data_out_mem, data_out_cache_1, data_out_cache_2, data_temp, data_out_final;
input wire [4:0] tag_out_1, tag_out_2, tag_out_final;

output reg enable_cntrl, comp_cntrl, write_cntrl, valid_in_cntrl, write_mem, read_mem, Done, Stall, CacheHit, end_state, flop_victim_cntrl, comp_rw, hit_cache_final;
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

wire [3:0] state;
reg [3:0] nxt_state;
wire flop_write, flop_read, flop_en, en_en;
reg write, read, en, en_flag;

assign en_en = (en_flag) ? en : flop_en;

dff dff_enable(.clk(clk), .rst(rst), .q(flop_en), .d(en_en));
dff dff_write(.clk(clk), .rst(rst), .q(flop_write), .d(write));
dff dff_read(.clk(clk), .rst(rst), .q(flop_read), .d(read));
dff dff_state[3:0](.clk(clk), .rst(rst), .q(state), .d(nxt_state));

always @(*) begin
    nxt_state = IDLE;
    enable_cntrl = 1'b0;
    idx_cntrl = 8'bxxxxxxxx;
    offset_cntrl = 3'bxxx;
    comp_cntrl = 1'b0;
    write_cntrl = 1'b0;
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
    en = 1'b0;
    en_flag = 1'b0;
    flop_victim_cntrl = victim_cntrl;
    comp_rw = 1'b0;

    case(state)
        IDLE: begin
            Stall = 1'b0;
            write = 1'b0;
            read = 1'b0;
            nxt_state = rd ? COMP_RD : (wr ? COMP_WR : IDLE);

        end
        COMP_RD: begin
            comp_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = addr[2:0];
            tag_cntrl = addr[15:11];
            comp_rw = 1'b1;
            en_flag = 1'b1;
            Done = hit_cache_final;
            CacheHit = hit_cache_final;
            end_state = hit_cache_final;
            data_out_cntrl = data_out_final;
            read = 1'b1;
            enable_cntrl = (valid_cache_1 & hit_cache_1) | (~valid_cache_1 & valid_cache_2 & ~hit_cache_final) | (~valid_cache_1 & ~valid_cache_2 & ~hit_cache_final) | (valid_cache_1 & valid_cache_2 & ~hit_cache_final & victim_cntrl);
            en = (valid_cache_1 & hit_cache_1) | (~valid_cache_1 & valid_cache_2 & ~hit_cache_final) | (~valid_cache_1 & ~valid_cache_2 & ~hit_cache_final) | (valid_cache_1 & valid_cache_2 & ~hit_cache_final & victim_cntrl);
            nxt_state = (hit_cache_final) ? IDLE : (((~hit_cache_final) & (enable_cntrl) & (valid_cache_1) & (dirty_cache_1)) | (((~hit_cache_final) & (~enable_cntrl) & (valid_cache_2) & (dirty_cache_2)))) ? ACCESS_RD_0 : ACCESS_WR_0;
        end
        COMP_WR: begin
            comp_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = addr[2:0];
            tag_cntrl = addr[15:11];
            comp_rw = 1'b1;
            en_flag = 1'b1;
            Done = hit_cache_final;
            CacheHit = hit_cache_final;
            end_state = hit_cache_final;
            write = 1'b1;
            write_cntrl = 1'b1;
            data_in_cntrl = data_in;
            enable_cntrl = (valid_cache_1 & hit_cache_1) | (~valid_cache_1 & valid_cache_2 & ~hit_cache_final) | (~valid_cache_1 & ~valid_cache_2 & ~hit_cache_final) | (valid_cache_1 & valid_cache_2 & ~hit_cache_final & victim_cntrl);
            en = (valid_cache_1 & hit_cache_1) | (~valid_cache_1 & valid_cache_2 & ~hit_cache_final) | (~valid_cache_1 & ~valid_cache_2 & ~hit_cache_final) | (valid_cache_1 & valid_cache_2 & ~hit_cache_final & victim_cntrl);
            nxt_state = (hit_cache_final) ? IDLE : (((~hit_cache_final) & (enable_cntrl) & (valid_cache_1) & (dirty_cache_1)) | (((~hit_cache_final) & (~enable_cntrl) & (valid_cache_2) & (dirty_cache_2)))) ? ACCESS_RD_0 : ACCESS_WR_0;
        end
        ACCESS_RD_0: begin
            enable_cntrl = flop_en;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b000;
            addr_in_mem = {tag_out_final, idx_cntrl, offset_cntrl};
            data_in_mem = data_out_final;
            write_mem = 1'b1;
            nxt_state = ACCESS_RD_1;               
        end
        ACCESS_RD_1: begin
            enable_cntrl = flop_en;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b010;
            addr_in_mem = {tag_out_final, idx_cntrl, offset_cntrl};
            data_in_mem = data_out_final;
            write_mem = 1'b1;
            nxt_state = ACCESS_RD_2;    
        end
        ACCESS_RD_2: begin
            enable_cntrl = flop_en;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b100;
            addr_in_mem = {tag_out_final, idx_cntrl, offset_cntrl};
            data_in_mem = data_out_final;
            write_mem = 1'b1;
            nxt_state = ACCESS_RD_3;   
        end
        ACCESS_RD_3: begin
            enable_cntrl = flop_en;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b110;
            addr_in_mem = {tag_out_final, idx_cntrl, offset_cntrl};
            data_in_mem = data_out_final;
            write_mem = 1'b1;
            nxt_state = ACCESS_WR_0; 
        end
        ACCESS_WR_0: begin
            enable_cntrl = flop_en;
            read_mem = 1'b1;
            addr_in_mem = {addr[15:3], 3'b000};
            nxt_state = ACCESS_WR_1;
        end
        ACCESS_WR_1: begin
            enable_cntrl = flop_en;
            read_mem = 1'b1;
            addr_in_mem = {addr[15:3], 3'b010};
            nxt_state = ACCESS_WR_2;
        end
        ACCESS_WR_2: begin
            enable_cntrl = flop_en;
            read_mem = 1'b1;
            addr_in_mem = {addr[15:3], 3'b100};
            write_cntrl = 1'b1;
            valid_in_cntrl = 1'b1;
            tag_cntrl = addr[15:11];
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b000;
            data_in_cntrl = (wr & (addr[2:0] === 3'b000)) ? data_in : data_out_mem;
            data_out_cntrl = (rd & (addr[2:0] === 3'b000)) ? data_out_mem : data_temp;
            nxt_state = ACCESS_WR_3;
        end
        ACCESS_WR_3: begin
            enable_cntrl = flop_en;
            read_mem = 1'b1;
            addr_in_mem = {addr[15:3], 3'b110};
            write_cntrl = 1'b1;
            valid_in_cntrl = 1'b1;
            tag_cntrl = addr[15:11];
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b010;
            data_in_cntrl = (wr & (addr[2:0] === 3'b010)) ? data_in : data_out_mem;
            data_out_cntrl = (rd & (addr[2:0] === 3'b010)) ? data_out_mem : data_temp;
            nxt_state = ACCESS_WR_4;
        end
        ACCESS_WR_4: begin
            enable_cntrl = flop_en;
            write_cntrl = 1'b1;
            valid_in_cntrl = 1'b1;
            tag_cntrl = addr[15:11];
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b100;
            data_in_cntrl = (wr & (addr[2:0] === 3'b100)) ? data_in : data_out_mem;
            data_out_cntrl = (rd & (addr[2:0] === 3'b100)) ? data_out_mem : data_temp;
            nxt_state = ACCESS_WR_5;
        end
        ACCESS_WR_5: begin
            flop_victim_cntrl = ~victim_cntrl;
            enable_cntrl = flop_en;
            write_cntrl = 1'b1;
            valid_in_cntrl = 1'b1;
            comp_cntrl = flop_write;
            tag_cntrl = addr[15:11];
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b110;
            data_in_cntrl = (flop_write & (addr[2:0] === 3'b110)) ? data_in : data_out_mem;
            data_out_cntrl = (flop_read & (addr[2:0] === 3'b110)) ? data_out_mem : data_temp;
            Done = 1'b1;
            end_state = 1'b1;
            nxt_state = IDLE;
        end
        default: begin
            nxt_state = IDLE;
        end
    endcase
end

endmodule
`default_nettype wire