`default_nettype none
module cache_cntrl(clk, rst, addr, data_in, rd, wr , hit_cache, dirty_cache, tag_out, DataOut_cache, valid_cache, DataOut, enable_cntrl, idx_cntrl, offset_cntrl, comp_cntrl, write_cntrl, tag_cache, data_in_cntrl, valid_cntrl, addr_in_mem, data_in_mem, wrt_mem, rd_mem, Done, Stall, CacheHit, data_out_cntrl, done, data_temp);


input wire clk, rst, rd, wr, hit_cache, dirty_cache, valid_cache;
input wire [15:0] addr, data_in, DataOut_cache, data_temp;
input wire [4:0] tag_out;

output reg enable_cntrl, comp_cntrl, write_cntrl, valid_cntrl, wrt_mem, rd_mem, Done, Stall, CacheHit, done;
output reg [15:0] DataOut, DataIn_cntrl, addr_in_mem, data_in_mem, data_out_cntrl;
output reg [7:0] index_cntrl;
output reg [4:0] tag_cntrl;
output reg [2:0] offset_cntrl;

typedef enum state [3:0](
    IDLE,
    COMP_RD,
    COMP_WR,
    ACCESS_RD_0,
    ACCESS_RD_1,
    ACCESS_RD_2,
    ACCESS_RD_3,
    ACCESS_WR_0,
    ACCESS_WR_1,
    ACCESS_WR_2,
    ACCESS_WR_3,
    ACCESS_WR_4,
    ACCESS_WR_5,
    DONE
) state_t;

state_t state, flop_state;
reg [3:0] nxt_state;
wire flop_hit, flop_write, flop_read;
reg hit, write, read;
dff dff_hit(.clk(clk), .rst(rst), q(flop_hit), d(hit));
dff dff_write(.clk(clk), .rst(rst), q(flop_write), d(write));
dff dff_read(.clk(clk), .rst(rst), .q(flop_read), .d(read));
dff dff_state[4:0](.clk(clk), .rst(rst), q(flop_state), d(nxt_state));
assign state = rst ? IDLE : flop_state;


always @(*) begin
    nxt_state = IDLE;
    enable_cntrl = 1'b0;
    idx_cntrl = 8'b0;
    offset_cntrl = 3'b0;
    comp_cntrl = 1'b0;
    write_cntrl = 1'b0;
    tag_cntrl = 5'bx;
    data_in_cntrl = 16'bx;
    valid_cntrl = 1'b0;
    addr_in_mem = 16'bx;
    data_in_mem = 16'bx;
    wrt_mem = 1'b0;
    rd_mem = 1'b0;
    Done = 1'b0;
    Stall = 1'b1;
    CacheHit = 1'b0;
    done = 1'b0;
    case(state)
        IDLE: begin
            Stall = 1'b0;
            write = 1'b0;
            read = 1'b0;
            nxt_state = rd ? COMP_RD : (wr ? COMP_WR : IDLE);
        end
        COMP_RD: begin
            enable_cntrl = 1'b1;
            comp_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = addr[2:0];
            tag_cntrl = addr[15:11];
            data_out_cntrl = DataOut_cache;
            hit = 1'b1;
            read = 1'b1;
            nxt_state = valid_cache ? (hit_cache ? DONE : (dirty_cache ? ACCESS_RD_0 : ACCESS_WR_0)) : ACCESS_WR_0;
        end
        COMP_WR: begin
            enable_cntrl = 1'b1;
            comp_cntrl = 1'b1;
            write_cntrl = 1'b1;
            DataIn_cntrl = data_in;
            idx_cntrl = addr[10:3];
            offset_cntrl = addr[2:0];
            tag_cntrl = addr[15:11];
            hit = 1'b1;
            write = 1'b1;
            nxt_state = valid_cache ? (hit_cache ? DONE : (dirty_cache ? ACCESS_RD_0 : ACCESS_WR_0)) : ACCESS_WR_0;
        end
        ACCESS_RD_0: begin
            enable_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b000;
            addr_in_mem = {tag_out, idx_cntrl, offset_cntrl}; 
            data_in_mem = DataOut_cache;
            wrt_mem = 1'b1;
            nxt_state = ACCESS_RD_1;               
        end
        ACCESS_RD_1: begin
            enable_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b010;
            addr_in_mem = {tag_out, idx_cntrl, offset_cntrl}; 
            data_in_mem = DataOut_cache;
            wrt_mem = 1'b1;
            nxt_state = ACCESS_RD_2;    
        end
        ACCESS_RD_2: begin
            enable_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b100;
            addr_in_mem = {tag_out, idx_cntrl, offset_cntrl}; 
            data_in_mem = DataOut_cache;
            wrt_mem = 1'b1;
            nxt_state = ACCESS_RD_3;    
        end
        ACCESS_RD_3: begin
            enable_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b110;
            addr_in_mem = {tag_out, idx_cntrl, offset_cntrl}; 
            data_in_mem = DataOut_cache;
            wrt_mem = 1'b1;
            nxt_state = ACCESS_WR_0;
        end
        ACCESS_WR_0: begin
            enable_cntrl = 1'b1;
            rd_mem = 1'b1;
            addr_in_mem = (addr[15:3], 3'b000);
            hit = 1'b0;
            nxt_state = ACCESS_WR_1;
        end
        ACCESS_WR_1: begin
            enable_cntrl = 1'b1;
            rd_mem = 1'b1;
            addr_in_mem = (addr[15:3], 3'b010);
            nxt_state = ACCESS_WR_2;
        end
        ACCESS_WR_2: begin
            enable_cntrl = 1'b1;
            rd_mem = 1'b1;
            addr_in_mem = (addr[15:3], 3'b100);
            write_cntrl = 1'b1;
            valid_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b000;
            tag_cntrl = addr[15:11];
            data_in_cntrl = (wr & (addr[2:0] == 3'b000)) ? data_in : DataOut;
            data_out_cntrl = (rd & (addr[2:0] == 3'b000)) ? data_out_mem : data_temp;
            nxt_state = ACCESS_WR_3;
        end
        ACCESS_WR_3: begin
            enable_cntrl = 1'b1;
            rd_mem = 1'b1;
            addr_in_mem = (addr[15:3], 3'b110);
            write_cntrl = 1'b1;
            valid_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b010;
            tag_cntrl = addr[15:11];
            data_in_cntrl = (wr & (addr[2:0] == 3'b010)) ? data_in : DataOut;
            data_out_cntrl = (rd & (addr[2:0] == 3'b010)) ? data_out_mem : data_temp;
            nxt_state = ACCESS_WR_3;
        end
        ACCESS_WR_4: begin
            enable_cntrl = 1'b1;
            write_cntrl = 1'b1;
            valid_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b100;
            tag_cntrl = addr[15:11];
            data_in_cntrl = (wr & (addr[2:0] == 3'b100)) ? data_in : DataOut;
            data_out_cntrl = (rd & (addr[2:0] == 3'b100)) ? data_out_mem : data_temp;
            nxt_state = ACCESS_WR_5;
        end
        ACCESS_WR_5: begin
            enable_cntrl = 1'b1;
            comp_cntrl = flop_write ? 1'b1 : 1'b0;
            write_cntrl = 1'b1;
            valid_cntrl = 1'b1;
            idx_cntrl = addr[10:3];
            offset_cntrl = 3'b110;
            tag_cntrl = addr[15:11];
            data_in_cntrl = (wr & (addr[2:0] == 3'b110)) ? data_in : DataOut;
            data_out_cntrl = (rd & (addr[2:0] == 3'b110)) ? data_out_mem : data_temp;
            Done = 1'b1;
            nxt_state = IDLE;
            done = 1'b1;
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
endmodule
`default_nettype wire