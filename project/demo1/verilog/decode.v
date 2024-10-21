/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (/* TODO: Add appropriate inputs/outputs for your decode stage here*/);

   // TODO: Your code here

input [15:0]instruction;
input [15:0]wbData;
input clk;
input rst;

output SLBIsel;
output immSrc;
output createDump;

// immediate outputs
output [15:0] imm8;
output [15:0] imm11;

// from instruction decoder 
output ALUjump;
output memWrt;           // memory write or read signal 
output [1:0] brchSig;
output Cin;
output invA;             // invert ALU input A
output [1:0] BSrc;
output regWrt;
output invB;             // invert ALU input B
output [1:0] wbDataSel;           // choose source of writeback data 
output stuSel;              // for STU instruction, choose memory write data source

// from register file / reg mux 
output [15:0] inA;
output [15:0] inB;

output [15:0] wrtData;

wire zeroSel;            // choose zero or sign extended immediates 
wire [4:0] ALUop;        // instruction input to ALU operation module
wire [15:0] imm5;
wire [1:0] regDestSel;   // sel signal to register write mux 
wire [2:0] wrtReg;       // register to write to 
wire [15:0] regB;

// 4:1 mux for register write select
assign wrtReg = (regDestSel == 2'b0) ? instruction[10:8] : (regDestSel == 2'b01) ? instruction[7:5] : (regDestSel == 2'b10) ? instruction[4:2] : 3'b111;

// 2:1 muxes for 5 and 8 bit immediates 
assign imm5 = (zeroSel) ? {11'b0 , instruction[4:0]} : {{11 {instruction[4]}} , instruction[4:0]};
assign imm8 = (zeroSel) ? {8'b0 , instruction[7:0]} : {{8 {instruction[7]}} , instruction[7:0]};

// sign extend 11 bit immediate 
assign imm11 = {{5 {instruction[10]}} , instruction[10:0]}

// module to decode instructions to ALU operations
alu_op_decode ALU_OP(.ALUOpr(), .instructionALU(), .alu_op());

// 2:1 mux to choose between inB and regB for STU instruction
assign wrtData = (stuSel) ? regB : inB;

// FILL OUT
regFile_bypass register_file(.read1Data(), .read2Data(regB), .err(), .clk(clk), .rst(rst), .read1RegSel(), .read2RegSel(), .writeRegSel(), .writeData(), .writeEn());

// 4:1 mux for ALU B input 
assign inB = (BSrc == 2'b0) ? regB : (BSrc == 2'b01) ? imm5 : (BSrc == 2'b10) ? imm11 : 16'b0;

// instruction decoder. HAVE TO IMPLEMENT
control_unit ();
   
endmodule
`default_nettype wire
