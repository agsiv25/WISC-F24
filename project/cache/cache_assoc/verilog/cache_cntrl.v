module cache_cntrl(
    output reg enable_cntrl,
    output reg [4:0] tag_cntrl,
    output reg [7:0] idx_cntrl,
    output reg [2:0] offset_cntrl,
    output reg [15:0] data_in_cntrl,
    output reg comp_cntrl,           
    output reg write_cntrl,           
    output reg valid_in_cntrl,     
    
    output reg [15:0] addr_in_mem,           
    output reg [15:0] data_in_mem,          
    output reg write_mem,                
    output reg read_mem,                

    output reg [15:0] data_out_cntrl,         
    output reg Done,                  
    output reg Stall,                 
    output reg CacheHit,              
    output reg end_state,     

    output reg victim_cntrl,
    output reg comp_rw,


    input wire clk,                   
    input wire rst,                   
    input wire createdump,

    input wire [15:0] data_temp,
    input wire [15:0] addr,                  
    input wire [15:0] data_in,                
    input wire rd,                   
    input wire wr,                   
    
    input wire [4:0] tag_out_final,             

    input wire [15:0] data_out_final,  

    input wire hit_cache_final,             
    input wire hit_cache_1,             
    input wire hit_cache_2,             

    input wire dirty_cache_1,           
    input wire dirty_cache_2,           

    input wire valid_cache_1,
    input wire valid_cache_2,

    input wire [15:0] data_out_mem,           

    input wire flop_victim_cntrl
);
// TODO add correct widths for module in/out sigs

    localparam IDLE = 4'b0000;
    localparam COMPARE_READ = 4'b0010; 
    localparam COMPARE_WRITE = 4'b0011; 
    localparam ACCESS_READ_1 = 4'b0100; 
    localparam ACCESS_READ_2 = 4'b0101; 
    localparam ACCESS_READ_3 = 4'b0110; 
    localparam ACCESS_READ_4 = 4'b0111; 
    localparam ACCESS_WRITE_1 = 4'b1000; 
    localparam ACCESS_WRITE_2 = 4'b1001; 
    localparam ACCESS_WRITE_3 = 4'b1010;
    localparam ACCESS_WRITE_4 = 4'b1011;
    localparam ACCESS_WRITE_5 = 4'b1100;
    localparam ACCESS_WRITE_6 = 4'b1101; 
    localparam DONE = 4'b0001; 

    wire[3:0] state;
    reg [3:0 ]nxt_state;

    dff STATE[3:0](.q(state), .d(nxt_state), .clk(clk), .rst(rst));

    // wire hit_ff_q;
    // reg hit_ff_d;
    // dff HIT(.q(hit_ff_q), .d(hit_ff_d), .clk(clk), .rst(rst));
    wire flop_en;
    reg en;
    reg en_flag;
    wire en_en;
    assign en_en = (en_flag) ? en : flop_en;
    dff EN(.q(flop_en), .d(en_en), .clk(clk), .rst(rst));


    wire flop_write;
    reg write;
    dff WR(.q(flop_write), .d(write), .clk(clk), .rst(rst));

    wire flop_read;
    reg read;
    dff RD(.q(flop_read), .d(read), .clk(clk), .rst(rst));

    always @* begin
        // Defaults
        nxt_state = IDLE;

        enable_cntrl = 1'b0;
        valid_in_cntrl = 1'b0; 
        tag_cntrl = 5'hxxxx;
        idx_cntrl = 8'hxxxxxxxx;
        offset_cntrl = 3'hxxx;
        
        data_in_cntrl = 16'hxxxxxxxxxxxxxxxx;

        comp_cntrl = 1'b0;           
        write_cntrl = 1'b0;     
        

        write_mem = 1'b0;
        read_mem = 1'b0;
        addr_in_mem = 16'hxxxxxxxxxxxxxxxx;
        data_in_mem = 16'hxxxxxxxxxxxxxxxx;


        Done = 1'b0;
        Stall = 1'b1;
        CacheHit = 1'b0;
        end_state = 1'b0;

        victim_cntrl = flop_victim_cntrl;
        en_flag = 1'b0;
        en = 1'b0;
        comp_rw = 1'b0;


        case(state)
            IDLE: begin
                Stall = 1'b0;
                write = 1'b0;
                read = 1'b0;
                nxt_state = rd ? (COMPARE_READ) : (wr ? (COMPARE_WRITE) : (IDLE));
            end
            COMPARE_READ: begin

                tag_cntrl =  addr[15:11];
                idx_cntrl = addr[10:3];
                offset_cntrl = addr[2:0];

                enable_cntrl = ((~hit_cache_final & valid_cache_1 & valid_cache_2 & flop_victim_cntrl)) | (~hit_cache_final & ~valid_cache_1 & valid_cache_2) | (~hit_cache_final & ~valid_cache_1 & ~valid_cache_2) | (hit_cache_1 & valid_cache_1);
                en =  ((~hit_cache_final & valid_cache_1 & valid_cache_2 & flop_victim_cntrl)) | (~hit_cache_final & ~valid_cache_1 & valid_cache_2) | (~hit_cache_final & ~valid_cache_1 & ~valid_cache_2) | (hit_cache_1 & valid_cache_1);
                comp_rw = 1'b1;
                en_flag = 1'b1;

                Done = hit_cache_final;
                CacheHit = hit_cache_final;
                end_state = hit_cache_final;


                comp_cntrl = 1'b1;
                data_out_cntrl = data_out_final;

                read = 1'b1;
                nxt_state = (hit_cache_final) ? IDLE : (((~hit_cache_final) & (enable_cntrl) & (valid_cache_1) & (dirty_cache_1)) | (((~hit_cache_final) & (~enable_cntrl) & (valid_cache_2) & (dirty_cache_2)))) ? ACCESS_READ_1 : ACCESS_WRITE_1;
            end
            COMPARE_WRITE: begin

                tag_cntrl =  addr[15:11];
                idx_cntrl = addr[10:3];
                offset_cntrl = addr[2:0];

                enable_cntrl = ((~hit_cache_final & valid_cache_1 & valid_cache_2 & flop_victim_cntrl)) | (~hit_cache_final & ~valid_cache_1 & valid_cache_2) | (~hit_cache_final & ~valid_cache_1 & ~valid_cache_2) | (hit_cache_1 & valid_cache_1);
                en =  ((~hit_cache_final & valid_cache_1 & valid_cache_2 & flop_victim_cntrl)) | (~hit_cache_final & ~valid_cache_1 & valid_cache_2) | (~hit_cache_final & ~valid_cache_1 & ~valid_cache_2) | (hit_cache_1 & valid_cache_1);
                comp_rw = 1'b1;
                en_flag = 1'b1;

                Done = hit_cache_final;
                CacheHit = hit_cache_final;
                end_state = hit_cache_final;                

                comp_cntrl = 1'b1;
                write_cntrl = 1'b1;
                data_in_cntrl = data_in;

                write = 1'b1;
                nxt_state = (hit_cache_final) ? IDLE : (((~hit_cache_final) & (enable_cntrl) & (valid_cache_1) & (dirty_cache_1)) | (((~hit_cache_final) & (~enable_cntrl) & (valid_cache_2) & (dirty_cache_2)))) ? ACCESS_READ_1 : ACCESS_WRITE_1;
            end
            ACCESS_READ_1: begin

                addr_in_mem = {tag_out_final, addr[10:3], 3'b000};
                offset_cntrl = 3'b000;
                idx_cntrl = addr[10:3];
                enable_cntrl = flop_en;
                write_mem = 1'b1;
                data_in_mem = data_out_final;
                nxt_state = ACCESS_READ_2;
            end
            ACCESS_READ_2: begin

                addr_in_mem = {tag_out_final, addr[10:3], 3'b010};
                offset_cntrl = 3'b010;
                idx_cntrl = addr[10:3];
                enable_cntrl = flop_en;
                write_mem = 1'b1;
                data_in_mem = data_out_final;
                nxt_state = ACCESS_READ_3;
            end
            ACCESS_READ_3: begin

                addr_in_mem = {tag_out_final, addr[10:3], 3'b100};
                offset_cntrl = 3'b100;
                idx_cntrl = addr[10:3];
                enable_cntrl = flop_en;
                write_mem = 1'b1;
                data_in_mem = data_out_final;
                nxt_state = ACCESS_READ_4;
            end
            ACCESS_READ_4: begin

                addr_in_mem = {tag_out_final, addr[10:3], 3'b110};
                offset_cntrl = 3'b110;
                idx_cntrl = addr[10:3];
                enable_cntrl = flop_en;
                write_mem = 1'b1;
                data_in_mem = data_out_final;
                nxt_state = ACCESS_WRITE_1;
            end
            ACCESS_WRITE_1: begin

                enable_cntrl = flop_en;
                read_mem = 1'b1;
                addr_in_mem = {addr[15:3],3'b000};
                nxt_state = ACCESS_WRITE_2;
            end
            ACCESS_WRITE_2: begin

                enable_cntrl = flop_en;
                read_mem = 1'b1;
                addr_in_mem = {addr[15:3],3'b010};
                nxt_state = ACCESS_WRITE_3;
            end
            ACCESS_WRITE_3: begin

                enable_cntrl = flop_en;
                read_mem = 1'b1;
                addr_in_mem = {addr[15:3],3'b100};
                
                write_cntrl = 1'b1;
                valid_in_cntrl = 1'b1;

                tag_cntrl = addr[15:11];
                idx_cntrl = addr[10:3];
                offset_cntrl = 3'b000;

                data_in_cntrl = (wr & (addr[2:0] === 3'b000)) ? data_in : data_out_mem;
                data_out_cntrl = (rd & (addr[2:0] === 3'b000)) ? data_out_mem : data_temp;
                nxt_state = ACCESS_WRITE_4;
            end
            ACCESS_WRITE_4: begin

                enable_cntrl = flop_en;
                read_mem = 1'b1;
                addr_in_mem = {addr[15:3],3'b110};
                
                write_cntrl = 1'b1;
                valid_in_cntrl = 1'b1;

                tag_cntrl = addr[15:11];
                idx_cntrl = addr[10:3];
                offset_cntrl = 3'b010;

                data_in_cntrl = (wr & (addr[2:0] === 3'b010)) ? data_in : data_out_mem;
                data_out_cntrl = (rd & (addr[2:0] === 3'b010)) ? data_out_mem : data_temp;
                nxt_state = ACCESS_WRITE_5;
            end
            ACCESS_WRITE_5: begin

                enable_cntrl = flop_en;
                
                write_cntrl = 1'b1;
                valid_in_cntrl = 1'b1;

                tag_cntrl = addr[15:11];
                idx_cntrl = addr[10:3];
                offset_cntrl = 3'b100;

                data_in_cntrl = (wr & (addr[2:0] === 3'b100)) ? data_in : data_out_mem;
                data_out_cntrl = (rd & (addr[2:0] === 3'b100)) ? data_out_mem : data_temp;
                nxt_state = ACCESS_WRITE_6;
            end
            ACCESS_WRITE_6: begin
                victim_cntrl = ~flop_victim_cntrl;
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
                nxt_state = IDLE; // IDLE?
            end
            // DONE: begin

            //     Done = 1'b1;
            //     CacheHit = hit_ff_q;
            //     nxt_state = IDLE;
            // end
        endcase
    end
endmodule