/*
    CS/ECE 552 FALL '24
    Homework #2, Problem 2
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the 'Oper' value that is passed in.  It uses these
    shifts to shift the value any number of bits.
 */
module shifter (In, ShAmt, Oper, Out);

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input  [OPERAND_WIDTH -1:0] In   ; // Input operand
    input  [SHAMT_WIDTH   -1:0] ShAmt; // Amount to shift/rotate
    input  [NUM_OPERATIONS-1:0] Oper ; // Operation type
    output [OPERAND_WIDTH -1:0] Out  ; // Result of shift/rotate

   /* YOUR CODE HERE */

	wire [15:0] rotatel_out;
	wire [15:0] shiftl_out;
	wire [15:0] shiftra_out;
	wire [15:0] shiftrl_out;

	// An instantiation of each function, input is fed into each but output is selected using mux
	rotatel oper_0 (.in(In), .shamt(ShAmt), .out(rotatel_out));
	shiftl oper_1 (.in(In), .shamt(ShAmt), .out(shiftl_out));
	shiftrarithmetic oper_2 (.in(In), .shamt(ShAmt), .out(shiftra_out));
	shiftrlogical oper_3 (.in(In), .shamt(ShAmt), .out(shiftrl_out));

	// control output to be taken from correct fucntion module 
	quadmux4_1 byte0 (.Out(Out[3:0]), .S(Oper), .InpA(rotatel_out[3:0]), .InpB(shiftl_out[3:0]), .InpC(shiftra_out[3:0]), .InpD(shiftrl_out[3:0]));
	quadmux4_1 byte1 (.Out(Out[7:4]), .S(Oper), .InpA(rotatel_out[7:4]), .InpB(shiftl_out[7:4]), .InpC(shiftra_out[7:4]), .InpD(shiftrl_out[7:4]));
	quadmux4_1 byte2 (.Out(Out[11:8]), .S(Oper), .InpA(rotatel_out[11:8]), .InpB(shiftl_out[11:8]), .InpC(shiftra_out[11:8]), .InpD(shiftrl_out[11:8]));
	quadmux4_1 byte3 (.Out(Out[15:12]), .S(Oper), .InpA(rotatel_out[15:12]), .InpB(shiftl_out[15:12]), .InpC(shiftra_out[15:12]), .InpD(shiftrl_out[15:12]));

endmodule
