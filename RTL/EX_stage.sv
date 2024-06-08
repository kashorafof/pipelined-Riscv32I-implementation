module EX_stage(
  input wire clk_i, rst_i,
  input wire ID_ALU_src1_i,
  input wire [1:0] ID_ALU_src2_i,
  input wire [4:0] ID_rd_i,
  input wire ID_rd_wr_en_i,
  input wire [1:0] ID_rd_src_i,
  input wire [31:0] ID_read_rs1_i, ID_read_rs2_i, ID_imm_i, ID_PC_i,
  input wire [3:0] ID_ALU_op_i,
  input wire [2:0] ID_mem_op_size_i,
  input wire ID_mem_wr_en_i,
  input wire ID_Ld_sgn_i,
  

  output reg [31:0] EX_ALU_res_o,
  output reg [4:0] EX_rd_o, 
  output reg EX_rd_wr_en_o,
  output reg [1:0] EX_rd_src_o,
  output reg [1:0] EX_mem_op_size_o,
  output reg EX_mem_wr_en_o,
  output reg EX_Ld_sgn_o,  
  output reg [31:0] EX_read_rs2_o
);
  `include "../Definitions/Definitions.svh"

  wire [31:0] EX_ALU_result, OperandA, OperandB;
  assign OperandA = (ID_ALU_src1_i == `ALU_source1_RS1 ) ? ID_read_rs1_i : ID_PC_i;

  assign OperandB = (ID_ALU_src2_i == `ALU_source2_RS2) ? ID_read_rs2_i : 
                    (ID_ALU_src2_i == `ALU_source2_IMM) ? ID_imm_i : 32'b100;

  ALU ALU_inst(
    .Op_i(ID_ALU_op_i),
    .InA_i(OperandA),
    .InB_i(OperandB),
    .Result_o(EX_ALU_result)
  );

  always @(posedge clk_i) begin
    if(rst_i) begin
      EX_ALU_res_o <= 32'b0;
      EX_rd_o <= 5'b0;
      EX_rd_wr_en_o <= 1'b0;
      EX_rd_src_o <= 2'b0;
      EX_mem_op_size_o <= 2'b0;
      EX_mem_wr_en_o <= 1'b0;
      EX_Ld_sgn_o <= 1'b0;
      EX_read_rs2_o <= 32'b0;
    end else begin
      // Pass the result
      EX_ALU_res_o <= EX_ALU_result;
      // Pass the control signals
      EX_rd_o <= ID_rd_i;
      EX_rd_wr_en_o <= ID_rd_wr_en_i;
      EX_rd_src_o <= ID_rd_src_i;
      EX_mem_op_size_o <= ID_mem_op_size_i;
      EX_mem_wr_en_o <= ID_mem_wr_en_i;
      EX_Ld_sgn_o <= ID_Ld_sgn_i;
      EX_read_rs2_o <= ID_read_rs2_i;
    end
  end

endmodule



