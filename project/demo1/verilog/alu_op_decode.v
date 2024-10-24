/*
   CS/ECE 552 Spring '22
  
   Filename        : alu_op_decode.v
   Description     : This is the module that decodes the instruction and determines the ALU operation. 
*/
`default_nettype none
module alu_op_decode (instruction, aluOp);

input wire [15:0] instruction;

output reg [3:0] aluOp;

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
   // 1010 rrl rotate right 
   parameter RRL = 4'b1010;

   always@(instruction) begin
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
               aluOp <= RLL;
            end
         5'b10101:          // SLLI
            begin
               aluOp <= SLL;
            end
         5'b10110:          // RORI
            begin
               aluOp <= RRL;
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
               aluOp <= (instruction[1:0] == 2'b00) ? RLL : (instruction[1:0] == 2'b01) ? SLL : (instruction[1:0] == 2'b10) ? RRL : SRL;
            end
         5'b11100:          // SEQ
            begin
               aluOp <= ADD;
            end
         5'b11101:          // SLT
            begin
               aluOp <= ADD;
            end
         5'b11110:          // SLE
            begin
               aluOp <= ADD;
            end
         5'b11111:          // SCO
            begin
               aluOp <= ADD;
            end
         5'b01100:          // BEQZ
            begin
               aluOp <= ADD;
            end
         5'b01101:          // BNEZ
            begin
               aluOp <= ADD;
            end
         5'b01110:          // BLTZ
            begin
               aluOp <= ADD;
            end
         5'b01111:          // BGEZ
            begin
               aluOp <= ADD;
            end
         5'b10010:          // SLBI
            begin
               aluOp <= SLBI;
            end
         5'b00101:          // JR
            begin
               aluOp <= ADD;
            end
         5'b00111:          // JALR
            begin
               aluOp <= ADD;
            end
         5'b00111:          // JALR
            begin
               aluOp <= ADD;
            end
         default:           // All other operations
            begin
               aluOp <= RLL;
            end
      endcase
   end

endmodule
`default_nettype wire