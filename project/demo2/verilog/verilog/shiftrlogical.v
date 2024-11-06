/*
    CS/ECE 552 FALL '24
    Homework #2, Problem 2
    
    A shift right logical module.
 */
module shiftrlogical (in, shamt, out);

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input  [OPERAND_WIDTH -1:0] in   ; // Input operand
    input  [SHAMT_WIDTH   -1:0] shamt; // Amount to shift/rotate
    output [OPERAND_WIDTH -1:0] out  ; // Result of shift/rotate

   /* YOUR CODE HERE */

	wire [15:0] shift1, shift2, shift4;

	// for shift right arithmetic: LSBs are shifted right [shamt] positions, MSBs are filled with MSB of input. 

	// shift right 1 bit 
	quadmux4_1 shift1_byte0 (.Out(shift1[3:0]), .S({1'b0, shamt[0]}), .InpA(in[3:0]), .InpB(in[4:1]), .InpC(4'b0), .InpD(4'b0));
	quadmux4_1 shift1_byte1 (.Out(shift1[7:4]), .S({1'b0, shamt[0]}), .InpA(in[7:4]), .InpB(in[8:5]), .InpC(4'b0), .InpD(4'b0));
	quadmux4_1 shift1_byte2 (.Out(shift1[11:8]), .S({1'b0, shamt[0]}), .InpA(in[11:8]), .InpB(in[12:9]), .InpC(4'b0), .InpD(4'b0));
	quadmux4_1 shift1_byte3 (.Out(shift1[15:12]), .S({1'b0, shamt[0]}), .InpA(in[15:12]), .InpB({1'b0, in[15:13]}), .InpC(4'b0), .InpD(4'b0));

	// shift right 2 bits 
	quadmux4_1 shift2_byte0 (.Out(shift2[3:0]), .S({1'b0, shamt[1]}), .InpA(shift1[3:0]), .InpB(shift1[5:2]), .InpC(4'b0), .InpD(4'b0));
	quadmux4_1 shift2_byte1 (.Out(shift2[7:4]), .S({1'b0, shamt[1]}), .InpA(shift1[7:4]), .InpB(shift1[9:6]), .InpC(4'b0), .InpD(4'b0));
	quadmux4_1 shift2_byte2 (.Out(shift2[11:8]), .S({1'b0, shamt[1]}), .InpA(shift1[11:8]), .InpB(shift1[13:10]), .InpC(4'b0), .InpD(4'b0));
	quadmux4_1 shift2_byte3 (.Out(shift2[15:12]), .S({1'b0, shamt[1]}), .InpA(shift1[15:12]), .InpB({2'b0, shift1[15:14]}), .InpC(4'b0), .InpD(4'b0));

	// shift right 4 bits 
	quadmux4_1 shift4_byte0 (.Out(shift4[3:0]), .S({1'b0, shamt[2]}), .InpA(shift2[3:0]), .InpB(shift2[7:4]), .InpC(4'b0), .InpD(4'b0));
	quadmux4_1 shift4_byte1 (.Out(shift4[7:4]), .S({1'b0, shamt[2]}), .InpA(shift2[7:4]), .InpB(shift2[11:8]), .InpC(4'b0), .InpD(4'b0));
	quadmux4_1 shift4_byte2 (.Out(shift4[11:8]), .S({1'b0, shamt[2]}), .InpA(shift2[11:8]), .InpB(shift2[15:12]), .InpC(4'b0), .InpD(4'b0));
	quadmux4_1 shift4_byte3 (.Out(shift4[15:12]), .S({1'b0, shamt[2]}), .InpA(shift2[15:12]), .InpB(4'b0), .InpC(4'b0), .InpD(4'b0));

	// shift right 8 bits 
	quadmux4_1 shift8_byte0 (.Out(out[3:0]), .S({1'b0, shamt[3]}), .InpA(shift4[3:0]), .InpB(shift4[11:8]), .InpC(4'b0), .InpD(4'b0));
	quadmux4_1 shift8_byte1 (.Out(out[7:4]), .S({1'b0, shamt[3]}), .InpA(shift4[7:4]), .InpB(shift4[15:12]), .InpC(4'b0), .InpD(4'b0));
	quadmux4_1 shift8_byte2 (.Out(out[11:8]), .S({1'b0, shamt[3]}), .InpA(shift4[11:8]), .InpB(4'b0), .InpC(4'b0), .InpD(4'b0));
	quadmux4_1 shift8_byte3 (.Out(out[15:12]), .S({1'b0, shamt[3]}), .InpA(shift4[15:12]), .InpB(4'b0), .InpC(4'b0), .InpD(4'b0));

endmodule