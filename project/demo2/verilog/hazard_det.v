/*
   CS/ECE 552 Spring '22
  
   Filename        : hazard_det.v
   Description     : This is the module that detects data hazards and stalls the processor if one is detected.
*/
`default_nettype none
module hazard_det (rst, clk, fetch_inst, next_inst);

// registers to hold 4 instructions
reg16 instruction1(.readData(instruction1), .err(), .clk(clk), .rst(rst), .writeData(fetch_inst), .writeEn(1'b1));
reg16 instruction2(.readData(instruction2), .err(), .clk(clk), .rst(rst), .writeData(instruction1), .writeEn(1'b1));
reg16 instruction3(.readData(instruction3), .err(), .clk(clk), .rst(rst), .writeData(instruction2), .writeEn(1'b1));
reg16 instruction4(.readData(instruction4), .err(), .clk(clk), .rst(rst), .writeData(instruction3), .writeEn(1'b1));

// hazard detection unit


endmodule
`default_nettype wire