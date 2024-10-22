/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (instruction, wbData, clk, rst, imm8, imm11, ALUjmp, SLBIsel, createDump, memWrt, brchSig, Cin, invA, invB, wbDataSel, immSrc, aluOp, inA, inB, wrtData, err);

input [15:0] instruction;
input [15:0] wbData;
input clk;
input rst;

// immediate outputs
output [15:0] imm8;
output [15:0] imm11;

// from instruction decoder 
output ALUjmp;
output SLBIsel;
output createDump;
output memWrt;           // memory write or read signal 
output [1:0] brchSig;
output Cin;
output invA;             // invert ALU input A
output invB;             // invert ALU input B
output [1:0] wbDataSel;           // choose source of writeback data 
output immSrc;                    // used to choose which immediate to add to PC
output aluOp;                     // signal to ALU to choose operation

// from register file / reg mux 
output [15:0] inA;
output [15:0] inB;

output [15:0] wrtData;
output err;

wire zeroSel;            // choose zero or sign extended immediates 
wire [15:0] imm5;
wire [1:0] regDestSel;   // sel signal to register write mux 
wire [2:0] wrtReg;       // register to write to in register file
wire regWrt;           // register file write enable
wire [15:0] regB;
wire [1:0] BSrc;          // select signal for inB mux
wire stuSel;              // for STU instruction, choose memory write data source

// 4:1 mux for register write select
assign wrtReg = (regDestSel == 2'b0) ? instruction[10:8] : (regDestSel == 2'b01) ? instruction[7:5] : (regDestSel == 2'b10) ? instruction[4:2] : 3'b111;

// 2:1 muxes for 5 and 8 bit immediates 
assign imm5 = (zeroSel) ? {11'b0 , instruction[4:0]} : {{11 {instruction[4]}} , instruction[4:0]};
assign imm8 = (zeroSel) ? {8'b0 , instruction[7:0]} : {{8 {instruction[7]}} , instruction[7:0]};

// sign extend 11 bit immediate 
assign imm11 = {{5 {instruction[10]}} , instruction[10:0]}

// module to decode instructions to ALU operations   ~~~~~~~~~~~~~~~~~~HAVE TO IMPLEMENT~~~~~~~~~~~~~~~~~~~~
alu_op_decode ALU_OP(.instruction(instruction[15:0]), .aluOp(aluOp));

// 2:1 mux to choose between inB and regB for STU instruction
assign wrtData = (stuSel) ? regB : inB;

// Register file with bypass
regFile_bypass register_file(.read1Data(inA), .read2Data(regB), .err(err), .clk(clk), .rst(rst), .read1RegSel(instruction[10:8]), .read2RegSel(instruction[7:5]), .writeRegSel(wrtReg), .writeData(wbData), .writeEn(regWrt));

// 4:1 mux for ALU B input 
assign inB = (BSrc == 2'b0) ? regB : (BSrc == 2'b01) ? imm5 : (BSrc == 2'b10) ? imm11 : 16'b0;

// instruction decoder. ~~~~~~~~~~~~~~~~~~HAVE TO IMPLEMENT~~~~~~~~~~~~~~~~~~~~
control_unit instruction_decoder(.instruction(instruction), .ALUjmp(ALUjmp), .memWrt(memWrt), .brchSig(brchSig), .Cin(Cin), .invA(invA), .invB(invB), .BSrc(BSrc), .regWrt(regWrt), .wbDataSel(wbDataSel), .stuSel(stuSel), .immSrc(immSrc), .SLBIsel(SLBIsel), .createDump(createDump), .BSrc(BSrc), .zeroSel(zeroSel), .regDestSel(regDestSel));
   
endmodule
`default_nettype wire
