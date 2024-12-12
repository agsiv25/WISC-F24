/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (SLBIsel, incPC, immSrc, imm8, imm11, brchSig, Cin, inA, inB, invA, invB, aluOp, aluJmp, jalSel, aluFinal, newPC, sOpSel, aluOut, addPC, aluPC, fwCntrlB, fwCntrlA, wbDataSelX, x2xALUData, x2xImm8Data, m2xALUData, m2xImm8Data, m2xMemData, x2xAddPCData, m2xAddPCData, stuSel, wrtDataXin, wrtDataXout);

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

   // forwarding
   input wire [5:0] fwCntrlA;
   input wire [5:0] fwCntrlB;
   input wire [1:0] wbDataSelX;
   input wire [15:0] x2xALUData, x2xImm8Data, x2xAddPCData;
   input wire [15:0] m2xALUData, m2xImm8Data, m2xMemData, m2xAddPCData;
   input wire stuSel;
   input wire [15:0] wrtDataXin;
   output wire [15:0] wrtDataXout;

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
   
   // forwarding
   wire [15:0] forwardedInA;
   wire [15:0] preSTForwardedInB; 
   wire [15:0] forwardedInB;

   // forwarding control word passed in: 4'bXXXX. fwCntrlX[3] is forward at all? y/n. fwCntrlX[2] is 0 for EX to EX forwarding,
   // otherwise 1 for MEM to EX forwarding. fwCntrlX[1:0] are used to determine forwarding data source. 2'b00 = addPC, 2'b10 = ALU, 2'b11 = imm8, 
   // add 2'b01 = memory. 

   assign forwardedInA = fwCntrlA[3] ? (fwCntrlA[2] ? (~fwCntrlA[1] ? (fwCntrlA[0] ? m2xMemData : m2xAddPCData) : (fwCntrlA[0] ? m2xImm8Data : m2xALUData)) : (fwCntrlA[1] ? (fwCntrlA[0] ? x2xImm8Data : x2xALUData) : x2xAddPCData)) : inA;
   assign preSTForwardedInB = fwCntrlB[3] ? (fwCntrlB[2] ? (~fwCntrlB[1] ? (fwCntrlB[0] ? m2xMemData : m2xAddPCData) : (fwCntrlB[0] ? m2xImm8Data : m2xALUData)) : (fwCntrlB[1] ? (fwCntrlB[0] ? x2xImm8Data : x2xALUData) : x2xAddPCData)) : inB;

   // assign forwardedInA = (x2xACntrl) ? x2xForwardData : (m2xACntrl) ? m2xForwardData : inA;
   // assign forwardedInB = (x2xBCntrl) ? x2xForwardData : (m2xBCntrl) ? m2xForwardData : inB;

   // for ST and STU. forwarding for memory store register value

   // for load 
   //assign wrtDataXout = (stuSel) ? wrtDataXin : preSTForwardedInB;
   // for store 
   //assign wrtDataXout = (stuSel) ? preSTForwardedInB : wrtDataXin;
   // assign wrtDataXout = ~fwCntrlB[5] ? (fwCntrlB[4] ? preSTForwardedInB : wrtDataXin) : (fwCntrlB[4] ? wrtDataXin : preSTForwardedInB);

   assign wrtDataXout = (~stuSel) ? wrtDataXin : preSTForwardedInB;

   assign forwardedInB = (stuSel) ? inB : preSTForwardedInB;

   // ALU
   alu aluExec(.InA(forwardedInA), .InB(forwardedInB), .Cin(Cin), .Oper(aluOp), .invA(invA), .invB(invB), .sign(1'b0), .Out(aluOut), .Zero(zeroFlag), .Ofl(oflFlag), .Cout(carryOut), .signFlag(signFlag));

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
