/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 1
    
    a 1-bit full adder
*/
module fullAdder_1b(s, c_out, a, b, c_in);
    output s;
    output c_out;
    input  a, b;
    input  c_in;

    // YOUR CODE HERE

    wire sumXOR;
    wire AB_nand;
    wire AB_Cin_nand;

    xor2 sum_xor_1 (.out(sumXOR), .in1(a), .in2(b));
    xor2 sum_xor_2 (.out(s), .in1(sumXOR), .in2(c_in));

    // finding Cout
    nand2 cout_nand_1 (.out(AB_nand), .in1(a), .in2(b));

    nand2 cout_nand_2 (.out(AB_Cin_nand), .in1(sumXOR), .in2(c_in));
    nand2 cout_nand_3 (.out(c_out), .in1(AB_Cin_nand), .in2(AB_nand));

endmodule
