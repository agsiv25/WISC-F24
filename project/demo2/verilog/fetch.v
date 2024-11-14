/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (newPC, createDump, rst, clk, incPC, instruction, err, regWrtD, regWrtX, regWrtM, regWrtW, wrtRegD, wrtRegX, wrtRegM, wrtRegW, branchInstF, branchInstD, branchInstX, branchInstM, branchInstW, instrValid);

input wire [15:0]newPC;
input wire createDump;
input wire rst;
input wire clk;

output wire [15:0]instruction;
output wire [15:0]incPC;
output wire err;
output wire instrValid;

input wire regWrtD;
input wire regWrtX;
input wire regWrtM;
input wire regWrtW;

input wire [2:0] wrtRegD;
input wire [2:0] wrtRegX;
input wire [2:0] wrtRegM;
input wire [2:0] wrtRegW;

output wire branchInstF;

input wire branchInstD;
input wire branchInstX;
input wire branchInstM;
input wire branchInstW;

wire [15:0]pcRegAddr; 
wire pcIncErr;
wire pcRegErr;

// wires for hazard detection
wire [15:0] instruction2;
wire pcNop;

wire [15:0]pcIfBranch;

assign instrValid = 1'b1;

cla_16b pc_inc(.sum(incPC), .c_out(), .ofl(pcIncErr), .a(pcRegAddr), .b(16'h2), .c_in(1'b0), .sign(1'b0));

assign pcIfBranch = (branchInstW) ? newPC : incPC;

reg16 PC(.readData(pcRegAddr), .err(pcRegErr), .clk(clk), .rst(rst), .writeData(pcIfBranch), .writeEn(~createDump & ~(pcNop & ~branchInstW)));



// assign error signal to be an OR between the PC adder and the PC register
assign err = pcRegErr | pcIncErr;

memory2c instruction_memory(.data_out(instruction2), .data_in(16'b0), .addr(pcRegAddr), .enable(1'b1), .wr(1'b0), .createdump(createDump), .clk(clk), .rst(rst));
   
hazard_det hazard(.rst(rst), .clk(clk), .fetch_inst(instruction2), .next_inst(instruction), .pcNop(pcNop), .regWrtD(regWrtD), .regWrtX(regWrtX), .regWrtM(regWrtM), .regWrtW(regWrtW), .wrtRegD(wrtRegD), .wrtRegX(wrtRegX), .wrtRegM(wrtRegM), .wrtRegW(wrtRegW), .branchInstF(branchInstF), .branchInstD(branchInstD), .branchInstX(branchInstX), .branchInstM(branchInstM), .branchInstW(branchInstW));
// always @(posedge clk) begin
//     $display("Fetch: incPC: %h newPC: %h pcIfBranch: %h PC to read: %h, Instruction: %h", incPC, newPC, pcIfBranch, pcRegAddr, instruction);
// end
endmodule
`default_nettype wire
