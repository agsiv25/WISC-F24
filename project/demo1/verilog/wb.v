/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb (RegDest, incPC, memOut, ALUout, imm8, wbData);

   // TODO: Your code here

   input [1:0]RegDest;
   input [15:0]incPC;
   input [15:0]memOut;
   input [15:0]ALUout;
   input [15:0]imm8;

   output [15:0]wbData;

   mux4_1 wb_sel(.Out(wbData), .S(RegDest), .InpA(incPC), .InpB(memOut), .InpC(ALUout), .InpD(imm8));
   
endmodule
`default_nettype wire
