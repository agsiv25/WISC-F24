/*
    CS/ECE 552 FALL'22
    Homework #2, Problem 1
    
    a 4-bit CLA module
*/
module cla_4b(sum, c_out, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output [N-1:0] sum;
    output         c_out;
    input [N-1: 0] a, b;
    input          c_in;

    // YOUR CODE HERE

    wire bit0_c;
    wire bit1_c;
    wire bit2_c;

    fullAdder_1b bit0 (.s(sum[0]), .c_out(bit0_c), .a(a[0]), .b(b[0]), .c_in(c_in));
    fullAdder_1b bit1 (.s(sum[1]), .c_out(bit1_c), .a(a[1]), .b(b[1]), .c_in(bit0_c));
    fullAdder_1b bit2 (.s(sum[2]), .c_out(bit2_c), .a(a[2]), .b(b[2]), .c_in(bit1_c));
    fullAdder_1b bit3 (.s(sum[3]), .c_out(c_out), .a(a[3]), .b(b[3]), .c_in(bit2_c));

endmodule
