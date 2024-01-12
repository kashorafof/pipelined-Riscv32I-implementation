module Immediate_extender (
    input  wire [32:0] Instruction,
    input  wire [ 2:0] Format,
    output reg  [31:0] Imm_out
);
  `include "../Definitions/Imm_definitions.vh"

  always @(*) begin
    case (Format)
      I_format: Imm_out = {{20{Imm_in[31]}}, Imm_in[31:20]};
      S_format: Imm_out = {{20{Imm_in[31]}}, Imm_in[31:25], Imm_in[11:7], 1'b0};
      B_format: Imm_out = {{20{Imm_in[31]}}, Imm_in[7], Imm_in[30:25], Imm_in[11:8], 1'b0};
      U_format: Imm_out = {Imm_in[31:12], 12'b0};
      J_format: Imm_out = {{12{Imm_in[31]}}, Imm_in[19:12], Imm_in[20], Imm_in[35:25], 1'b0};
      default:  Imm_out = 32'b0;
    endcase
  end

endmodule
