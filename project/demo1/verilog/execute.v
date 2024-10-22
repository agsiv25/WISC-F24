/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (SLBIsel, incPC, immSrcl, imm8, imm11, brchSig, Cin, inA, inB, invA, invB, wrtData, aluOp, aluJmp, aluOut, newPC, pcAdd);

   input SLBIsel;
   input incPC;
   input immSrcl;
   input [15:0] imm8;
   input [15:0] imm11;
   input [1:0] brchSig;
   input Cin;
   input [15:0] inA;
   input [15:0] inB;
   input invA;
   input invB;
   input [15:0] wrtData;
   input [3:0] aluOp;
   input aluJmp;

   output [15:0] aluOut;
   output [15:0] newPC;
   output [15:0] pcAdd;

   wire zeroFlag;
   wire oflFlag;
   wire jmpSel;
   wire [15:0] pcOrSLBI;
   wire [15:0] imm8Or11;
   wire [15:0] addPC;




   alu aluExec(.InA(inA), .InB(inB), .Cin(Cin), .Oper(aluOp), .invA(invA), .invB(invB), .sign(1'b0), .Out(aluOut), .Zero(zeroFlag), .Ofl(oflFlag));

   branch_conditional branchCond(.in(brchSig), .sf(), .zf(zeroFlag), .of(oflFlag), .cf(), .out(jmpSel));

   assign pcOrSLBI = (SLBIsel) ? aluOut : incPC;
   assign imm8Or11 = (immSrcl) ? imm11 : imm8;

   cla_16 pcImmAdd(.sum(addPC), .cout(), .ofl(), .a(pcOrSLBI), .b(imm8Or11), .c_in(1'b0), .sign(1'b0));
   
   assign pcAdd = (jmpSel) ? addPC : incPC;

   assign newPC = (aluJmp) ? aluOut : pcAdd;

endmodule
`default_nettype wire
