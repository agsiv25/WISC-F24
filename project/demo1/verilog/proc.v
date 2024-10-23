/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
`default_nettype none
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input wire clk;
   input wire rst;

   output reg err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */

   wire [15:0] newPC;
   wire [15:0] instruction;
   wire [15:0] wbData;
   wire createDump;
   wire [15:0] incPC;
   wire [15:0] imm8;
   wire [15:0] imm11;
   wire aluJmp;
   wire SLBIsel;
   wire memWrt;
   wire [2:0] brchSig;
   wire Cin;
   wire invA;
   wire invB;
   wire [1:0] wbDataSel;
   wire immSrc;
   wire [3:0] aluOp;
   wire [15:0] inA;
   wire [15:0] inB;
   wire [15:0] wrtData;
   wire jalSel;
   wire sOpSel;
   wire [15:0] aluFinal;
   wire [15:0] aluOut;
   wire [15:0] memOut;
   wire [15:0] addPC;
   wire fetchErr;
   wire decodeErr;

   fetch fetchSection(.newPC(newPC), .createDump(createDump), .rst(rst), .clk(clk), .incPC(incPC), .instruction(instruction), .err(fetchErr));

   decode decodeSection(.instruction(instruction), .wbData(wbData), .clk(clk), .rst(rst), .imm8(imm8), .imm11(imm11), .aluJmp(aluJmp), .SLBIsel(SLBIsel), .createDump(createDump), .memWrt(memWrt), .brchSig(brchSig), .Cin(Cin), .invA(invA), .invB(invB), .wbDataSel(wbDataSel), .immSrc(immSrc), .aluOp(aluOp), .inA(inA), .inB(inB), .wrtData(wrtData), .jalSel(jalSel), .sOpSel(sOpSel), .err(decodeErr));

   execute executeSection(.SLBIsel(SLBIsel), .incPC(incPC), .immSrc(immSrc), .imm8(imm8), .imm11(imm11), .brchSig(brchSig), .Cin(Cin), .inA(inA), .inB(inB), .invA(invA), .invB(invB), .aluOp(aluOp), .aluJmp(aluJmp), .jalSel(jalSel), .aluFinal(aluFinal), .newPC(newPC), .sOpSel(sOpSel), .aluOut(aluOut), .addPC(addPC));

   memory memorySection(.dataAddr(aluOut), .wrtData(wrtData), .memWrt(memWrt), .createDump(createDump), .clk(clk), .rst(rst), .memOut(memOut));

   wb wbSection(.wbData(wbData), .addPC(addPC), .memOut(memOut), .aluFinal(aluFinal), .imm8(imm8), .wbDataSel(wbDataSel));

   assign err <= fetchErr | decodeErr;
   

endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
