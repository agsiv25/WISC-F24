/*
   CS/ECE 552 Spring '22
  
   Filename        : branch_conditional.v
   Description     : This is the module that decodes the ALU flags in conjunction with the control module signal to determine if branch conditions are met. 
*/
module branch_conditional (brchSig, sf, zf, of, cf, jmpSel);

input wire [1:0] brchSig;
input wire sf;
input wire zf;
input wire of;
input wire cf;

output wire jmpSel;

endmodule