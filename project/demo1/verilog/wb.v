/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb (wbDataSel, pcAdd, memOut, ALUout, imm8, wbData);

   // TODO: Your code here

   input [1:0]wbDataSel;
   input [15:0]pcAdd;
   input [15:0]memOut;
   input [15:0]ALUout;
   input [15:0]imm8;

   output [15:0]wbData;

   // mux4_1 wb_sel(.Out(wbData), .S(wbDataSel), .InpA(pcAdd), .InpB(memOut), .InpC(ALUout), .InpD(imm8));

   assign wbData = (wbDataSel == 2'b0) ? pcAdd : (wbDataSel == 2'b01) ? memOut : (wbDataSel == 2'b10) ? ALUout : imm8;
   
endmodule
`default_nettype wire
