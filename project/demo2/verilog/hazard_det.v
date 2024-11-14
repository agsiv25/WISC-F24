/*
   CS/ECE 552 Spring '22
  
   Filename        : hazard_det.v
   Description     : This is the module that detects data hazards and stalls the processor if one is detected.
*/
`default_nettype none
module hazard_det (rst, clk, fetch_inst, next_inst, pcNop, regWrtD, regWrtX, regWrtM, regWrtW, wrtRegD, wrtRegX, wrtRegM, wrtRegW, branchInstF, branchInstD, branchInstX, branchInstM, branchInstW);

input wire rst;
input wire clk;
input wire [15:0] fetch_inst;

output reg [15:0] next_inst;
output reg pcNop;

input wire regWrtD;
input wire regWrtX;
input wire regWrtM;
input wire regWrtW;

input wire [2:0] wrtRegD;
input wire [2:0] wrtRegX;
input wire [2:0] wrtRegM;
input wire [2:0] wrtRegW;

output reg branchInstF;

input wire branchInstD;
input wire branchInstX;
input wire branchInstM;
input wire branchInstW;

parameter NOP = {5'b00001, 11'b0} ;

reg rsHazard;  // rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM) || ((fetch_inst[10:8] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0;
reg rdHazard;  // rdHazard = (((fetch_inst[7:5] == wrtRegD) && regWrtD) || ((fetch_inst[7:5] == wrtRegX) && regWrtX) || ((fetch_inst[7:5] == wrtRegM) && regWrtM) || ((fetch_inst[7:5] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0; 
reg rtHazard;  // 

reg controlHazard;

// Data hazards
always @(*) begin

    next_inst = 16'b0000100000000000;
    branchInstF = 1'b0;
    controlHazard = 1'b0;
    rsHazard = 1'b0;
    rdHazard = 1'b0;
    rtHazard = 1'b0;

    casex(fetch_inst[15:11])

        // RAW hazards:

        // ST: 10000 RS + RD
        5'b1_0000: begin  
            rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM)) ? 1'b1 : 1'b0;
            rdHazard = (((fetch_inst[7:5] == wrtRegD) && regWrtD) || ((fetch_inst[7:5] == wrtRegX) && regWrtX) || ((fetch_inst[7:5] == wrtRegM) && regWrtM)) ? 1'b1 : 1'b0; 
 
            pcNop = (rsHazard || rdHazard || branchInstD || branchInstX || branchInstM || branchInstF) ? 1'b1 : 1'b0; 

            next_inst = (pcNop || rst) ? NOP : fetch_inst;
        end
        // STU: 10011 RS + RD
        5'b1_0011: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM)) ? 1'b1 : 1'b0;
            rdHazard = (((fetch_inst[7:5] == wrtRegD) && regWrtD) || ((fetch_inst[7:5] == wrtRegX) && regWrtX) || ((fetch_inst[7:5] == wrtRegM) && regWrtM)) ? 1'b1 : 1'b0; 
 
            pcNop = (rsHazard || rdHazard || branchInstD || branchInstX || branchInstM || branchInstF) ? 1'b1 : 1'b0; 

            next_inst = (pcNop || rst) ? NOP : fetch_inst;
        end
        // arithmetic: 11011 RS + RT
        5'b1_1011: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM)) ? 1'b1 : 1'b0;
            rtHazard = (((fetch_inst[7:5] == wrtRegD) && regWrtD) || ((fetch_inst[7:5] == wrtRegX) && regWrtX) || ((fetch_inst[7:5] == wrtRegM) && regWrtM)) ? 1'b1 : 1'b0; 
 
            pcNop = (rsHazard || rtHazard || branchInstD || branchInstX || branchInstM || branchInstF) ? 1'b1 : 1'b0; 

            next_inst = (pcNop || rst) ? NOP : fetch_inst;
        end
        // bit operations: 11010 RS + RT
        5'b1_1010: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM)) ? 1'b1 : 1'b0;
            rtHazard = (((fetch_inst[7:5] == wrtRegD) && regWrtD) || ((fetch_inst[7:5] == wrtRegX) && regWrtX) || ((fetch_inst[7:5] == wrtRegM) && regWrtM)) ? 1'b1 : 1'b0; 
 
            pcNop = (rsHazard || rtHazard || branchInstD || branchInstX || branchInstM || branchInstF) ? 1'b1 : 1'b0;

            next_inst = (pcNop || rst) ? NOP : fetch_inst;
        end
        // Set 1/0: 111xx RS + RT
        5'b1_11xx: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM)) ? 1'b1 : 1'b0;
            rtHazard = (((fetch_inst[7:5] == wrtRegD) && regWrtD) || ((fetch_inst[7:5] == wrtRegX) && regWrtX) || ((fetch_inst[7:5] == wrtRegM) && regWrtM)) ? 1'b1 : 1'b0; 
 
            pcNop = (rsHazard || rtHazard || branchInstD || branchInstX || branchInstM || branchInstF) ? 1'b1 : 1'b0;

            next_inst = (pcNop || rst) ? NOP : fetch_inst;
        end
        // halt stall
        5'b0_0000: begin
            pcNop = 1'b1;
            next_inst = fetch_inst;
        end
        // NOP 000xx Not reading from anything. 
        5'b0_0001: begin
            next_inst = fetch_inst;
        end

        // NOP / siic / RTI: 000xx Not reading from anything. 
        5'b0_0010: begin
            next_inst = fetch_inst;
        end

        // NOP / siic / RTI: 000xx Not reading from anything. 
        5'b0_0011: begin
            next_inst = fetch_inst;
        end

        // control hazards

        // // J displacement: 00100 pure control 
        // 5'b0_0100: begin
        //     branchInstF = 1'b1;
        //     pcNop = branchInstF;
        //     next_inst = fetch_inst;
        // end
        // // JR Rs, imm: 00101 Rs + control 
        // 5'b0_0101: begin
        //     branchInstF = 1'b1;

        //     rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM) || ((fetch_inst[10:8] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0; 
        //     pcNop = rsHazard || branchInstD || branchInstX || branchInstF;

        //     next_inst = (pcNop || rst) ? NOP : fetch_inst;
        // end
        // // JAL displacement: 00110 pure control
        // 5'b0_0110: begin
        //     branchInstF = 1'b1;    
        //     pcNop = branchInstF;        
        //     next_inst = fetch_inst;
        // end
        // // JALR Rs, imm: 00111 Rs + control 
        // 5'b0_0111: begin
        //     branchInstF = 1'b1;

        //     rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM) || ((fetch_inst[10:8] == wrtRegW) && regWrtW)) ? 1'b1 : 1'b0; 
        //     pcNop = rsHazard || branchInstD || branchInstX || branchInstF;

        //     next_inst = (pcNop || rst) ? NOP : fetch_inst;
        // end
        // Branches: 011xx Rs + control 
        5'b0_11xx: begin
            branchInstF = 1'b1;

            rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM)) ? 1'b1 : 1'b0; 
            pcNop = rsHazard;

            next_inst = (pcNop || rst) ? NOP : fetch_inst;
        end

        // Only reads from RS and no control hazards
        default: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegD) && regWrtD) || ((fetch_inst[10:8] == wrtRegX) && regWrtX) || ((fetch_inst[10:8] == wrtRegM) && regWrtM)) ? 1'b1 : 1'b0; 
            pcNop = rsHazard || branchInstD || branchInstX || branchInstM || branchInstF;

            next_inst = (pcNop || rst) ? NOP : fetch_inst;
        end
    endcase
end

endmodule
`default_nettype wire

