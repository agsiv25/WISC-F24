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

	// 0000 rll Rotate left
	// 0001 sll Shift left logical
	// 0010 sra Shift right arithmetic
	// 0011 srl Shift right logical
	// 0100 ADD A+B
	// 0101 AND A AND B
	// 0110 OR A OR B
	// 0111 XOR A XOR B

	// Added Operations
	// 1000 SLBI 
	// 1001 BTR
	// 1010 rrl rotate right

	wire [15:0] Atouse;
	wire [15:0] Btouse;

	wire [15:0] nonBarrelOpsOut;

	wire [15:0] shifterout;

	wire [15:0] ADDout;
	wire [15:0] ANDout;
	wire [15:0] ORout;
	wire [15:0] XORout;

	wire [15:0] originalOpsOut;
	wire [15:0] addedOpsOut;

	// added operation wires
	wire [15:0] rotater_out;
	wire [15:0] slbi;
	wire [15:0] btr;
	wire [15:0] slbiBtrOut;

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

	// SLBI
	assign slbi = Atouse << 8;

	// BTR
	assign btr[0] = Atouse[15];
	assign btr[1] = Atouse[14];
	assign btr[2] = Atouse[13];
	assign btr[3] = Atouse[12];
	assign btr[4] = Atouse[11];
	assign btr[5] = Atouse[10];
	assign btr[6] = Atouse[9];
	assign btr[7] = Atouse[8];
	assign btr[8] = Atouse[7];
	assign btr[9] = Atouse[6];
	assign btr[10] = Atouse[5];
	assign btr[11] = Atouse[4];
	assign btr[12] = Atouse[3];
	assign btr[13] = Atouse[2];
	assign btr[14] = Atouse[1];
	assign btr[15] = Atouse[0];

	// rotate right 
	rotater oper_4 (.in(Atouse), .shamt(Btouse[3:0]), .out(rotater_out));

	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ OUTPUTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	// Out: use mux to decide between ADD, AND, OR or XOR. Then use ternary statement to decide between shifting operations and non-shifting operations 
	quadmux4_1 stage1_0 (.Out(nonBarrelOpsOut[3:0]), .S(Oper[1:0]), .InpA(ADDout[3:0]), .InpB(ANDout[3:0]), .InpC(ORout[3:0]), .InpD(XORout[3:0]));
	quadmux4_1 stage1_1 (.Out(nonBarrelOpsOut[7:4]), .S(Oper[1:0]), .InpA(ADDout[7:4]), .InpB(ANDout[7:4]), .InpC(ORout[7:4]), .InpD(XORout[7:4]));
	quadmux4_1 stage1_2 (.Out(nonBarrelOpsOut[11:8]), .S(Oper[1:0]), .InpA(ADDout[11:8]), .InpB(ANDout[11:8]), .InpC(ORout[11:8]), .InpD(XORout[11:8]));
	quadmux4_1 stage1_3 (.Out(nonBarrelOpsOut[15:12]), .S(Oper[1:0]), .InpA(ADDout[15:12]), .InpB(ANDout[15:12]), .InpC(ORout[15:12]), .InpD(XORout[15:12]));

	// decide between shifting operations and non-shifting operations 
	assign originalOpsOut = (Oper[2]) ? nonBarrelOpsOut : shifterout;

	// decide between SLBI and BTR
    assign slbiBtrOut = (Oper[0]) ? btr : slbi;

	// decide between SLBI / BTR and rrl
    assign addedOpsOut = (Oper[1]) ? rotater_out : slbiBtrOut;	

	// decide between original operations or new WISC_ISA operations 
	assign Out = (Oper[3]) ? addedOpsOut : originalOpsOut;

	// Zero: set high if Out is zero, otherwise 0
	assign Zero = (Out == 16'b0);
	
endmodule
