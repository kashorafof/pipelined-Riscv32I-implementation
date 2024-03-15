module Instruction_decoder (
    input wire [31:0] ID_Instruction_i,


    output wire Reg_wr_en_o, 
    output wire Jump_en_o,
    output wire Branch_en_o, 
    output wire Mem_wr_en_o, 
    output wire Load_sign_o, 
    output wire Rd_source_o,
    output wire isJALR_o,
    output wire isLUI_o

    output wire       ALU_src1_o, 
    output wire [1:0] ALU_src2_o,
    output wire [3:0] ALU_op_o, 

    output wire [2:0] Format_o, Memp_size_o, ComparitorOp_o,
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
  reg Reg_wr_en_i, ALU_src1, JumpE,
            BranchE, Mem_Write, Load_sign, Rd_source;
  reg [3:0] ALU_op; 
  reg [1:0] ALU_src2;
  reg [2:0] Format, Memp_size, ComparitorOp;
  reg isJALR, isLUI;

  assign Reg_wr_en_o = Reg_wr_en_i;
  assign ALU_src1_o = ALU_src1;
  assign Jump_en_o = JumpE;
  assign Branch_en_o = BranchE;
  assign Mem_wr_en_o = Mem_Write;
  assign Load_sign_o = Load_sign;
  assign Rd_source_o = Rd_source;
  assign ALU_op_o = ALU_op;
  assign ALU_src2_o = ALU_src2;
  assign Format_o = Format;
  assign Memp_size_o = Memp_size;
  assign ComparitorOp_o = ComparitorOp;
  assign isJALR_o = isJALR;
  assign isLUI_o = isLUI;
  

  always @(*) begin

    Mem_Write = `Read;
    BranchE = `No_branch;
    JumpE = `No_jump;
    Reg_wr_en_i = `Read;
    isJALR = 0;
    ComparitorOp = 0;
    isLUI = 0;

    case (Opcode)
      `OPCODE_R: begin
        Format <= `R_Format;
        ALU_src1 <= `ALU_source1_RS1;
        ALU_src2 <= `ALU_source2_RS2;
        Reg_wr_en_i <= `Write;
        Rd_source <= `Rd_source_ALU;

        case (Funct3)
          `F3_SLL:  ALU_op = `SLL;
          `F3_SLT:  ALU_op = `SLT;
          `F3_SLTU: ALU_op = `SLTU;
          `F3_XOR:  ALU_op = `XOR;
          `F3R:   ALU_op = `OR;
          `F3_AND:  ALU_op = `AND;

          `F3_SRL_SRA:
          if (Funct7 == `F7_SRL) ALU_op <= `SRL;
          else ALU_op <= `SRA;

          `F3_ADD_SUB:
          if (Funct7 == `F7_ADD) ALU_op <= `ADD;
          else ALU_op <= `SUB;

          default: $error("Not a valid Funct3!");
        endcase
      end

      `OPCODE_I: begin
        Format <= `I_Format;
        ALU_src1 <= `ALU_source1_RS1;
        ALU_src2 <= `ALU_source2_IMM;
        Reg_wr_en_i <= `Write;
        Rd_source <= `Rd_source_ALU;

        case (Funct3)
          `F3_ADDI:   ALU_op <= `ADD;
          `F3_SLTI:   ALU_op <= `SLT;
          `F3_SLTIU:  ALU_op <= `SLTU;
          `F3_XORI:   ALU_op <= `XOR;
          `F3RI:    ALU_op <= `OR;
          `F3_ANDI:   ALU_op <= `AND;
          `F3_SLLI:   ALU_op <= `SLL;
          `F3_SRLI_SRAI:
                  if (Funct7 == `F7_SRL)
                      ALU_op <= `SRL;
                  else
                      ALU_op <= `SRA;
          default: $error("Not a valid Funct3!");
        endcase
      end

      `OPCODE_LD: begin
        Format <= `I_Format;
        ALU_src1 <= `ALU_source1_RS1;
        ALU_src2 <= `ALU_source2_IMM;
        Reg_wr_en_i <= `Write;
        Rd_source <= `Rd_source_MEM;
        case (Funct3)
          `F3_LW:  Memp_size <= `Word;
          `F3_LB: begin
            Memp_size <= `Byte;
            Load_sign   <= `Signed;
          end
          `F3_LBU: begin
            Memp_size <= `Byte;
            Load_sign   <= `Unsigned;
          end
          `F3_LH: begin
            Memp_size <= `Half;
            Load_sign   <= `Signed;
          end
          `F3_LHU: begin
            Memp_size <= `Half;
            Load_sign   <= `Unsigned;
          end
          default: $error("Not a valid Funct3!");
        endcase
      end


      `OPCODE_S: begin
        Format <= `S_Format;
        ALU_src1 <= `ALU_source1_RS1;
        ALU_src2 <= `ALU_source2_IMM;
        Mem_Write <= `Write;
        case (Funct3)
          `F3_SW:  Memp_size = `Word;
          `F3_SB:  Memp_size = `Byte;
          `F3_SH:  Memp_size = `Half;
          default: $error("Not a valid Funct3!");
        endcase
      end

      `OPCODE_B: begin
        Format   <= `B_Format;
        BranchE  <= `Branch;
        case (Funct3)
          `F3_BEQ:  ComparitorOp <= `EQ;
          `F3_BNE:  ComparitorOp <= `NE;
          `F3_BLT:  ComparitorOp <= `LT;
          `F3_BGE:  ComparitorOp <= `GE;
          `F3_BLTU: ComparitorOp <= `LTU;
          `F3_BGEU: ComparitorOp <= `GEU;
          default:  $error("Not a valid Funct3!");
        endcase
      end

      `OPCODE_JAL: begin
        Format <= `J_Format;
        ALU_src1 <= `ALU_source1_PC;
        ALU_src2 <= `ALU_source2_4;
        JumpE <= `Jump;
        Reg_wr_en_i <= `Write;
        Rd_source <= `Rd_source_ALU;
      end

      `OPCODE_JALR: begin
        Format <= `I_Format;
        ALU_src1 <= `ALU_source1_RS1;
        ALU_src2 <= `ALU_source2_4;
        JumpE <= `Jump;
        Reg_wr_en_i <= `Write;
        Rd_source <= `Rd_source_ALU;
        isJALR <= 1;
      end


      `OPCODE_LUI: begin
        Format <= `U_Format;
        ALU_src1 <= `ALU_source1_RS1;  
        ALU_src2 <= `ALU_source2_IMM;  
        Reg_wr_en_i <= `Write;
        Rd_source <= `Rd_source_ALU;
        isLUI <= 1;
      end


      `OPCODE_AUIPC: begin
        Format <= `U_Format;
        ALU_src1 <= `ALU_source1_PC;
        ALU_src2 <= `ALU_source2_IMM;
        Reg_wr_en_i <= `Write;
        Rd_source <= `Rd_source_ALU;
      end

      default: $error("Not a valid OPCODE!");
    endcase

  end
endmodule
