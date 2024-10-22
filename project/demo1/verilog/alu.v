/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 3

    A multi-bit ALU module (defaults to 16-bit). It is designed to choose
    the correct operation to perform on 2 multi-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the multi-bit result
    of the operation, as well as drive the output signals Zero and Overflow
    (OFL).
*/
module alu (InA, InB, Cin, Oper, invA, invB, sign, Out, Zero, Ofl);

    parameter OPERAND_WIDTH = 16;    
    parameter NUM_OPERATIONS = 4;
       
    input  [OPERAND_WIDTH -1:0] InA ; // Input operand A
    input  [OPERAND_WIDTH -1:0] InB ; // Input operand B
    input                       Cin ; // Carry in
    input  [NUM_OPERATIONS-1:0] Oper; // Operation type
    input                       invA; // Signal to invert A
    input                       invB; // Signal to invert B
    input                       sign; // Signal for signed operation
    output [OPERAND_WIDTH -1:0] Out ; // Result of computation
    output                      Ofl ; // Signal if overflow occured
    output                      Zero; // Signal if Out is 0

    /* YOUR CODE HERE */

	// 0000 rll Rotate left
	// 0001 sll Shift left logical
	// 0010 sra Shift right arithmetic
	// 0011 srl Shift right logical
	// 0100 ADD A+B
	// 0101 AND A AND B
	// 0110 OR A OR B
	// 0111 XOR A XOR B
	// 1000 SLBI 
	// 1001 BTR

	wire [15:0] Atouse;
	wire [15:0] Btouse;

	wire [15:0] nonBarrelOpsOut;

	wire [15:0] shifterout;

	wire [15:0] ADDout;
	wire [15:0] ANDout;
	wire [15:0] ORout;
	wire [15:0] XORout;

	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INPUTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	// Invert A and B based on invA and invB signal
	assign Atouse = (invA) ? ~InA : InA; 
	assign Btouse = (invB) ? ~InB : InB;  

	// first 4 operations 
	shifter ALUshifter (.In(Atouse), .ShAmt(Btouse[3:0]), .Oper(Oper[1:0]), .Out(shifterout));

	// 2's compliment ADD
	cla_16b ALUadder (.sum(ADDout), .c_out(), .ofl(Ofl), .a(Atouse), .b(Btouse), .c_in(Cin), .sign(sign));

	// Bitwise AND
	assign ANDout = Atouse & Btouse;

	// Bitwise OR
	assign ORout = Atouse | Btouse;

	// Bitwise XOR
	assign XORout = Atouse ^ Btouse;


	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ OUTPUTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	// Out: use mux to decide between ADD, AND, OR or XOR. Then use ternary statement to decide between shifting operations and non-shifting operations 
	quadmux4_1 stage1_0 (.Out(nonBarrelOpsOut[3:0]), .S(Oper[1:0]), .InpA(ADDout[3:0]), .InpB(ANDout[3:0]), .InpC(ORout[3:0]), .InpD(XORout[3:0]));
	quadmux4_1 stage1_1 (.Out(nonBarrelOpsOut[7:4]), .S(Oper[1:0]), .InpA(ADDout[7:4]), .InpB(ANDout[7:4]), .InpC(ORout[7:4]), .InpD(XORout[7:4]));
	quadmux4_1 stage1_2 (.Out(nonBarrelOpsOut[11:8]), .S(Oper[1:0]), .InpA(ADDout[11:8]), .InpB(ANDout[11:8]), .InpC(ORout[11:8]), .InpD(XORout[11:8]));
	quadmux4_1 stage1_3 (.Out(nonBarrelOpsOut[15:12]), .S(Oper[1:0]), .InpA(ADDout[15:12]), .InpB(ANDout[15:12]), .InpC(ORout[15:12]), .InpD(XORout[15:12]));

	// decide between shifting operations and non-shifting operations 
	assign Out = (Oper[2]) ? nonBarrelOpsOut : shifterout;

	// Zero: set high if Out is zero, otherwise 0
	assign Zero = (Out == 16'b0);
	
endmodule
