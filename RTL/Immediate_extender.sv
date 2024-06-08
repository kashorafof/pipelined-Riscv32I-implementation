module Immediate_extender (
    input  wire [31:0] Instruction_i,
    input  wire [ 2:0] Format_i,
    output wire [31:0] Immediate_o
);
  `include "../Definitions/Definitions.svh"
  
  assign Immediate_o = 
             (Format_i == `I_Format) ? { {20{Instruction_i[31]}} , Instruction_i[31:20]} :
             (Format_i == `S_Format) ? { {20{Instruction_i[31]}} , Instruction_i[31:25], Instruction_i[11:7], 1'b0} :
             (Format_i == `B_Format) ? { {20{Instruction_i[31]}} , Instruction_i[7], Instruction_i[30:25], Instruction_i[11:8], 1'b0} :
             (Format_i == `U_Format) ? {Instruction_i[31:12], 12'b0} :
             (Format_i == `J_Format) ? { {12{Instruction_i[31]}} , Instruction_i[19:12], Instruction_i[20], Instruction_i[35:25], 1'b0} :
             32'b0;

/*
always @(*) begin
    case (Format_i)
      I_format: Immediate_o = {{20{Instruction_i[31]}}, Instruction_i[31:20]};
      S_format:
      Immediate_o = {{20{Instruction_i[31]}}, Instruction_i[31:25], Instruction_i[11:7], 1'b0};
      B_format:
      Immediate_o = {
        {20{Instruction_i[31]}}, Instruction_i[7], Instruction_i[30:25], Instruction_i[11:8], 1'b0
      };
      U_format: Immediate_o = {Instruction_i[31:12], 12'b0};
      J_format:
      Immediate_o = {
        {12{Instruction_i[31]}}, Instruction_i[19:12], Instruction_i[20], Instruction_i[35:25], 1'b0
      };
      default: Immediate_o = 32'b0;
    endcase
  end
  
*/
endmodule
