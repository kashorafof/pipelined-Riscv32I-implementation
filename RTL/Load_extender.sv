module load_extender(
    input wire [31:0] Imm_in,
    input wire [1:0] Size,
    input wire sign,
    output reg [31:0] Imm_out
  );
  `include "../Definitions/Loader_definitions.vh"

  always @(*)
  case Size
    `Word: Imm_out = Imm_in;
    
    `Half:
      if (sign)
        Imm_out = { {16{Imm_in[15]}}, Imm_in[15:0] };
      else
        Imm_out = { {20{1'b0}}, Imm_in[15:0] };

    `Byte:
      if (sign)
        Imm_out = { {24{Imm_in[7]}}, Imm_in[7:0] };
      else
        Imm_out = { {24{1'b0}}, Imm_in[7:0] };

    default: Imm_out = 32'b0;
  endcase
    

endmodule