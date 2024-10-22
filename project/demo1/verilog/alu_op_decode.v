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
	// 1001 ROLI
   parameter ROLI = 4'b1001;
	// 1010 RORI
   parameter RORI = 4'b1010;
	// 1011 SRLI
   parameter SRLI = 4'b1011;
	// 1100 BTR
   parameter BTR = 4'b1100;

   reg [3:0] aluOp;

   begin
      case (instruction[15:11])
         5'b01000: 
            begin
               aluOp = ADD;
            end
         5'b01001: 
            begin
               aluOp = ADD;
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