/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (newPC, createDump, rst, clk, incPC, instruction, err, regWrtD, regWrtX, regWrtM, regWrtW, wrtRegD, wrtRegX, wrtRegM, wrtRegW, branchInstD, branchInstX, branchInstM, branchInstW, instrValid, fwCntrlA, fwCntrlB, wbDataSelD, wbDataSelX, alignErrI, alignErr_ff, Stall, Stall_i);

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

input wire branchInstD;
input wire branchInstX;
input wire branchInstM;
input wire branchInstW;

wire [15:0]pcRegAddr; 
wire pcIncErr;
wire pcRegErr;

//align
output wire alignErrI;
input wire alignErr_ff;

//stall mem
wire CacheHit;
wire Done;
input wire Stall;
output wire Stall_i;

// wires for hazard detection
wire [15:0] instruction2;
wire pcNop;

wire [15:0]pcIfBranch;

assign instrValid = 1'b1;

cla_16b pc_inc(.sum(incPC), .c_out(), .ofl(pcIncErr), .a(pcRegAddr), .b(16'h2), .c_in(1'b0), .sign(1'b0));

assign pcIfBranch = (branchInstW) ? newPC : incPC;

reg16 PC(.readData(pcRegAddr), .err(pcRegErr), .clk(clk), .rst(rst), .writeData(pcIfBranch), .writeEn((~createDump & ~(pcNop & ~branchInstW)) & ~Stall));

// assign error signal to be an OR between the PC adder and the PC register
assign err = pcRegErr | pcIncErr;

//assign Stall = 1'b0; //TODO: implement stall signal
//memory2c_align instruction_memory(.data_out(instruction2), .data_in(16'b0), .addr(pcRegAddr), .enable(1'b1), .wr(1'b0), .createdump(createDump | alignErr_ff), .clk(clk), .rst(rst), .err(alignErrI));
// stallmem instruction_memory(.DataOut(instruction2), .DataIn(16'b0), .Addr(pcRegAddr), .Done(Done), .Wr(1'b0), .Rd(1'b1), .createdump(createDump | alignErr_ff), .clk(clk), .rst(rst), .err(alignErrI), .Stall(Stall_i), .CacheHit(CacheHit));
mem_system_hier #(1'b0) instruction_memory(.DataOut(instruction2), .DataIn(16'b0), .Addr(pcRegAddr), .Done(Done), .Wr(1'b0), .Rd(1'b1), .createdump(createDump | alignErr_ff), .clk(clk), .rst(rst), .err(alignErrI), .Stall(Stall_i), .CacheHit(CacheHit));

hazard_det hazard(.rst(rst), .clk(clk), .fetch_inst(instruction2), .next_inst(instruction), .pcNop(pcNop), .regWrtD(regWrtD), .regWrtX(regWrtX), .regWrtM(regWrtM), .regWrtW(regWrtW), .wrtRegD(wrtRegD), .wrtRegX(wrtRegX), .wrtRegM(wrtRegM), .wrtRegW(wrtRegW), .branchInstD(branchInstD), .branchInstX(branchInstX), .branchInstM(branchInstM), .branchInstW(branchInstW), .fwCntrlA(fwCntrlA), .fwCntrlB(fwCntrlB), .wbDataSelD(wbDataSelD), .wbDataSelX(wbDataSelX));

endmodule
`default_nettype wire
