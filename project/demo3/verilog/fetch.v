/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (newPC, createDump, rst, clk, incPC, instruction, err, regWrtD, regWrtX, regWrtM, regWrtW, wrtRegD, wrtRegX, wrtRegM, wrtRegW, jumpInstD, jumpInstX, instrValid, fwCntrlA, fwCntrlB, wbDataSelD, wbDataSelX, branch_mispredictionX, branch_mispredictionM, istall);

input wire [15:0]newPC;
input wire createDump;
input wire rst;
input wire clk;

output wire [15:0]instruction;
output wire [15:0]incPC;
output wire err;
output wire instrValid;

// forwarding 
output wire [4:0] fwCntrlA, fwCntrlB;
input wire [1:0] wbDataSelD, wbDataSelX;

input wire regWrtD;
input wire regWrtX;
input wire regWrtM;
input wire regWrtW;

input wire [2:0] wrtRegD;
input wire [2:0] wrtRegX;
input wire [2:0] wrtRegM;
input wire [2:0] wrtRegW;

// control signals
input wire jumpInstD;
input wire jumpInstX;
input wire branch_mispredictionX;
input wire branch_mispredictionM;

wire [15:0]pcRegAddr; 
wire pcIncErr;
wire pcRegErr;

// wires for hazard detection
wire [15:0] instruction2;
wire [15:0] branchSafeInst;
wire pcNop;

// wire for i-cache
output wire istall;
wire done;
wire cacheHit;
wire icacheErr;
wire unaligned;

wire [15:0]pcIfBranch;

assign instrValid = 1'b1;

cla_16b pc_inc(.sum(incPC), .c_out(), .ofl(pcIncErr), .a(pcRegAddr), .b(16'h2), .c_in(1'b0), .sign(1'b0));

assign pcIfBranch = (jumpInstX | branch_mispredictionX) ? newPC : incPC;

// wire writeEn = (~createDump & ~pcNop & (~stall | (stall & cacheHit)) & (icacheErr === 1'b0) & ~branch_mispredictionM) | jumpInstX | branch_mispredictionX;
wire writeEn = (~createDump & ~pcNop & ~istall & (icacheErr === 1'b0)) | jumpInstX | branch_mispredictionX;

reg16 PC(.readData(pcRegAddr), .err(pcRegErr), .clk(clk), .rst(rst), .writeData(pcIfBranch), .writeEn(writeEn));

// assign error signal to be an OR between the PC adder and the PC register
assign err = pcRegErr | pcIncErr | unaligned;

// memory2c instruction_memory(.data_out(instruction2), .data_in(16'b0), .addr(pcRegAddr), .enable(1'b1), .wr(1'b0), .createdump(createDump), .clk(clk), .rst(rst));
   
// I-CACHE (mem_type param set to 0):
mem_system #(0) m0(/*AUTOINST*/
                      // Outputs
                      .DataOut          (instruction2),
                      .Done             (done),
                      .Stall            (istall_local),
                      .CacheHit         (cacheHit),
                      .err              (icacheErr),
                      // Inputs
                      .Addr             (pcRegAddr),
                      .DataIn           (16'b0),
                      .Rd               (1'b1),
                      .Wr               (1'b0),
                      .createdump       (createDump),
                      .clk              (clk),
                      .rst              (rst));

assign unaligned = (icacheErr === 1'b1);

// on branch misprediction, insert NOP to invalidate instruction   
// assign branchSafeInst = (unaligned) ? 16'h0000 : (branch_mispredictionX | branch_mispredictionM | (stall & ~cacheHit) | icacheErr === 1'bx) ? 16'h0800 : instruction2;
assign branchSafeInst = (unaligned) ? 16'h0000 : (branch_mispredictionX | istall | icacheErr === 1'bx) ? 16'h0800 : instruction2;

hazard_det hazard(.rst(rst), .clk(clk), .fetch_inst(branchSafeInst), .next_inst(instruction), .pcNop(pcNop), .regWrtD(regWrtD), .regWrtX(regWrtX), .regWrtM(regWrtM), .regWrtW(regWrtW), .wrtRegD(wrtRegD), .wrtRegX(wrtRegX), .wrtRegM(wrtRegM), .wrtRegW(wrtRegW), .fwCntrlA(fwCntrlA), .fwCntrlB(fwCntrlB), .wbDataSelD(wbDataSelD), .wbDataSelX(wbDataSelX), .jumpInstD(jumpInstD), .jumpInstX(jumpInstX));

endmodule
`default_nettype wire
