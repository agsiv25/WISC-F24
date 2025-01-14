/*
   CS/ECE 552 Spring '22
  
   Filename        : control_unit.v
   Description     : This is the module that decodes the instruction and sends various control signals.
*/
`default_nettype none
module control_unit (instruction, aluJmp, memWrt, brchSig, Cin, invA, invB, regWrt, wbDataSel, stuSel, immSrc, SLBIsel, createDump, BSrc, zeroSel, regDestSel, jalSel, sOpSel, err, aluPC, memAccess);

input wire [15:0] instruction;

output reg aluJmp;
output reg memWrt;              // memory write or read signal 
output reg [2:0] brchSig;       // bit 2: sign flag, bit 1: zero flag, bit 0: carry out
output reg Cin;
output reg invA;                // invert ALU input A
output reg invB;                // invert ALU input B
output reg regWrt;
output reg [1:0] wbDataSel;     // choose source of writeback data 
output reg stuSel;              // for STU instruction, choose memory write data source
output reg immSrc;              // used to choose which immediate to add to PC
output reg SLBIsel;
output reg createDump;
output reg [1:0] BSrc;          // select signal for inB mux
output reg zeroSel;             // choose zero or sign extended immediates 
output reg [1:0] regDestSel;    // sel signal to register write mux 
output reg jalSel;              // select signal for jal and slbiu conflict
output reg sOpSel;
output reg err;
output reg aluPC;
output reg memAccess;
// IMPLEMENT HERE 
always @(*) begin
   aluJmp = 1'b0;
   memWrt = 1'b0;
   brchSig = 3'b000;
   Cin = 1'b0;
   invA = 1'b0;
   invB = 1'b0;
   regWrt = 1'b0;
   wbDataSel = 2'b00;
   stuSel = 1'b0;
   immSrc = 1'b0;
   SLBIsel = 1'b0;
   createDump = 1'b0;
   BSrc = 2'b00;
   zeroSel = 1'b0;
   regDestSel = 2'b00;
   jalSel = 1'b0;
   sOpSel = 1'b0;
   err = 1'b0;
   aluPC = 1'b0;
   memAccess = 1'b0;
   case(instruction[15:11])
      5'b0_0000: begin // HALT
         createDump = 1'b1;
      end
      5'b0_0001: begin // NOP
         // Do nothing
      end
      5'b0_1000: begin //ADDI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b0; //select sign extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
         invA = 1'b0; //invert inB for 2s comp add(sub)
         Cin = 1'b0; //enable carry in for 2s comp add(sub)
      end
      5'b0_1001: begin //SUBI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         Cin = 1'b1; //enable carry in for 2s comp add(sub)
         invA = 1'b1; //invert inB for 2s comp add(sub)
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b0; //select sign extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      5'b0_1010: begin //XORI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b1; //select zero extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      5'b0_1011: begin //ANDNI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         invB = 1'b1; //invert inB for not
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b1; //select zero extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      5'b1_0100: begin //ROLI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b1; //select zero extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      5'b1_0101: begin //SLLI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b1; //select zero extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      5'b1_0110: begin //RORI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b1; //select zero extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      5'b1_0111: begin //SRLI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b1; //select zero extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      5'b1_0000: begin //ST
         memWrt = 1'b1; //enable memory write
         BSrc = 2'b01; //select imm5 as inB
         stuSel = 1'b1; //select regB as memory write data
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b0; //select sign extended imm5
         memAccess = 1'b1; //enable memory access
      end
      5'b1_0001: begin //LD
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b01; //select memory as wb src
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b0; //select sign extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
         memAccess = 1'b1; //enable memory access
      end
      5'b1_0011: begin //STU
         memWrt = 1'b1; //enable memory write
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select ALU as wb src
         stuSel = 1'b1; //select regB as memory write data
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b0; //select sign extended imm5
         memAccess = 1'b1; //enable memory access
      end
      5'b1_1001: begin //BTR
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select ALU as wb src
         regDestSel = 2'b10; //select instr bits [4:2] as write back
      end
      5'b1_1011: begin //ALU (ADD, SUB, XOR, ANDN)
         Cin = (instruction[1:0] == 2'b01) ? 1'b1 : 1'b0;
         invA = (instruction[1:0] == 2'b01) ? 1'b1 : 1'b0;
         invB = (instruction[1:0] == 2'b11) ? 1'b1 : 1'b0;
         wbDataSel = 2'b10; //select ALU as wb src
         regWrt = 1'b1; //enable write back
         BSrc = 2'b00; //select regB
         regDestSel = 2'b10; //select instr bits [4:2] as write back
      end
      5'b1_1010: begin //ALU (ROL, SLL, ROR, SRL)
         wbDataSel = 2'b10; //select ALU as wb src
         regWrt = 1'b1; //enable write back
         BSrc = 2'b00; //select regB
         regDestSel = 2'b10; //select instr bits [4:2] as write back
      end
      5'b1_1100: begin //SEQ
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select aluOut as wb src
         regDestSel = 2'b10; //select instr bits [4:2] as write back
         brchSig = 3'b010; //if zero flag then true
         sOpSel = 1'b1; //select special to tell you to use brch cond output
         SLBIsel = 1'b1; //select ALU output as PC
         Cin = 1'b1; //enable carry in for 2s comp add(sub)
         invA = 1'b1; //invert inA for 2s comp add(sub)
      end
      5'b1_1101: begin //SLT
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select aluOut as wb src
         regDestSel = 2'b10; //select instr bits [4:2] as write back
         brchSig = 3'b100; //if sign flag then true      
         sOpSel = 1'b1; //select special to tell you to use brch cond output
         SLBIsel = 1'b1; //select ALU output as PC
         Cin = 1'b1; //enable carry in for 2s comp add(sub)
         invB = 1'b1; //invert inA for 2s comp add(sub)
      end
      5'b1_1110: begin //SLE
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select aluOut as wb src
         regDestSel = 2'b10; //select instr bits [4:2] as write back
         brchSig = 3'b110; //if zero or sign then true
         sOpSel = 1'b1; //select special to tell you to use brch cond output
         SLBIsel = 1'b1; //select ALU output as PC
         Cin = 1'b1; //enable carry in for 2s comp add(sub)
         invB = 1'b1; //invert inA for 2s comp add(sub)
      end
      5'b1_1111: begin //SCO
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select aluOut as wb src
         regDestSel = 2'b10; //select instr bits [4:2] as write back
         brchSig = 3'b001; //if carry out then true
         sOpSel = 1'b1; //select special to tell you to use brch cond output
         SLBIsel = 1'b1; //select ALU output as PC
      end
      5'b0_1100: begin //BEQZ
         brchSig = 3'b010; //select zero flag
         BSrc = 2'b11; //select 0 as inB
      end
      5'b0_1101: begin //BNEZ
         brchSig = 3'b101; //select not zero flag
         BSrc = 2'b11; //select 0 as inB
      end
      5'b0_1110: begin //BLTZ
         brchSig = 3'b100; //select sign flag
         BSrc = 2'b11; //select 0 as inB
      end
      5'b0_1111: begin //BGEZ
         brchSig = 3'b011; //if not sign or is zero
         BSrc = 2'b11; //select 0 as inB
      end
      5'b1_1000: begin //LBI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b11; //select imm8 as wb src
      end
      5'b1_0010: begin //SLBI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b00; //select addPC as wb src
         SLBIsel = 1'b1; //select ALU output as PC
         aluPC = 1'b1; //select ALU output as PC
         zeroSel = 1'b1; //select zero extended imm8
         brchSig = 3'b111; //select special to tell you to go ALU
      end
      5'b0_0100: begin //J
         immSrc = 1'b1; //select imm11 as PC adder input
         brchSig = 3'b111; //select jump
      end
      5'b0_0101: begin //JR
         BSrc = 2'b11; //select 0 as inB
         brchSig = 3'b111; //select special to tell you to go ALU
         aluPC = 1'b1; //select ALU output as PC
      end
      5'b0_0110: begin //JAL
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b00; //select addPC as wb src
         immSrc = 1'b1; //select imm11 as PC adder input
         jalSel = 1'b1; //select ALU output as PC
         regDestSel = 2'b11; //select instr R7 as write back
         brchSig = 3'b111; //select special to tell you to go ALU
      end
      5'b0_0111: begin //JALR
         aluPC = 1'b1;
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b00; //select addPC as wb src
         jalSel = 1'b1; //select ALU output as PC
         BSrc = 2'b11; //select 0 as inB
         regDestSel = 2'b11; //select instr R7 as write back
         brchSig = 3'b111; //select special to tell you to go ALU
      end
      5'b0_0010: begin //siic

      end
      5'b0_0011: begin //NOP/RTI

      end
      default: begin
         err = 1'b1;
      end
   endcase
end

         

endmodule
`default_nettype wire