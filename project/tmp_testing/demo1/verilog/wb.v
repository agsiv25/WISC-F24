/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb (wbDataSel, addPC, memOut, aluFinal, imm8, wbData);

   // TODO: Your code here

   input wire [1:0]wbDataSel;
   input wire [15:0]addPC;
   input wire [15:0]memOut;
   input wire [15:0]aluFinal;
   input wire [15:0]imm8;

   output wire [15:0]wbData;

   // mux4_1 wb_sel(.Out(wbData), .S(wbDataSel), .InpA(pcAdd), .InpB(memOut), .InpC(ALUout), .InpD(imm8));

   assign wbData = (wbDataSel == 2'b0) ? addPC : (wbDataSel == 2'b01) ? memOut : (wbDataSel == 2'b10) ? aluFinal : imm8;
   
endmodule
`default_nettype wire
