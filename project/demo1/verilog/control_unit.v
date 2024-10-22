/*
   CS/ECE 552 Spring '22
  
   Filename        : control_unit.v
   Description     : This is the module that decodes the instruction and sends various control signals.
*/
`default_nettype none
module control_unit (instruction, ALUjmp, ALUOpr, memWrt, brchSig, Cin, invA, invB, regWrt, wbDataSel, stuSel, immSrc, SLBIsel, createDump, BSrc, zeroSel, regDestSel, jalSel);

input [15:0] instruction;

output ALUjmp;
output memWrt;              // memory write or read signal 
output [3:0] brchSig;       // bit 2: sign flag, bit 1: zero flag, bit 0: carry out
output Cin;
output invA;                // invert ALU input A
output invB;                // invert ALU input B
output regWrt;
output [1:0] wbDataSel;     // choose source of writeback data 
output stuSel;              // for STU instruction, choose memory write data source
output immSrc;              // used to choose which immediate to add to PC
output SLBIsel;
output createDump;
output [1:0] BSrc;          // select signal for inB mux
output zeroSel;             // choose zero or sign extended immediates 
output [1:0] regDestSel;    // sel signal to register write mux 
output jalSel;              // select signal for jal and slbiu conflict

// IMPLEMENT HERE 
always @(instruction) begin
   ALUjmp = 1'b0;
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
   casex(instruction[15:11])
      0_0000: begin // HALT
         createDump = 1'b1;
      end
      0_0001: begin // NOP
         // Do nothing
      end
      0_1000: begin //ADDI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b0; //select sign extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      0_1001: begin //SUBI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         Cin = 1'b1; //enable carry in for 2s comp add(sub)
         invA = 1'b1; //invert inB for 2s comp add(sub)
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b0; //select sign extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      0_1010: begin //XORI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b1; //select zero extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      0_1011: begin //ANDNI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         invB = 1'b1; //invert inB for not
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b1; //select zero extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      1_0100: begin //ROLI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b1; //select zero extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      1_0101: begin //SLLI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b1; //select zero extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      1_0110: begin //RORI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b1; //select zero extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      1_0111: begin //SRLI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select alu as wb src
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b1; //select zero extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      1_0000: begin //ST
         memWrt = 1'b1; //enable memory write
         BSrc = 2'b01; //select imm5 as inB
         stuSel = 1'b1; //select regB as memory write data
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b0; //select sign extended imm5
      end
      1_0001: begin //LD
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b01; //select memory as wb src
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b0; //select sign extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      1_0011: begin //STU
         memWrt = 1'b1; //enable memory write
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select ALU as wb src
         stuSel = 1'b1; //select regB as memory write data
         BSrc = 2'b01; //select imm5 as inB
         zeroSel = 1'b0; //select sign extended imm5
         regDestSel = 2'b01; //select instr bits [7:5] as write back
      end
      1_1001: begin //BTR
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b10; //select ALU as wb src
         regDestSel = 2'b10; //select instr bits [4:2] as write back
      end
      1_1011: begin //ALU (ADD, SUB, XOR, ANDN)
         assign Cin = (instruction[1:0] == 2'b01) ? 1'b1 : 1'b0;
         assign invA = (instruction[1:0] == 2'b01) ? 1'b1 : 1'b0;
         wbDataSel = 2'b10; //select ALU as wb src
         regWrt = 1'b1; //enable write back
         BSrc = 2'b00; //select regB
         regDestSel = 2'b10; //select instr bits [4:2] as write back
      end
      1_1010: begin //ALU (ROL, SLL, ROR, SRL)
         wbDataSel = 2'b10; //select ALU as wb src
         regWrt = 1'b1; //enable write back
         BSrc = 2'b00; //select regB
         regDestSel = 2'b10; //select instr bits [4:2] as write back
      end
      1_1100: begin //SEQ
         brchSig = 3'b010; //if zero flag then true
      end
      1_1101: begin //SLT
         brchSig = 3'b100; //if sign flag then true
      end
      1_1110: begin //SLE
         brchSig = 3'b110; //if zero or sign then true
      end
      1_1111: begin //SCO
         brchSig = 2'b001; //if carry out then true
      end
      0_1100: begin //BEQZ
         brchSig = 2'b010; //select zero flag
         BSrc = 2'b11; //select 0 as inB
      end
      0_1101: begin //BNEZ
         brchSig = 2'b101; //select not zero flag
         BSrc = 2'b11; //select 0 as inB
      end
      0_1110: begin //BLTZ
         brchSig = 2'b100; //select sign flag
         BSrc = 2'b11; //select 0 as inB
      end
      0_1111: begin //BGEZ
         brchSig = 2'b011; //if not sign or zero
         BSrc = 2'b11; //select 0 as inB
      end
      1_1000: begin //LBI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b11; //select imm8 as wb src
      end
      1_0010: begin //SLBI
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b00; //select addPC as wb src
         SLBIsel = 1'b1; //select ALU output as PC
         zeroSel = 1'b1; //select zero extended imm8
         brchSig = 2'b11; //select special to tell you to go ALU
      end
      0_0100: begin //J
         immSrc = 1'b1; //select imm11 as PC adder input
      end
      0_0101: begin //JR
         SLBIsel = 1'b1; //select ALU output as PC
         BSrc = 2'b11; //select 0 as inB

      end
      0_0110: begin //JAL
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b00; //select addPC as wb src
         immSrc = 1'b1; //select imm11 as PC adder input
         jalSel = 1'b1; //select ALU output as PC
         regDestSel = 2'b11; //select instr R7 as write back
      end
      0_0111: begin //JALR
         ALUjmp = 1'b1; //enable ALU jump
         regWrt = 1'b1; //enable write back
         wbDataSel = 2'b00; //select addPC as wb src
         jalSel = 1'b1; //select ALU output as PC
         BSrc = 2'b11; //select 0 as inB
         regDestSel = 2'b11; //select instr R7 as write back
      end
      0_0010: begin //siic

      end
      0_0011: begin //NOP/RTI

      end
      default: begin
         err = 1'b1;
      end
   endcase
end

        
         

endmodule
`default_nettype wire