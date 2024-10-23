/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (SLBIsel, incPC, immSrc, imm8, imm11, brchSig, Cin, inA, inB, invA, invB, aluOp, aluJmp, jalSel, aluFinal, newPC, sOpSel, aluOut, addPC);

   input SLBIsel;
   input incPC;
   input immSrc;
   input [15:0] imm8;
   input [15:0] imm11;
   input [2:0] brchSig;
   input Cin;
   input [15:0] inA;
   input [15:0] inB;
   input invA;
   input invB;
   input [3:0] aluOp;
   input aluJmp;
   input jalSel;
   input sOpSel;

   output [15:0] aluFinal;
   output [15:0] newPC;
   output [15:0] addPC;
   output [15:0] aluOut;

   wire zeroFlag;
   wire oflFlag;
   wire carryOut;
   wire signFlag;
   wire jmpSel;
   wire [15:0] pcOrSLBI;
   wire [15:0] imm8Or11;
   wire [15:0] compPC;
   wire [15:0] jmpPC;
   

   // ALU
   alu aluExec(.InA(inA), .InB(inB), .Cin(Cin), .Oper(aluOp), .invA(invA), .invB(invB), .sign(1'b0), .Out(aluOut), .Zero(zeroFlag), .Ofl(oflFlag), .Cout(carryOut), .signFlag(signFlag));

   // Branch conditional module
   branch_conditional branchCond(.brchSig(brchSig), .sf(signFlag), .zf(zeroFlag), .of(oflFlag), .cf(carryOut), .jmpSel(jmpSel));

   assign pcOrSLBI = (SLBIsel) ? aluOut : incPC;
   assign imm8or11 = (immSrc) ? imm11 : imm8;

   assign aluFinal = (sOpSel) ? {15'b0,jmpSel} : aluOut;

   // PC add module 
   cla_16 pcImmAdd(.sum(compPC), .cout(), .ofl(), .a(pcOrSLBI), .b(imm8or11), .c_in(1'b0), .sign(1'b0));
   
   // 2:1 muxes to control PC and register wb values
   assign jmpPC = (jmpSel) ? compPC : incPC;
   assign newPC = (aluJmp) ? aluOut : jmpPC;
   assign addPC = (jalSel) ? incPC : jmpPC;

endmodule
`default_nettype wire
