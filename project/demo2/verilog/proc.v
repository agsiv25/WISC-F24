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

   wire [15:0] newPCX;
   wire [15:0] instructionF;
   wire [15:0] instructionD;
   wire [15:0] instructionX;
   wire [15:0] instructionM;
   wire [15:0] instructionW;
   wire [15:0] wbData;
   wire createDumpD;
   wire createDumpX;
   wire createDumpM;
   wire [15:0] incPCF;
   wire [15:0] incPCD;
   wire [15:0] incPCX;
   wire [15:0] imm8D;
   wire [15:0] imm8X;
   wire [15:0] imm8M;
   wire [15:0] imm8W;
   wire [15:0] imm11D;
   wire [15:0] imm11X;
   wire aluJmpD;
   wire aluJmpX;
   wire SLBIselD;
   wire SLBIselX;
   wire memWrtD;
   wire memWrtX;
   wire memWrtM;
   wire [2:0] brchSigD;
   wire [2:0] brchSigX;
   wire CinD;
   wire CinX;
   wire invAD;
   wire invAX;
   wire invBD;
   wire invBX;
   wire [1:0] wbDataSelD;
   wire [1:0] wbDataSelX;
   wire [1:0] wbDataSelM;
   wire [1:0] wbDataSelW;
   wire immSrcD;
   wire immSrcX;
   wire [3:0] aluOpD;
   wire [3:0] aluOpX;
   wire [15:0] inAD;
   wire [15:0] inAX;
   wire [15:0] inBD;
   wire [15:0] inBX;
   wire [15:0] wrtDataD;
   wire [15:0] wrtDataX;
   wire [15:0] wrtDataM;
   wire jalSelD;
   wire jalSelX; 
   wire sOpSelD;
   wire sOpSelX;
   wire [15:0] aluFinalX;
   wire [15:0] aluFinalM;
   wire [15:0] aluFinalW;
   wire [15:0] aluOutX;
   wire [15:0] aluOutM;
   wire [15:0] memOutM;
   wire [15:0] memOutW;
   wire [15:0] addPCX;
   wire [15:0] addPCM;
   wire [15:0] addPCW;
   wire fetchErr;
   wire decodeErr;

   wire readEnD;
   wire readEnX;
   wire readEnM;
   wire aluPCD;
   wire aluPCX;
   wire regWrtD;
   wire regWrtX;
   wire regWrtM;
   wire regWrtW;
   wire [2:0] wrtRegD;
   wire [2:0] wrtRegX;
   wire [2:0] wrtRegM;
   wire [2:0] wrtRegW;
   wire branchInstD;
   wire branchInstX;
   wire instrValidF;
   wire instrValidD;
   

   fetch fetchSection(.newPC(newPCX), .createDump(createDumpM), .rst(rst), .clk(clk), .incPC(incPCF), .instruction(instructionF), .err(fetchErr), .regWrtD(regWrtD), .regWrtX(regWrtX), .regWrtM(regWrtM), .regWrtW(regWrtW), .wrtRegD(wrtRegD), .wrtRegX(wrtRegX), .wrtRegM(wrtRegM), .wrtRegW(wrtRegW), .branchInstD(branchInstD), .branchInstX(branchInstX), .instrValid(instrValidF), .branchInstM(branchInstM), .branchInstW(branchInstW));

   f2d_ff fetch2decode(.instructionF(instructionF), .incPCF(incPCF), .errF(fetchErr), .clk(clk), .rst(rst), .instructionD(instructionD), .incPCD(incPCD), .instrValidF(instrValidF), .instrValidD(instrValidD));
   
   decode decodeSection(.instruction(instructionD), .wbData(wbData), .clk(clk), .rst(rst), .imm8(imm8D), .imm11(imm11D), .aluJmp(aluJmpD), .SLBIsel(SLBIselD), .createDump(createDumpD), .memWrt(memWrtD), .brchSig(brchSigD), .Cin(CinD), .invA(invAD), .invB(invBD), .wbDataSel(wbDataSelD), .immSrc(immSrcD), .aluOp(aluOpD), .inA(inAD), .inB(inBD), .wrtData(wrtDataD), .jalSel(jalSelD), .sOpSel(sOpSelD), .err(decodeErr), .readEn(readEnD), .aluPC(aluPCD), .regWrtOut(regWrtD), .regWrt(regWrtW), .wrtRegOut(wrtRegD), .wrtReg(wrtRegW), .instrValidD(instrValidD), .branchInst(branchInstD));

   d2x_ff decode2exec(.createDumpD(createDumpD), .createDumpX(createDumpX), .instructionD(instructionD), .instructionX(instructionX), .imm11D(imm11D), .imm8D(imm8D), .imm11X(imm11X), .imm8X(imm8X), .aluJmpD(aluJmpD), .aluJmpX(aluJmpX), .SLBIselD(SLBIselD), .SLBIselX(SLBIselX), .memWrtD(memWrtD), .memWrtX(memWrtX), .brchSigD(brchSigD), .brchSigX(brchSigX), .CinD(CinD), .CinX(CinX), .invAD(invAD), .invAX(invAX), .invBD(invBD), .invBX(invBX), .wbDataSelD(wbDataSelD), .wbDataSelX(wbDataSelX), .immSrcD(immSrcD), .immSrcX(immSrcX), .aluOpD(aluOpD), .aluOpX(aluOpX), .jalSelD(jalSelD), .jalSelX(jalSelX), .sOpSelD(sOpSelD), .sOpSelX(sOpSelX), .readEnD(readEnD), .readEnX(readEnX), .inAD(inAD), .inAX(inAX), .inBD(inBD), .inBX(inBX), .wrtDataD(wrtDataD), .wrtDataX(wrtDataX), .aluPCD(aluPCD), .aluPCX(aluPCX), .clk(clk), .rst(rst), .incPCD(incPCD), .incPCX(incPCX), .regWrtD(regWrtD), .regWrtX(regWrtX), .wrtRegD(wrtRegD), .wrtRegX(wrtRegX), .branchInstD(branchInstD), .branchInstX(branchInstX));

   execute executeSection(.SLBIsel(SLBIselX), .incPC(incPCX), .immSrc(immSrcX), .imm8(imm8X), .imm11(imm11X), .brchSig(brchSigX), .Cin(CinX), .inA(inAX), .inB(inBX), .invA(invAX), .invB(invBX), .aluOp(aluOpX), .aluJmp(aluJmpX), .jalSel(jalSelX), .aluFinal(aluFinalX), .newPC(newPCX), .sOpSel(sOpSelX), .aluOut(aluOutX), .addPC(addPCX), .aluPC(aluPCX));

   x2m_ff exec2mem(.createDumpX(createDumpX), .createDumpM(createDumpM), .instructionX(instructionX), .instructionM(instructionM), .clk(clk), .rst(rst), .aluFinalX(aluFinalX), .aluFinalM(aluFinalM), .addPCX(addPCX), .addPCM(addPCM), .aluOutX(aluOutX), .aluOutM(aluOutM), .wrtDataX(wrtDataX), .wrtDataM(wrtDataM), .memWrtX(memWrtX), .memWrtM(memWrtM), .readEnX(readEnX), .readEnM(readEnM), .wbDataSelX(wbDataSelX), .wbDataSelM(wbDataSelM), .imm8X(imm8X), .imm8M(imm8M), .regWrtX(regWrtX), .regWrtM(regWrtM), .wrtRegX(wrtRegX), .wrtRegM(wrtRegM));

   memory memorySection(.dataAddr(aluOutM), .wrtData(wrtDataM), .memWrt(memWrtM), .createDump(createDumpM), .clk(clk), .rst(rst), .memOut(memOutM), .readEn(readEnM));

   m2w_ff mem2wb(.instructionM(instructionM), .instructionW(instructionW), .clk(clk), .rst(rst), .memOutM(memOutM), .memOutW(memOutW), .wbDataSelM(wbDataSelM), .wbDataSelW(wbDataSelW), .addPCM(addPCM), .addPCW(addPCW), .aluFinalM(aluFinalM), .aluFinalW(aluFinalW), .imm8M(imm8M), .imm8W(imm8W), .regWrtM(regWrtM), .regWrtW(regWrtW), .wrtRegM(wrtRegM), .wrtRegW(wrtRegW));

   wb wbSection(.wbData(wbData), .addPC(addPCW), .memOut(memOutW), .aluFinal(aluFinalW), .imm8(imm8W), .wbDataSel(wbDataSelW));

   // assign err <= fetchErr | decodeErr;
   

endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
