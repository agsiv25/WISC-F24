/*
   CS/ECE 552 Spring '22
  
   Filename        : hazard_det.v
   Description     : This is the module that detects data hazards and stalls the processor if one is detected.
*/
`default_nettype none
module hazard_det (rst, clk, fetch_inst, next_inst, pcNop, regWrtD, regWrtX, regWrtM, regWrtW, wrtRegD, wrtRegX, wrtRegM, wrtRegW);

input wire rst;
input wire clk;
input wire [15:0] fetch_inst;

output reg [15:0] next_inst;
output reg pcNop;

input wire regWrtD;
input wire regWrtX;
input wire regWrtM;
input wire regWrtW;

input wire wrtRegD;
input wire wrtRegX;
input wire wrtRegM;
input wire wrtRegW;

parameter NOP = {5'b00001, 11'b0} ;

wire rsHazard;  // rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM) || ((fetch_inst[10:8] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0;
wire rdHazard;  // rdHazard = (((fetch_inst[7:5] == wrtRegD) && regWrtD) || ((fetch_inst[7:5] == wrtRegX) && regWrtX) || ((fetch_inst[7:5] == wrtRegM) && regWrtM) || ((fetch_inst[7:5] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0; 
wire rtHazard;  // 

// Data hazards
always @(*) begin

    next_inst = NOP;

    casex(fetch_inst[15:11])

        // RAW hazards:

        // ST: 10000 RS + RD
        5'b1_0000: begin  
            rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM) || ((fetch_inst[10:8] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0;
            rdHazard = (((fetch_inst[7:5] == wrtRegD) && regWrtD) || ((fetch_inst[7:5] == wrtRegX) && regWrtX) || ((fetch_inst[7:5] == wrtRegM) && regWrtM) || ((fetch_inst[7:5] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0; 
 
            next_inst = (rsHazard || rdHazard) ? NOP : fetch_inst;

            pcNop = (rsHazard || rdHazard) ? 1'b1 : 1'b0; 
        end
        // STU: 10011 RS + RD
        5'b1_0011: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM) || ((fetch_inst[10:8] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0;
            rdHazard = (((fetch_inst[7:5] == wrtRegD) && regWrtD) || ((fetch_inst[7:5] == wrtRegX) && regWrtX) || ((fetch_inst[7:5] == wrtRegM) && regWrtM) || ((fetch_inst[7:5] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0; 
 
            next_inst = (rsHazard || rdHazard) ? NOP : fetch_inst;

            pcNop = (rsHazard || rdHazard) ? 1'b1 : 1'b0; 
        end
        // arithmetic: 11011 RS + RT
        5'b1_1011: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM) || ((fetch_inst[10:8] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0;
            rtHazard = (((fetch_inst[7:5] == wrtRegD) && regWrtD) || ((fetch_inst[7:5] == wrtRegX) && regWrtX) || ((fetch_inst[7:5] == wrtRegM) && regWrtM) || ((fetch_inst[7:5] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0; 
 
            next_inst = (rsHazard || rtHazard) ? NOP : fetch_inst;

            pcNop = (rsHazard || rtHazard) ? 1'b1 : 1'b0; 
        end
        // bit operations: 11010 RS + RT
        5'b1_1010: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM) || ((fetch_inst[10:8] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0;
            rtHazard = (((fetch_inst[7:5] == wrtRegD) && regWrtD) || ((fetch_inst[7:5] == wrtRegX) && regWrtX) || ((fetch_inst[7:5] == wrtRegM) && regWrtM) || ((fetch_inst[7:5] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0; 
 
            next_inst = (rsHazard || rtHazard) ? NOP : fetch_inst;

            pcNop = (rsHazard || rtHazard) ? 1'b1 : 1'b0;
        end
        // Set 1/0: 111xx RS + RT
        5'b1_11xx: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM) || ((fetch_inst[10:8] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0;
            rtHazard = (((fetch_inst[7:5] == wrtRegD) && regWrtD) || ((fetch_inst[7:5] == wrtRegX) && regWrtX) || ((fetch_inst[7:5] == wrtRegM) && regWrtM) || ((fetch_inst[7:5] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0; 
 
            next_inst = (rsHazard || rtHazard) ? NOP : fetch_inst;

            pcNop = (rsHazard || rtHazard) ? 1'b1 : 1'b0;
        end
        // NOP / HALT / siic / RTI: 000xx Not reading from anything. 
        5'b0_00xx: begin
            next_inst = fetch_inst;
        end

        // control hazards
        

        // Only reads from RS and no control hazards
        default: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM) || ((fetch_inst[10:8] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0; 
            pcNop = rsHazard;

            next_inst = (rsHazard) ? NOP : fetch_inst;
        end
    endcase
end

endmodule
`default_nettype wire

