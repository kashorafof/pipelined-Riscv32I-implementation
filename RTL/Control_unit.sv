module Control_unit (
    input wire [31:0] ID_Instruction_i,
    output reg Reg_writeE_o, ALU_src1_o,JumpE_o,
              BranchE_o, Mem_Write_o, Load_sign_o,
    output reg [2:0] ALU_op_o,
    Mem_op_size_o,
    output reg [1:0] Rd_source_o, ALU_src2_o,
    output reg [2:0] Format_o, Branch_condition_o,
    ComparitorOp_o,
    output reg isJALR_o, isLUI_o
);
  `include "../Definitions/Format_definitions.svh"
  `include "../Definitions/Opcode_definitions.svh"
  `include "../Definitions/alu_definitions.svh"
  `include "../Definitions/Memory_definitions.svh"
  `include "../Definitions/Branch_generator.svh"

  wire [6:0] Opcode;
  wire [2:0] Funct3;
  wire [6:0] Funct7;

  assign Opcode = ID_Instruction_i[6:0];
  assign Funct3 = ID_Instruction_i[14:12];
  assign Funct7 = ID_Instruction_i[31:25];


  always @(*) begin

    Mem_Write_o = `Read;
    BranchE_o = `No_branch;
    JumpE_o = `No_jump;
    Reg_writeE_o = `Read;
    isJALR_o = 0;
    ComparitorOp_o = 0;
    isLUI_o = 0;

    case (Opcode)
      `OPCODE_R: begin
        Format_o <= `R_Format;
        ALU_src1_o <= `ALU_source1_RS1;
        ALU_src2_o <= `ALU_source2_RS2;
        Reg_writeE_o <= `Write;
        Rd_source_o <= `Rd_source_ALU;

        case (Funct3)
          `F3_SLL:  ALU_op_o = `SLL;
          `F3_SLT:  ALU_op_o = `SLT;
          `F3_SLTU: ALU_op_o = `SLTU;
          `F3_XOR:  ALU_op_o = `XOR;
          `F3_OR:   ALU_op_o = `OR;
          `F3_AND:  ALU_op_o = `AND;

          `F3_SRL_SRA:
          if (Funct7 == `F7_SRL) ALU_op_o <= `SRL;
          else ALU_op_o <= `SRA;

          `F3_ADD_SUB:
          if (Funct7 == `F7_ADD) ALU_op_o <= `ADD;
          else ALU_op_o <= `SUB;

          default: $error("Not a valid Funct3!");
        endcase
      end

      `OPCODE_I: begin
        Format_o <= `I_Format;
        ALU_src1_o <= `ALU_source1_RS1;
        ALU_src2_o <= `ALU_source2_IMM;
        Reg_writeE_o <= `Write;
        Rd_source_o <= `Rd_source_ALU;

        case (Funct3)
          `F3_ADDI:   ALU_op_o <= `ADD;
          `F3_SLTI:   ALU_op_o <= `SLT;
          `F3_SLTIU:  ALU_op_o <= `SLTU;
          `F3_XORI:   ALU_op_o <= `XOR;
          `F3_ORI:    ALU_op_o <= `OR;
          `F3_ANDI:   ALU_op_o <= `AND;
          `F3_SLLI:   ALU_op_o <= `SLL;
          `F3_SRLI_SRAI:
                  if (Funct7 == `F7_SRL)
                      ALU_op_o <= `SRL;
                  else
                      ALU_op_o <= `SRA;
          default: $error("Not a valid Funct3!");
        endcase
      end

      `OPCODE_LD: begin
        Format_o <= `I_Format;
        ALU_src1_o <= `ALU_source1_RS1;
        ALU_src2_o <= `ALU_source2_IMM;
        Reg_writeE_o <= `Write;
        Rd_source_o <= `Rd_source_MEM;
        case (Funct3)
          `F3_LW:  Mem_op_size_o <= `Word;
          `F3_LB: begin
            Mem_op_size_o <= `Byte;
            Load_sign_o   <= `Signed;
          end
          `F3_LBU: begin
            Mem_op_size_o <= `Byte;
            Load_sign_o   <= `Unsigned;
          end
          `F3_LH: begin
            Mem_op_size_o <= `Half;
            Load_sign_o   <= `Signed;
          end
          `F3_LHU: begin
            Mem_op_size_o <= `Half;
            Load_sign_o   <= `Unsigned;
          end
          default: $error("Not a valid Funct3!");
        endcase
      end


      `OPCODE_S: begin
        Format_o <= `S_Format;
        ALU_src1_o <= `ALU_source1_RS1;
        ALU_src2_o <= `ALU_source2_IMM;
        Mem_Write_o <= `Write;
        case (Funct3)
          `F3_SW:  Mem_op_size_o = `Word;
          `F3_SB:  Mem_op_size_o = `Byte;
          `F3_SH:  Mem_op_size_o = `Half;
          default: $error("Not a valid Funct3!");
        endcase
      end

      `OPCODE_B: begin
        Format_o   <= `B_Format;
        BranchE_o  <= `Branch;
        case (Funct3)
          `F3_BEQ:  Branch_condition_o <= `EQ;
          `F3_BNE:  Branch_condition_o <= `NE;
          `F3_BLT:  Branch_condition_o <= `LT;
          `F3_BGE:  Branch_condition_o <= `GE;
          `F3_BLTU: Branch_condition_o <= `LTU;
          `F3_BGEU: Branch_condition_o <= `GEU;
          default:  $error("Not a valid Funct3!");
        endcase
      end

      `OPCODE_JAL: begin
        Format_o <= `J_Format;
        ALU_src1_o <= `ALU_source1_PC;
        ALU_src2_o <= `ALU_source2_4;
        JumpE_o <= `Jump;
        Reg_writeE_o <= `Write;
        Rd_source_o <= `Rd_source_ALU;
      end

      `OPCODE_JALR: begin
        Format_o <= `I_Format;
        ALU_src1_o <= `ALU_source1_RS1;
        ALU_src2_o <= `ALU_source2_4;
        JumpE_o <= `Jump;
        Reg_writeE_o <= `Write;
        Rd_source_o <= `Rd_source_ALU;
        isJALR_o <= 1;
      end


      `OPCODE_LUI: begin
        Format_o <= `U_Format;
        ALU_src1_o <= `ALU_source1_RS1;  
        ALU_src2_o <= `ALU_source2_IMM;  
        Reg_writeE_o <= `Write;
        Rd_source_o <= `Rd_source_ALU;
        isLUI_o <= 1;
      end


      `OPCODE_AUIPC: begin
        Format_o <= `U_Format;
        ALU_src1_o <= `ALU_source1_PC;
        ALU_src2_o <= `ALU_source2_IMM;
        Reg_writeE_o <= `Write;
        Rd_source_o <= `Rd_source_ALU;
      end

      default: $error("Not a valid OPCODE!");
    endcase

  end
endmodule
