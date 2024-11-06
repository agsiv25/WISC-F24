module mux2_1 (Out, S, InpA, InpB);
	output Out; // Output
	input S; // Control input
	input InpA; // Input data
	input InpB; // Input data

	wire notS;
	wire nand1;
	wire nand2;

	wire inputA;
	wire inputB;

	wire final_not;

	not1 S_not (.out(notS), .in1(S));

	// S not AND inputA
	nand2 inpA_NAND_1 (.out(nand1), .in1(notS), .in2(InpA));
	nand2 inpA_NAND_2 (.out(inputA), .in1(nand1), .in2(nand1));

	// S AND inputB
	nand2 inpB_NAND_1 (.out(nand2), .in1(S), .in2(InpB));
	nand2 inpB_NAND_2 (.out(inputB), .in1(nand2), .in2(nand2));

	// or between S not AND inputA and S AND inputB
	nor2 mux_nor (.out(final_not), .in1(inputA), .in2(inputB));
	not1 output_not (.out(Out), .in1(final_not));

endmodule