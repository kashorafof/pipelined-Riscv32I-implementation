module Instruction_decoder (
    input wire [31:0] ID_Instruction_i,

    output reg Reg_wr_en_o, 
    output reg Jump_en_o,
    output reg Branch_en_o, 
    output reg Mem_wr_en_o, 
    output reg Load_sign_o, 
    output reg Rd_source_o,
    output reg isJALR_o,
    output reg isLUI_o,

    output reg       ALU_src1_o, 
    output reg [1:0] ALU_src2_o,
    output reg [3:0] ALU_op_o, 

    output reg [2:0] Format_o, ComparitorOp_o,
    output reg [1:0] Mem_op_size_o
);
  `include "../Definitions/Definitions.svh"


  wire [6:0] Opcode;
  wire [2:0] Funct3;
  wire [6:0] Funct7;
  assign Opcode = ID_Instruction_i[6:0];
  assign Funct3 = ID_Instruction_i[14:12];
  assign Funct7 = ID_Instruction_i[31:25];

  

  always @(*) begin

    Mem_wr_en_o = `Read;
    Branch_en_o = `No_branch;
    Jump_en_o = `No_jump;
    Reg_wr_en_o= `Read;
    isJALR_o = 0;
    ComparitorOp_o= 0;
    isLUI_o= 0;

    case (Opcode)
      `OPCODE_R: begin
        Format_o <= `R_Format;
        ALU_src1_o  <= `ALU_source1_RS1;
        ALU_src2_o  <= `ALU_source2_RS2;
        Reg_wr_en_o <= `Write;
        Rd_source_o <= `Rd_source_ALU;

        case (Funct3)
          `F3_SLL:  ALU_op_o = `ALU_SLL;
          `F3_SLT:  ALU_op_o = `ALU_SLT;
          `F3_SLTU: ALU_op_o = `ALU_SLTU;
          `F3_XOR:  ALU_op_o = `ALU_XOR;
          `F3_OR:   ALU_op_o = `ALU_OR;
          `F3_AND:  ALU_op_o = `ALU_AND;

          `F3_SRL_SRA:
          if (Funct7 == `F7_SRL) ALU_op_o <= `ALU_SRL;
          else ALU_op_o <= `ALU_SRA;

          `F3_ADD_SUB:
          if (Funct7 == `F7_ADD) ALU_op_o <= `ALU_ADD;
          else ALU_op_o <= `ALU_SUB;

          default: $error("Not a valid Funct3!");
        endcase
      end

      `OPCODE_I: begin
        Format_o <= `I_Format;
        ALU_src1_o  <= `ALU_source1_RS1;
        ALU_src2_o  <= `ALU_source2_IMM;
        Reg_wr_en_o <= `Write;
        Rd_source_o <= `Rd_source_ALU;

        case (Funct3)
          `F3_ADDI:   ALU_op_o <= `ALU_ADD;
          `F3_SLTI:   ALU_op_o <= `ALU_SLT;
          `F3_SLTIU:  ALU_op_o <= `ALU_SLTU;
          `F3_XORI:   ALU_op_o <= `ALU_XOR;
          `F3_ORI:    ALU_op_o <= `ALU_OR;
          `F3_ANDI:   ALU_op_o <= `ALU_AND;
          `F3_SLLI:   ALU_op_o <= `ALU_SLL;
          `F3_SRLI_SRAI:
                  if (Funct7 == `F7_SRL)
                      ALU_op_o <= `ALU_SRL;
                  else
                      ALU_op_o <= `ALU_SRA;
          default: $error("Not a valid Funct3!");
        endcase
      end

      `OPCODE_LD: begin
        Format_o <= `I_Format;
        ALU_src1_o  <= `ALU_source1_RS1;
        ALU_src2_o  <= `ALU_source2_IMM;
        Reg_wr_en_o <= `Write;
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
        ALU_src1_o  <= `ALU_source1_RS1;
        ALU_src2_o  <= `ALU_source2_IMM;
        Mem_wr_en_o <= `Write;
        case (Funct3)
          `F3_SW:  Mem_op_size_o = `Word;
          `F3_SB:  Mem_op_size_o = `Byte;
          `F3_SH:  Mem_op_size_o = `Half;
          default: $error("Not a valid Funct3!");
        endcase
      end

      `OPCODE_B: begin
        Format_o   <= `B_Format;
        Branch_en_o  <= `Branch;
        case (Funct3)
          `F3_BEQ:  ComparitorOp_o <= `EQ;
          `F3_BNE:  ComparitorOp_o  <= `NE;
          `F3_BLT:  ComparitorOp_o <= `LT;
          `F3_BGE:  ComparitorOp_o <= `GE;
          `F3_BLTU: ComparitorOp_o <= `LTU;
          `F3_BGEU: ComparitorOp_o <= `GEU;
          default:  $error("Not a valid Funct3!");
        endcase
      end

      `OPCODE_JAL: begin
        Format_o <= `J_Format;
        ALU_src1_o  <= `ALU_source1_PC;
        ALU_src2_o  <= `ALU_source2_4;
        Jump_en_o <= `Jump;
        Reg_wr_en_o <= `Write;
        Rd_source_o <= `Rd_source_ALU;
      end

      `OPCODE_JALR: begin
        Format_o <= `I_Format;
        ALU_src1_o  <= `ALU_source1_RS1;
        ALU_src2_o  <= `ALU_source2_4;
        Jump_en_o <= `Jump;
        Reg_wr_en_o <= `Write;
        Rd_source_o <= `Rd_source_ALU;
        isJALR_o <= 1;
      end


      `OPCODE_LUI: begin
        Format_o <= `U_Format;
        ALU_src1_o  <= `ALU_source1_RS1;  
        ALU_src2_o  <= `ALU_source2_IMM;  
        Reg_wr_en_o <= `Write;
        Rd_source_o <= `Rd_source_ALU;
        isLUI_o<= 1;
      end


      `OPCODE_AUIPC: begin
        Format_o <= `U_Format;
        ALU_src1_o  <= `ALU_source1_PC;
        ALU_src2_o  <= `ALU_source2_IMM;
        Reg_wr_en_o <= `Write;
        Rd_source_o <= `Rd_source_ALU;
      end

      default: $error("Not a valid OPCODE!");
    endcase

  end
endmodule
