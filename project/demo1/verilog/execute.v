/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (SLBIsel, incPC, immSrc, imm8, imm11, brchSig, Cin, inA, inB, invA, invB, aluOp, aluJmp, jalSel, aluFinal, newPC, sOpSel, aluOut, addPC, aluPC);

   input wire SLBIsel;
   input wire [15:0] incPC;
   input wire immSrc;
   input wire [15:0] imm8;
   input wire [15:0] imm11;
   input wire [2:0] brchSig;
   input wire Cin;
   input wire [15:0] inA;
   input wire [15:0] inB;
   input wire invA;
   input wire invB;
   input wire [3:0] aluOp;
   input wire aluJmp;
   input wire jalSel;
   input wire sOpSel;
   input wire aluPC;

   output wire [15:0] aluFinal;
   output wire [15:0] newPC;
   output wire [15:0] addPC;
   output wire [15:0] aluOut;

   wire zeroFlag;
   wire oflFlag;
   wire carryOut;
   wire signFlag;
   wire jmpSel;
   wire [15:0] pcOrSLBI;
   wire [15:0] imm8Or11;
   wire [15:0] compPC;
   wire [15:0] jmpPC;
   wire [15:0] possPC;
   
   always @(invA) begin
      $display("invA in execute:  %b", invA);
   end 

   // ALU
   alu aluExec(.InA(inA), .InB(inB), .Cin(Cin), .Oper(aluOp), .invA(invA), .invB(invB), .sign(1'b1), .Out(aluOut), .Zero(zeroFlag), .Ofl(oflFlag), .Cout(carryOut), .signFlag(signFlag));

   // Branch conditional module
   branch_conditional branchCond(.brchSig(brchSig), .sf(signFlag), .zf(zeroFlag), .of(oflFlag), .cf(carryOut), .jmpSel(jmpSel));

   assign pcOrSLBI = (aluPC) ? aluOut : incPC;
   assign imm8Or11 = (immSrc) ? imm11 : imm8;

   assign aluFinal = (sOpSel) ? {15'b0, jmpSel} : aluOut;

   // PC add module 
   cla_16b pcImmAdd(.sum(compPC), .c_out(), .ofl(), .a(pcOrSLBI), .b(imm8Or11), .c_in(1'b0), .sign(1'b0));
   
   // 2:1 muxes to control PC and register wb values
   assign jmpPC = (jmpSel) ? compPC : incPC;
   assign addPC = (jalSel) ? incPC : jmpPC;

   assign possPC = (aluJmp) ? aluOut : jmpPC;
   assign newPC = (SLBIsel) ? incPC : possPC;

endmodule
`default_nettype wire
