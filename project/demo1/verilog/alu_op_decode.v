/*
   CS/ECE 552 Spring '22
  
   Filename        : alu_op_decode.v
   Description     : This is the module that decodes the instruction and determines the ALU operation. 
*/
`default_nettype none
module alu_op_decode (ALUOpr, instructionALU, aluOp);

input [4:0] ALUOpr;
input [1:0] instructionALU;

output [3:0] aluOp;

// IMPLEMENT HERE 

endmodule
`default_nettype wire