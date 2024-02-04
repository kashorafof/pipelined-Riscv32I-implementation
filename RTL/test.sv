module Instruction_decoder
  `include "../Definitions/Format_definitions.svh"
  `include "../Definitions/Opcode_definitions.svh"
  `include "../Definitions/alu_definitions.svh" (
    input wire [31:0] Instruction,

    output reg Reg_writeE_o,
    ALU_src1_o,
    ALU_src2_o,
    JumpE_o,
    BranchE_o,
    Mem_Write_o,
    Load_sign_o,
    output reg [2:0] ALU_op_o,
    Mem_op_size_o,
    output reg [1:0] Rd_source_o,
    output reg [2:0] Format_o,
    output reg isJALR_o
);

  reg [6:0] Opcode;
  reg [2:0] Funct3;
  reg [6:0] Funct7;

  assign Opcode = Instruction[6:0];
  assign Funct3 = Instruction[14:12];
  assign Funct7 = Instruction[31:25];


  always @(*) begin

    Mem_Write_o = `Read;
    BranchE_o = `No_branch;
    JumpE_o = `No_jump;
    Reg_writeE_o = `Read;
    isJALR_o = 0;

    case Opcode
    
      
      `OPCODE_R: begin
          Format_o <= `R_Format; // don't care
          ALU_src1_o <= `ALU_source1_RS1;
          ALU_src2_o <= `ALU_source2_RS2;
          Reg_writeE_o <= `Write;
          Rd_source_o <= `Rd_source_ALU;

      end
  endcase
  end
endmodule
