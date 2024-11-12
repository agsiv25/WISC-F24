/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
// D-flipflop
`default_nettype none
module dff (Q, D, clk, rst);

    output wire        Q;
    input wire         D;
    input wire         clk;
    input wire         rst;

    reg            state;

    assign #(1) Q = state;

    always @(posedge clk) begin
      state = rst? 0 : D;
    end
endmodule
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
