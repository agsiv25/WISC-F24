/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 1
    
    a 16-bit CLA module
*/
module cla_16b(sum, c_out, ofl, a, b, c_in, sign);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    output [N-1:0] sum;
    output         c_out;
    output	   ofl; // overflow flag
    input [N-1: 0] a, b;
    input          c_in;
    input	   sign;

    // YOUR CODE HERE
    
    wire byte0_c;
    wire byte1_c;
    wire byte2_c;

    cla_4b byte0 (.sum(sum[3:0]), .c_out(byte0_c), .a(a[3:0]), .b(b[3:0]), .c_in(c_in));
    cla_4b byte1 (.sum(sum[7:4]), .c_out(byte1_c), .a(a[7:4]), .b(b[7:4]), .c_in(byte0_c));
    cla_4b byte2 (.sum(sum[11:8]), .c_out(byte2_c), .a(a[11:8]), .b(b[11:8]), .c_in(byte1_c));
    cla_4b byte3 (.sum(sum[15:12]), .c_out(c_out), .a(a[15:12]), .b(b[15:12]), .c_in(byte2_c));

    assign ofl = (sign & ((a[15] == b[15]) & (a[15] != sum[15])) | (~sign & c_out));

endmodule
