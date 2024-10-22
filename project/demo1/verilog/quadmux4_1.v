module quadmux4_1 (Out, S, InpA, InpB, InpC, InpD);
	output [3:0] Out; // Output
	input [1:0] S; // Control input
	input [3:0] InpA; // Input data
	input [3:0] InpB; // Input data
	input [3:0] InpC; // Input data
	input [3:0] InpD; // Input data

	wire stage1_1_bit0;
	wire stage1_2_bit0;
	wire stage1_1_bit1;
	wire stage1_2_bit1;
	wire stage1_1_bit2;
	wire stage1_2_bit2;
	wire stage1_1_bit3;
	wire stage1_2_bit4;

	// stage 1, breaks Inp into 2 branches for each bit of input

	mux2_1 stage1_1bit0 (.Out(stage1_1_bit0), .S(S[0]), .InpA(InpA[0]), .InpB(InpB[0]));
	mux2_1 stage1_1bit1 (.Out(stage1_1_bit1), .S(S[0]), .InpA(InpA[1]), .InpB(InpB[1]));
	mux2_1 stage1_1bit2 (.Out(stage1_1_bit2), .S(S[0]), .InpA(InpA[2]), .InpB(InpB[2]));
	mux2_1 stage1_1bit3 (.Out(stage1_1_bit3), .S(S[0]), .InpA(InpA[3]), .InpB(InpB[3]));

	mux2_1 stage1_2bit0 (.Out(stage1_2_bit0), .S(S[0]), .InpA(InpC[0]), .InpB(InpD[0]));
	mux2_1 stage1_2bit1 (.Out(stage1_2_bit1), .S(S[0]), .InpA(InpC[1]), .InpB(InpD[1]));
	mux2_1 stage1_2bit2 (.Out(stage1_2_bit2), .S(S[0]), .InpA(InpC[2]), .InpB(InpD[2]));
	mux2_1 stage1_2bit3 (.Out(stage1_2_bit3), .S(S[0]), .InpA(InpC[3]), .InpB(InpD[3]));

	// stage 2, takes branches from stage 1
	mux2_1 stage2_1 (.Out(Out[0]), .S(S[1]), .InpA(stage1_1_bit0), .InpB(stage1_2_bit0));
	mux2_1 stage2_2 (.Out(Out[1]), .S(S[1]), .InpA(stage1_1_bit1), .InpB(stage1_2_bit1));
	mux2_1 stage2_3 (.Out(Out[2]), .S(S[1]), .InpA(stage1_1_bit2), .InpB(stage1_2_bit2));
	mux2_1 stage2_4 (.Out(Out[3]), .S(S[1]), .InpA(stage1_1_bit3), .InpB(stage1_2_bit3));

endmodule