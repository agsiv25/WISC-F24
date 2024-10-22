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

output wire jmpSel;

always @(brchSig) begin
   jmpSel = 1'b0;
   casex(brchSig)
      3'b010: begin // BEQ
         assign jumpSel = (zf == 1'b1) ? 1'b1 : 1'b0;
      end
      3'b101: begin // BNE
         assign jumpSel = (zf == 1'b0) ? 1'b1 : 1'b0;
      end
      3'b100: begin // BLT
         assign jumpSel = (sf == 1'b1) ? 1'b1 : 1'b0;
      end
      3'b011: begin // BGE
         assign jumpSel = (sf == 1'b0) ? 1'b1 : (zf == 1'b0) ? 1'b1 : 1'b0;
      end
      3'b110: begin // SLE
         assign jumpSel = (sf == 1'b1) ? 1'b1 : (zf == 1'b1) ? 1'b1 : 1'b0;
      end
      3'b001: begin // SCO
         assign jumpSel = (cf == 1'b1) ? 1'b1 : 1'b0;
      end
      default: begin
         jmpSel = 1'b0;
      end
   endcase
end


endmodule