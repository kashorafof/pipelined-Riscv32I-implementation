module Instruction_decoder(
    input wire [31:0] Instruction,
    output reg Reg_write, ALU_src1, ALU_src2, JumpE, BranchE, MemWrite, Load_sign,
    output reg [2:0] ALU_op, Mem_op_size, Rd_source,
    output reg [2:0] Format,    
  );
  `include "../Definitions/Opcode_definitions.vh"
  `include "../Definitions/Format_definitions.vh"
  `include "../Definitions/alu_definitions.vh"

  reg [6:0] Opcode;
  reg [2:0] Funct3;
  reg [6:0] Funct7;

  assign Opcode = Instruction[6:0];
  assign Funct3 = Instruction[14:12];
  assign Funct7 = Instruction[31:25];


  always @(*) begin

    MemWrite = `No_write;
    BranchE = `No_branch;
    JumpE = `No_jump;
    Reg_write = `No_write;

    case Opcode
    
      
      `OPCODE_R: begin
          Format <= `R_format;
          ALU_src1 <= `ALU_source1_RS1;
          ALU_src2 <= `ALU_source2_RS2;
          Reg_write <= `Write;
          Rd_source <= `Rd_source_ALU;

          case Funct3
              `F3_SLL:    ALU_op <= `SLL;
              `F3_SLT:    ALU_op <= `SLT;
              `F3_SLTU:   ALU_op <= `SLTU;
              `F3_XOR:    ALU_op <= `XOR;
              `F3_OR:     ALU_op <= `OR;
              `F3_AND:    ALU_op <= `AND;
              
              `F3_SRL_SRA:
                  if (Funct7 == `F7_SRL)
                      ALU_op <= `SRL;
                  else
                      ALU_op <= `SRA;
                      
              `F3_ADD_SUB:
              if (Funct7 == `F7_ADD)
                  ALU_op <= `ADD;
              else
                  ALU_op <= `SUB;

              default: ALU_op = `Unknown_op;  //! need to put an exception
          endcase
      end

      `OPCODE_I: begin
          Format <= `I_format;
          ALU_src1 <= `ALU_source1_RS1;
          ALU_src2 <= `ALU_source2_IMM;
          Reg_write <= `Write;
          Rd_source <= `Rd_source_ALU;

          case Funct3
              `F3_ADDI:   ALU_op <= `ADD;
              `F3_SLTI:   ALU_op <= `SLT;
              `F3_SLTIU:  ALU_op <= `SLTU;
              `F3_XORI:   ALU_op <= `XOR;
              `F3_ORI:    ALU_op <= `OR;
              `F3_ANDI:   ALU_op <= `AND;
              `F3_SLLI:   ALU_op <= `SLL;
              `F3_SRLI_SRAI:
                  if (Funct7 == `F7_SRLI)
                      ALU_op <= `SRL;
                  else
                      ALU_op <= `SRA;
              default: ALU_op = `Unknown_op;  //! need to put an exception
          endcase
      end

      `OPCODE_LD: begin
          Format <= `I_format;
          ALU_src1 <= `ALU_source1_RS1;
          ALU_src2 <= `ALU_source2_IMM;
          Reg_write <= `Write;
          Rd_source <= `Rd_source_MEM;
          case Funct3
              `F3_LW:     Mem_op_size <= `Word;
              `F3_LB:  begin
                  Mem_op_size <= `Byte;
                  Load_sign <= `Signed;
              end
              `F3_LBU: begin
                  Mem_op_size <= `ByteU;
                  Load_sign <= `Unsigned;
              end
              `F3_LH:  begin
                  Mem_op_size <= `Half;
                  Load_sign <= `Signed;
              end
              `F3_LHU: begin
                  Mem_op_size <= `Half;
                  Load_sign <= `Unsigned;
              end
              default: ALU_op <= `Unknown_op;  //! need to put an exception
          endcase
      end

      
      `OPCODE_S: 
      begin
          Format <= `S_format;
          ALU_src1 <= `ALU_source1_RS1;
          ALU_src2 <= `ALU_source2_IMM;
          MemWrite <= `Write;
          case Funct3
              `F3_SW:     Mem_op_size = `Word;
              `F3_SB:     Mem_op_size = `Byte;
              `F3_SH:     Mem_op_size = `Half;
              default: ALU_op = `Unknown_op;  //! need to put an exception
          endcase
      end

      `OPCODE_B:
      begin
          Format <= `B_format;
          ALU_src1 <= `ALU_source1_RS1;
          ALU_src2 <= `ALU_source2_RS2;
          BranchE <= `Branch;
          case Funct3
              `F3_BEQ:    ALU_op <= `EQ;
              `F3_BNE:    ALU_op <= `NE;
              `F3_BLT:    ALU_op <= `LT;
              `F3_BGE:    ALU_op <= `GE;
              `F3_BLTU:   ALU_op <= `LTU;
              `F3_BGEU:   ALU_op <= `GEU;
              default: ALU_op <= `Unknown_op;  //! need to put an exception
          endcase
      end

      `OPCODE_JAL:
      begin
          Format <= `J_format;
          ALU_src1 <= `ALU_source1_PC;
          ALU_src2 <= `ALU_source2_IMM;
          JumpE <= `Jump;
          Reg_write <= `Write;
          Rd_source <= `Rd_source_PC;
      end

      `OPCODE_JALR:
      begin
          Format <= `I_format;
          ALU_src1 <= `ALU_source1_RS1;
          ALU_src2 <= `ALU_source2_IMM;
          JumpE <= `Jump;
          Reg_write <= `Write;
          Rd_source <= `Rd_source_PC;
      end


      `OPCODE_LUI:
      begin
          Format ,= `U_format;
          ALU_src1 <= `ALU_source1_RS1; // X
          ALU_src2 <= `ALU_source2_IMM; // X
          Reg_write <= `Write;
          Rd_source <= `RD_source_IMM;           
      end


      `OPCODE_AUIPC:
      begin
          Format <= `U_format;
          ALU_src1 <= `ALU_source1_PC; 
          ALU_src2 <= `ALU_source2_IMM; 
          Reg_write <= `Write;
          Rd_source <= `Rd_source_ALU;
      end

      default: Format = `Unknown_format;  //! need to put an exception
    endcase

  end
endmodule