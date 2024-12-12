/*
   CS/ECE 552 Spring '22
  
   Filename        : hazard_det.v
   Description     : This is the module that detects data hazards and stalls the processor if one is detected.
*/
`default_nettype none
module hazard_det (rst, clk, fetch_inst, next_inst, pcNop, regWrtD, regWrtX, regWrtM, regWrtW, wrtRegD, wrtRegX, wrtRegM, wrtRegW, branchInstD, branchInstX, branchInstM, branchInstW, fwCntrlA, fwCntrlB, wbDataSelD, wbDataSelX);

input wire rst;
input wire clk;
input wire [15:0] fetch_inst;

output reg [15:0] next_inst;
output reg pcNop;

// forwarding
input wire [1:0] wbDataSelD, wbDataSelX;
output reg [4:0] fwCntrlA;
output reg [4:0] fwCntrlB;

input wire regWrtD;
input wire regWrtX;
input wire regWrtM;
input wire regWrtW;

input wire [2:0] wrtRegD;
input wire [2:0] wrtRegX;
input wire [2:0] wrtRegM;
input wire [2:0] wrtRegW;

input wire branchInstD;
input wire branchInstX;
input wire branchInstM;
input wire branchInstW;

parameter NOP = {5'b00001, 11'b0} ;

reg rsHazard;  // rsHazard = (((fetch_inst[10:8] == wrtRegD) & regWrtD) | ((fetch_inst[10:8] == wrtRegX) & regWrtX) | ((fetch_inst[10:8] == wrtRegM) & regWrtM) | ((fetch_inst[10:8] == wrtRegW) & regWrtW)) ? 1'b1 : 1'b0;
reg rdHazard;  // rdHazard = (((fetch_inst[7:5] == wrtRegD) & regWrtD) | ((fetch_inst[7:5] == wrtRegX) & regWrtX) | ((fetch_inst[7:5] == wrtRegM) & regWrtM) | ((fetch_inst[7:5] == wrtRegW) & regWrtW)) ? 1'b1 : 1'b0; 
reg rtHazard;  // 

reg controlHazard;

reg [4:0] fwTempA;
reg [4:0] fwTempB;

// Data hazards
always @(*) begin

    next_inst = 16'b0000100000000000;
    controlHazard = 1'b0;
    rsHazard = 1'b0;
    rdHazard = 1'b0;
    rtHazard = 1'b0;
    fwCntrlA = 5'b0;
    fwCntrlB = 5'b0;
    fwTempA = 5'b0;
    fwTempB = 5'b0;

    // forwarding control word passed in: 5'bXXXXX. fwCntrlX[4] is fwStuSel. fwCntrlX[3] is forward at all? y/n. fwCntrlX[2] is 0 for EX to EX forwarding,
    // otherwise 1 for MEM to EX forwarding. fwCntrlX[1:0] are used to determine forwarding data source. 2'b00 for SLBI, 2'b10 = ALU, 2'b11 = imm8, 
    // add 2'b01 = memory. 

    casex(fetch_inst[15:11])

        // RAW hazards:

        // ST: 10000 RS + RD
        5'b1_0000: begin  

            // is ST instruction, so set stuSel bit
            fwTempA[4] = 1'b1;
            fwTempB[4] = 1'b1;

            // write hazard in WB stage, also memory load in previous instruction into register being read from. 
            // Cannot x2x data forward, must wait until m2x is possible. 
            rsHazard = (((fetch_inst[10:8] == wrtRegM) & regWrtM & ~((fetch_inst[10:8] == wrtRegX) & regWrtX)) | ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01)) ? 1'b1 : 1'b0;
            rdHazard = (((fetch_inst[7:5] == wrtRegM) & regWrtM & ~((fetch_inst[7:5] == wrtRegX) & regWrtX)) | ((fetch_inst[7:5] == wrtRegD & regWrtD) & wbDataSelD == 2'b01)) ? 1'b1 : 1'b0; 
 
            // rsHazard = ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01) ? 1'b1 : 1'b0;
            // rdHazard = ((fetch_inst[7:5] == wrtRegD & regWrtD) & wbDataSelD == 2'b01) ? 1'b1 : 1'b0; 

            // forwarding possible?
            fwTempA[3] = ((fetch_inst[10:8] == wrtRegD) & regWrtD) | ((fetch_inst[10:8] == wrtRegX) & regWrtX) & ~((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01);
            fwTempB[3] = ((fetch_inst[7:5] == wrtRegD) & regWrtD) | ((fetch_inst[7:5] == wrtRegX) & regWrtX) & ~((fetch_inst[7:5] == wrtRegD & regWrtD) & wbDataSelD == 2'b01);

            // EX to EX forwarding or MEM to EX forwarding possible?
            fwTempA[2] = ~((fetch_inst[10:8] == wrtRegD) & regWrtD);
            fwTempB[2] = ~((fetch_inst[7:5] == wrtRegD) & regWrtD);

            // source of forwarding data? 
            fwTempA[1:0] = ((wbDataSelD == 2'b10 & ~fwCntrlA[2]) | (wbDataSelX == 2'b10 & fwCntrlA[2])) ? 2'b10 : (((wbDataSelD == 2'b11 & ~fwCntrlA[2]) | (wbDataSelX == 2'b11 & fwCntrlA[2])) ? 2'b11 : (((wbDataSelD == 2'b00 & ~fwCntrlA[2]) | (wbDataSelX == 2'b00 & fwCntrlA[2])) ? 2'b00 : 2'b01)); // might need to use SLBISel instead of wbDataSel?
            fwTempB[1:0] = ((wbDataSelD == 2'b10 & ~fwCntrlB[2]) | (wbDataSelX == 2'b10 & fwCntrlB[2])) ? 2'b10 : (((wbDataSelD == 2'b11 & ~fwCntrlB[2]) | (wbDataSelX == 2'b11 & fwCntrlB[2])) ? 2'b11 : (((wbDataSelD == 2'b00 & ~fwCntrlB[2]) | (wbDataSelX == 2'b00 & fwCntrlB[2])) ? 2'b00 : 2'b01)); // might need to use SLBISel instead of wbDataSel?

            pcNop = (rsHazard | rdHazard | branchInstD | branchInstX | branchInstM | branchInstW) ? 1'b1 : 1'b0; 

            next_inst = (pcNop | rst) ? NOP : fetch_inst;

            fwCntrlA = pcNop ? 5'b0 : fwTempA;
            fwCntrlB = pcNop ? 5'b0 : fwTempB;

        end
        // STU: 10011 RS + RD
        5'b1_0011: begin
            // is STU instruction, so set stuSel bit
            fwTempA[4] = 1'b1;
            fwTempB[4] = 1'b1;

            // write hazard in WB stage, also memory load in previous instruction into register being read from. 
            // Cannot x2x data forward, must wait until m2x is possible. 
            rsHazard = (((fetch_inst[10:8] == wrtRegM) & regWrtM & ~((fetch_inst[10:8] == wrtRegX) & regWrtX)) | ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01)) ? 1'b1 : 1'b0;
            rdHazard = (((fetch_inst[7:5] == wrtRegM) & regWrtM & ~((fetch_inst[7:5] == wrtRegX) & regWrtX)) | ((fetch_inst[7:5] == wrtRegD & regWrtD) & wbDataSelD == 2'b01)) ? 1'b1 : 1'b0; 
 
            // rsHazard = ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01) ? 1'b1 : 1'b0;
            // rdHazard = ((fetch_inst[7:5] == wrtRegD & regWrtD) & wbDataSelD == 2'b01) ? 1'b1 : 1'b0; 

            // forwarding possible?
            fwTempA[3] = ((fetch_inst[10:8] == wrtRegD) & regWrtD) | ((fetch_inst[10:8] == wrtRegX) & regWrtX) & ~((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01);
            fwTempB[3] = ((fetch_inst[7:5] == wrtRegD) & regWrtD) | ((fetch_inst[7:5] == wrtRegX) & regWrtX) & ~((fetch_inst[7:5] == wrtRegD & regWrtD) & wbDataSelD == 2'b01);

            // EX to EX forwarding or MEM to EX forwarding possible?
            fwTempA[2] = ~((fetch_inst[10:8] == wrtRegD) & regWrtD);
            fwTempB[2] = ~((fetch_inst[7:5] == wrtRegD) & regWrtD);

            // source of forwarding data? 
            fwTempA[1:0] = ((wbDataSelD == 2'b10 & ~fwCntrlA[2]) | (wbDataSelX == 2'b10 & fwCntrlA[2])) ? 2'b10 : (((wbDataSelD == 2'b11 & ~fwCntrlA[2]) | (wbDataSelX == 2'b11 & fwCntrlA[2])) ? 2'b11 : (((wbDataSelD == 2'b00 & ~fwCntrlA[2]) | (wbDataSelX == 2'b00 & fwCntrlA[2])) ? 2'b00 : 2'b01)); // might need to use SLBISel instead of wbDataSel?
            fwTempB[1:0] = ((wbDataSelD == 2'b10 & ~fwCntrlB[2]) | (wbDataSelX == 2'b10 & fwCntrlB[2])) ? 2'b10 : (((wbDataSelD == 2'b11 & ~fwCntrlB[2]) | (wbDataSelX == 2'b11 & fwCntrlB[2])) ? 2'b11 : (((wbDataSelD == 2'b00 & ~fwCntrlB[2]) | (wbDataSelX == 2'b00 & fwCntrlB[2])) ? 2'b00 : 2'b01)); // might need to use SLBISel instead of wbDataSel?

            pcNop = (rsHazard | rdHazard | branchInstD | branchInstX | branchInstM | branchInstW) ? 1'b1 : 1'b0; 

            next_inst = (pcNop | rst) ? NOP : fetch_inst;

            fwCntrlA = pcNop ? 5'b0 : fwTempA;
            fwCntrlB = pcNop ? 5'b0 : fwTempB;

        end
        // arithmetic: 11011 RS + RT
        5'b1_1011: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegM) & regWrtM & ~((fetch_inst[10:8] == wrtRegX) & regWrtX)) | ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01)) ? 1'b1 : 1'b0;
            rtHazard = (((fetch_inst[7:5] == wrtRegM) & regWrtM & ~((fetch_inst[7:5] == wrtRegX) & regWrtX)) | ((fetch_inst[7:5] == wrtRegD & regWrtD) & wbDataSelD == 2'b01)) ? 1'b1 : 1'b0; 
 
            // rsHazard = ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01) ? 1'b1 : 1'b0;
            // rtHazard = ((fetch_inst[7:5] == wrtRegD & regWrtD) & wbDataSelD == 2'b01) ? 1'b1 : 1'b0; 
 
            // forwarding possible?
            fwCntrlA[3] = ((fetch_inst[10:8] == wrtRegD) & regWrtD) | ((fetch_inst[10:8] == wrtRegX) & regWrtX) & ~((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01);
            fwCntrlB[3] = ((fetch_inst[7:5] == wrtRegD) & regWrtD) | ((fetch_inst[7:5] == wrtRegX) & regWrtX) & ~((fetch_inst[7:5] == wrtRegD & regWrtD) & wbDataSelD == 2'b01);

            // EX to EX forwarding or MEM to EX forwarding possible?
            fwCntrlA[2] = ~((fetch_inst[10:8] == wrtRegD) & regWrtD);
            fwCntrlB[2] = ~((fetch_inst[7:5] == wrtRegD) & regWrtD);

            // source of forwarding data? 
            fwCntrlA[1:0] = ((wbDataSelD == 2'b10 & ~fwCntrlA[2]) | (wbDataSelX == 2'b10 & fwCntrlA[2])) ? 2'b10 : (((wbDataSelD == 2'b11 & ~fwCntrlA[2]) | (wbDataSelX == 2'b11 & fwCntrlA[2])) ? 2'b11 : (((wbDataSelD == 2'b00 & ~fwCntrlA[2]) | (wbDataSelX == 2'b00 & fwCntrlA[2])) ? 2'b00 : 2'b01)); // might need to use SLBISel instead of wbDataSel?
            fwCntrlB[1:0] = ((wbDataSelD == 2'b10 & ~fwCntrlB[2]) | (wbDataSelX == 2'b10 & fwCntrlB[2])) ? 2'b10 : (((wbDataSelD == 2'b11 & ~fwCntrlB[2]) | (wbDataSelX == 2'b11 & fwCntrlB[2])) ? 2'b11 : (((wbDataSelD == 2'b00 & ~fwCntrlB[2]) | (wbDataSelX == 2'b00 & fwCntrlB[2])) ? 2'b00 : 2'b01)); // might need to use SLBISel instead of wbDataSel?

            pcNop = (rsHazard | rtHazard | branchInstD | branchInstX | branchInstM | branchInstW) ? 1'b1 : 1'b0; 

            next_inst = (pcNop | rst) ? NOP : fetch_inst;
        end
        // bit operations: 11010 RS + RT
        5'b1_1010: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegM) & regWrtM & ~((fetch_inst[10:8] == wrtRegX) & regWrtX)) | ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01)) ? 1'b1 : 1'b0;
            rtHazard = (((fetch_inst[7:5] == wrtRegM) & regWrtM & ~((fetch_inst[7:5] == wrtRegX) & regWrtX)) | ((fetch_inst[7:5] == wrtRegD & regWrtD) & wbDataSelD == 2'b01)) ? 1'b1 : 1'b0; 
 
            // rsHazard = ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01) ? 1'b1 : 1'b0;
            // rtHazard = ((fetch_inst[7:5] == wrtRegD & regWrtD) & wbDataSelD == 2'b01) ? 1'b1 : 1'b0; 
 
            // forwarding possible?
            fwCntrlA[3] = ((fetch_inst[10:8] == wrtRegD) & regWrtD) | ((fetch_inst[10:8] == wrtRegX) & regWrtX) & ~((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01);
            fwCntrlB[3] = ((fetch_inst[7:5] == wrtRegD) & regWrtD) | ((fetch_inst[7:5] == wrtRegX) & regWrtX) & ~((fetch_inst[7:5] == wrtRegD & regWrtD) & wbDataSelD == 2'b01);

            // EX to EX forwarding or MEM to EX forwarding possible?
            fwCntrlA[2] = ~((fetch_inst[10:8] == wrtRegD) & regWrtD);
            fwCntrlB[2] = ~((fetch_inst[7:5] == wrtRegD) & regWrtD);

            // source of forwarding data? 
            fwCntrlA[1:0] = ((wbDataSelD == 2'b10 & ~fwCntrlA[2]) | (wbDataSelX == 2'b10 & fwCntrlA[2])) ? 2'b10 : (((wbDataSelD == 2'b11 & ~fwCntrlA[2]) | (wbDataSelX == 2'b11 & fwCntrlA[2])) ? 2'b11 : (((wbDataSelD == 2'b00 & ~fwCntrlA[2]) | (wbDataSelX == 2'b00 & fwCntrlA[2])) ? 2'b00 : 2'b01)); // might need to use SLBISel instead of wbDataSel?
            fwCntrlB[1:0] = ((wbDataSelD == 2'b10 & ~fwCntrlB[2]) | (wbDataSelX == 2'b10 & fwCntrlB[2])) ? 2'b10 : (((wbDataSelD == 2'b11 & ~fwCntrlB[2]) | (wbDataSelX == 2'b11 & fwCntrlB[2])) ? 2'b11 : (((wbDataSelD == 2'b00 & ~fwCntrlB[2]) | (wbDataSelX == 2'b00 & fwCntrlB[2])) ? 2'b00 : 2'b01)); // might need to use SLBISel instead of wbDataSel?

            pcNop = (rsHazard | rtHazard | branchInstD | branchInstX | branchInstM | branchInstW) ? 1'b1 : 1'b0;

            next_inst = (pcNop | rst) ? NOP : fetch_inst;
        end
        // Set 1/0: 111xx RS + RT
        5'b1_11xx: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegM) & regWrtM & ~((fetch_inst[10:8] == wrtRegX) & regWrtX)) | ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01)) ? 1'b1 : 1'b0;
            rtHazard = (((fetch_inst[7:5] == wrtRegM) & regWrtM & ~((fetch_inst[7:5] == wrtRegX) & regWrtX)) | ((fetch_inst[7:5] == wrtRegD & regWrtD) & wbDataSelD == 2'b01)) ? 1'b1 : 1'b0; 
 
            // rsHazard = ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01) ? 1'b1 : 1'b0;
            // rtHazard = ((fetch_inst[7:5] == wrtRegD & regWrtD) & wbDataSelD == 2'b01) ? 1'b1 : 1'b0; 
 
            // forwarding possible?
            fwCntrlA[3] = ((fetch_inst[10:8] == wrtRegD) & regWrtD) | ((fetch_inst[10:8] == wrtRegX) & regWrtX) & ~((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01);
            fwCntrlB[3] = ((fetch_inst[7:5] == wrtRegD) & regWrtD) | ((fetch_inst[7:5] == wrtRegX) & regWrtX) & ~((fetch_inst[7:5] == wrtRegD & regWrtD) & wbDataSelD == 2'b01);

            // EX to EX forwarding or MEM to EX forwarding possible?
            fwCntrlA[2] = ~((fetch_inst[10:8] == wrtRegD) & regWrtD);
            fwCntrlB[2] = ~((fetch_inst[7:5] == wrtRegD) & regWrtD);

            // source of forwarding data? 
            fwCntrlA[1:0] = ((wbDataSelD == 2'b10 & ~fwCntrlA[2]) | (wbDataSelX == 2'b10 & fwCntrlA[2])) ? 2'b10 : (((wbDataSelD == 2'b11 & ~fwCntrlA[2]) | (wbDataSelX == 2'b11 & fwCntrlA[2])) ? 2'b11 : (((wbDataSelD == 2'b00 & ~fwCntrlA[2]) | (wbDataSelX == 2'b00 & fwCntrlA[2])) ? 2'b00 : 2'b01)); // might need to use SLBISel instead of wbDataSel?
            fwCntrlB[1:0] = ((wbDataSelD == 2'b10 & ~fwCntrlB[2]) | (wbDataSelX == 2'b10 & fwCntrlB[2])) ? 2'b10 : (((wbDataSelD == 2'b11 & ~fwCntrlB[2]) | (wbDataSelX == 2'b11 & fwCntrlB[2])) ? 2'b11 : (((wbDataSelD == 2'b00 & ~fwCntrlB[2]) | (wbDataSelX == 2'b00 & fwCntrlB[2])) ? 2'b00 : 2'b01)); // might need to use SLBISel instead of wbDataSel?

            pcNop = (rsHazard | rtHazard | branchInstD | branchInstX | branchInstM | branchInstW) ? 1'b1 : 1'b0;

            next_inst = (pcNop | rst) ? NOP : fetch_inst;
        end

        // LBI: 11000
        5'b1_1000: begin
            pcNop = (branchInstD | branchInstX | branchInstM | branchInstW) ? 1'b1 : 1'b0;
            next_inst = (pcNop | rst) ? NOP : fetch_inst;
        end
        // halt stall
        5'b0_0000: begin
            pcNop = (branchInstD | branchInstX | branchInstM | branchInstW) ? 1'b1 : 1'b0;
            next_inst = (pcNop | rst) ? NOP : fetch_inst;
        end
        // NOP 000xx Not reading from anything. 
        5'b0_0001: begin
            pcNop = (branchInstD | branchInstX | branchInstM | branchInstW) ? 1'b1 : 1'b0;
            next_inst = (pcNop | rst) ? NOP : fetch_inst;
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

        //     rsHazard = (((fetch_inst[10:8] == wrtRegD) & regWrtD) | ((fetch_inst[10:8] == wrtRegX) & regWrtX) | ((fetch_inst[10:8] == wrtRegM) & regWrtM) | ((fetch_inst[10:8] == wrtRegW) & regWrtW)) ? 1'b1 : 1'b0; 
        //     pcNop = rsHazard | branchInstD | branchInstX | branchInstF;

        //     next_inst = (pcNop | rst) ? NOP : fetch_inst;
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

        //     rsHazard = (((fetch_inst[10:8] == wrtRegD) & regWrtD) | ((fetch_inst[10:8] == wrtRegX) & regWrtX) | ((fetch_inst[10:8] == wrtRegM) & regWrtM) | ((fetch_inst[10:8] == wrtRegW) & regWrtW)) ? 1'b1 : 1'b0; 
        //     pcNop = rsHazard | branchInstD | branchInstX | branchInstF;

        //     next_inst = (pcNop | rst) ? NOP : fetch_inst;
        // end
        // Branches: 011xx Rs + control 
        5'b0_11xx: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegM) & regWrtM & ~((fetch_inst[10:8] == wrtRegX) & regWrtX)) | ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01)) ? 1'b1 : 1'b0;
 
            // rsHazard = ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01) ? 1'b1 : 1'b0;
            
            // forwarding possible?
            fwCntrlA[3] = ((fetch_inst[10:8] == wrtRegD) & regWrtD) | ((fetch_inst[10:8] == wrtRegX) & regWrtX) & ~((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01);

            // EX to EX forwarding or MEM to EX forwarding possible?
            fwCntrlA[2] = ~((fetch_inst[10:8] == wrtRegD) & regWrtD);

            // source of forwarding data? 
            fwCntrlA[1:0] = ((wbDataSelD == 2'b10 & ~fwCntrlA[2]) | (wbDataSelX == 2'b10 & fwCntrlA[2])) ? 2'b10 : (((wbDataSelD == 2'b11 & ~fwCntrlA[2]) | (wbDataSelX == 2'b11 & fwCntrlA[2])) ? 2'b11 : (((wbDataSelD == 2'b00 & ~fwCntrlA[2]) | (wbDataSelX == 2'b00 & fwCntrlA[2])) ? 2'b00 : 2'b01)); // might need to use SLBISel instead of wbDataSel?
            
            pcNop = rsHazard | branchInstD | branchInstX | branchInstM | branchInstW;

            next_inst = (pcNop | rst) ? NOP : fetch_inst;
        end

        // JALR and JR commands: 00101 and 00111: control and rs hazard
        5'b0_01x1: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegM) & regWrtM & ~((fetch_inst[10:8] == wrtRegX) & regWrtX)) | ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01)) ? 1'b1 : 1'b0;
 
            // rsHazard = ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01) ? 1'b1 : 1'b0;

            // forwarding possible?
            fwCntrlA[3] = ((fetch_inst[10:8] == wrtRegD) & regWrtD) | ((fetch_inst[10:8] == wrtRegX) & regWrtX) & ~((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01);

            // EX to EX forwarding or MEM to EX forwarding possible?
            fwCntrlA[2] = ~((fetch_inst[10:8] == wrtRegD) & regWrtD);

            // source of forwarding data? 
            fwCntrlA[1:0] = ((wbDataSelD == 2'b10 & ~fwCntrlA[2]) | (wbDataSelX == 2'b10 & fwCntrlA[2])) ? 2'b10 : (((wbDataSelD == 2'b11 & ~fwCntrlA[2]) | (wbDataSelX == 2'b11 & fwCntrlA[2])) ? 2'b11 : (((wbDataSelD == 2'b00 & ~fwCntrlA[2]) | (wbDataSelX == 2'b00 & fwCntrlA[2])) ? 2'b00 : 2'b01)); // might need to use SLBISel instead of wbDataSel?

            pcNop = rsHazard | branchInstD | branchInstX | branchInstM | branchInstW;
            next_inst = (pcNop | rst) ? NOP : fetch_inst;
        end

        // J and JAL commands: 00100 and 00110: pure control hazard
        5'b0_01x0: begin

            pcNop = branchInstD | branchInstX | branchInstM | branchInstW;
            next_inst = (pcNop | rst) ? NOP : fetch_inst;
        end

        // Only reads from RS and no control hazards
        default: begin
            rsHazard = (((fetch_inst[10:8] == wrtRegM) & regWrtM & ~((fetch_inst[10:8] == wrtRegX) & regWrtX)) | ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01)) ? 1'b1 : 1'b0;
 
            // rsHazard = ((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01) ? 1'b1 : 1'b0;
            
            // forwarding possible?
            fwCntrlA[3] = ((fetch_inst[10:8] == wrtRegD) & regWrtD) | ((fetch_inst[10:8] == wrtRegX) & regWrtX) & ~((fetch_inst[10:8] == wrtRegD & regWrtD) & wbDataSelD == 2'b01);

            // EX to EX forwarding or MEM to EX forwarding possible?
            fwCntrlA[2] = ~((fetch_inst[10:8] == wrtRegD) & regWrtD);

            // source of forwarding data? 
            fwCntrlA[1:0] = ((wbDataSelD == 2'b10 & ~fwCntrlA[2]) | (wbDataSelX == 2'b10 & fwCntrlA[2])) ? 2'b10 : (((wbDataSelD == 2'b11 & ~fwCntrlA[2]) | (wbDataSelX == 2'b11 & fwCntrlA[2])) ? 2'b11 : (((wbDataSelD == 2'b00 & ~fwCntrlA[2]) | (wbDataSelX == 2'b00 & fwCntrlA[2])) ? 2'b00 : 2'b01)); // might need to use SLBISel instead of wbDataSel?
            
            pcNop = rsHazard | branchInstD | branchInstX | branchInstM | branchInstW;

            next_inst = (pcNop | rst) ? NOP : fetch_inst;
        end
    endcase
end

endmodule
`default_nettype wire

