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
always @(instruction) begin
   ALUjmp = 1'b0;
   ALUOpr = 5'b0;
   memWrt = 1'b0;
   brchSig = 2'b00;
   Cin = 1'b0;
   invA = 1'b0;
   invB = 1'b0;
   BSrc = 2'b00;
   regWrt = 1'b0;
   wbDataSel = 2'b00;
   stuSel = 1'b0;
   immSrc = 1'b0;
   SLBIsel = 1'b0;
   createDump = 1'b0;
   BSrc = 2'b00;
   zeroSel = 1'b0;
   regDestSel = 2'b00;
   casex(instruction[15:11])
      0_0000: begin // HALT

      end
      0_0001: begin // NOP

      end
      0_1000: begin //ADDI

      end
      0_1001: begin //SUBI

      end
      0_1010: begin //XORI

      end
      0_1011: begin //ANDNI

      end
      1_0100: begin //ROLI

      end
      1_0101: begin //SLLI

      end
      1_0110: begin //RORI

      end
      1_0111: begin //SRLI

      end
      1_0000: begin //ST

      end
      1_0001: begin //LD

      end
      1_0011: begin //STU

      end
      1_1001: begin //BTR

      end
      1_1011: begin //ALU (ADD, SUB, XOR, ANDN)

      end
      1_1010: begin //ALU (ROL, SLL, ROR, SRL)

      end
      1_1100: begin //SEQ

      end
      1_1101: begin //SLT

      end
      1_1110: begin //SLE

      end
      1_1111: begin //SCO

      end
      0_1100: begin //BEQZ

      end
      0_1101: begin //BNEZ

      end
      0_1110: begin //BLTZ

      end
      0_1111: begin //BGEZ

      end
      1_1000: begin //LBI

      end
      1_0010: begin //SLBI

      end
      0_0100: begin //J

      end
      0_0101: begin //JR

      end
      0_0110: begin //JAL

      end
      0_0111: begin //JALR

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