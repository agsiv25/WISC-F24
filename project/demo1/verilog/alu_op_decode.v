/*
   CS/ECE 552 Spring '22
  
   Filename        : alu_op_decode.v
   Description     : This is the module that decodes the instruction and determines the ALU operation. 
*/
`default_nettype none
module alu_op_decode (instruction, aluOp);

input [15:0] instruction;

output [3:0] aluOp;

	// 0000 rll Rotate left
   parameter RLL = 4'b0000;
	// 0001 sll Shift left logical
   parameter SLL = 4'b0001;
	// 0010 sra Shift right arithmetic
   parameter SRA = 4'b0010;
	// 0011 srl Shift right logical
   parameter SRL = 4'b0011;
	// 0100 ADD A+B
   parameter ADD = 4'b0100;
	// 0101 AND A AND B
   parameter AND = 4'b0101;
	// 0110 OR A OR B
   parameter OR = 4'b0110;
	// 0111 XOR A XOR B
   parameter XOR = 4'b0111;



	// 1000 SLBI 
   parameter SLBI = 4'b1000;
	// 1001 BTR
   parameter BTR = 4'b1001;

   reg [3:0] aluOp;

   begin
      case (instruction[15:11])
         5'b01000:          // ADDI
            begin
               aluOp <= ADD;
            end
         5'b01001:          // SUBI
            begin
               aluOp <= ADD;
            end
         5'b01010:          // XORI
            begin
               aluOp <= XOR;
            end
         5'b01011:          // ANDNI
            begin
               aluOp <= AND;
            end
         5'b10100:          // ROLI
            begin
               aluOp <= ROL;
            end
         5'b10101:          // SLLI
            begin
               aluOp <= SLL;
            end
         5'b10110:          // RORI
            begin
               aluOp <= ROR;
            end
         5'b10111:          // SRLI
            begin
               aluOp <= SRL;
            end
         5'b10000:          // ST
            begin
               aluOp <= ADD;
            end
         5'b10001:          // LD
            begin
               aluOp <= ADD;
            end
         5'b10011:          // STU
            begin
               aluOp <= ADD;
            end
         5'b11001:          // BTR
            begin
               aluOp <= BTR;
            end
         5'b11011:          // Standard ALU operations
            begin
               aluOp <= (instruction[1:0] == 2'b10) ? XOR : (instruction[1:0] == 2'b11) ? AND : ADD;
            end
         5'b11010:          // Standard ALU shifts
            begin
               aluOp <= (instruction[1:0] == 2'b00) ? ROL : (instruction[1:0] == 2'b01) ? SLL : ADD;

            end
         5'b11100:          // SEQ
            begin
            end
         5'b01000:          // Standard ALU operations
            begin
            end
         5'b01000:          // Standard ALU operations
            begin
            end
         5'b01000:          // Standard ALU operations
            begin
            end
         5'b01000:          // Standard ALU operations
            begin
            end
         5'b01000:          // Standard ALU operations
            begin
            end
         5'b01000: 
            begin
            end
         5'b01000: 
            begin
            end
         5'b01000: 
            begin
            end
         5'b01000: 
            begin
            end
         5'b01000: 
            begin
            end
         5'b01000: 
            begin
            end
         
         default: 
            begin
            end
      endcase
   end

endmodule
`default_nettype wire