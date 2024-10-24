/*
   CS/ECE 552 Spring '22
  
   Filename        : branch_conditional.v
   Description     : This is the module that decodes the ALU flags in conjunction with the control module signal to determine if branch conditions are met. 
*/
module branch_conditional (brchSig, sf, zf, of, cf, jmpSel);

input wire [2:0] brchSig;
input wire sf;
input wire zf;
input wire of;
input wire cf;

output reg jmpSel;

always @(brchSig) begin
   jmpSel = 1'b0;
   casex(brchSig)
      3'b010: begin // BEQ
         jmpSel = (zf == 1'b1) ? 1'b1 : 1'b0;
      end
      3'b101: begin // BNE
         jmpSel = (zf == 1'b0) ? 1'b1 : 1'b0;
      end
      3'b100: begin // BLT
         jmpSel = sf;
         $display("The value of signFlag in branch conditional is: %d", sf);
      end
      3'b011: begin // BGE
         jmpSel = (sf == 1'b0) ? 1'b1 : 1'b0;
      end
      3'b110: begin // SLE
         jmpSel = (sf == 1'b1) ? 1'b1 : (zf == 1'b1) ? 1'b1 : 1'b0;
      end
      3'b001: begin // SCO
         jmpSel = (cf == 1'b1) ? 1'b1 : 1'b0;
      end
      3'b111: begin // Jump/SLBI
         jmpSel = 1'b1;
      end
      default: begin
         jmpSel = 1'b0;
      end
   endcase
end


endmodule