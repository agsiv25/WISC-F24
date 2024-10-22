/*
   CS/ECE 552 Spring '22
  
   Filename        : control_unit.v
   Description     : This is the module that decodes the instruction and sends various control signals.
*/
`default_nettype none
module control_unit (instruction, ALUjmp, ALUOpr, memWrt, brchSig, Cin, invA, invB, BSrc, regWrt, wbDataSel, stuSel, immSrc, SLBIsel, createDump, BSrc, zeroSel, regDestSel);

input [15:0] instruction;

output ALUjmp;
output [4:0] ALUOpr;        // instruction input to ALU operation module
output memWrt;              // memory write or read signal 
output [1:0] brchSig;
output Cin;
output invA;                // invert ALU input A
output invB;                // invert ALU input B
output [1:0] BSrc;
output regWrt;
output [1:0] wbDataSel;     // choose source of writeback data 
output stuSel;              // for STU instruction, choose memory write data source
output immSrc;              // used to choose which immediate to add to PC
output SLBIsel;
output createDump;
output [1:0] BSrc;          // select signal for inB mux
output zeroSel;             // choose zero or sign extended immediates 
output [1:0] regDestSel;    // sel signal to register write mux 

// IMPLEMENT HERE 

endmodule
`default_nettype wire