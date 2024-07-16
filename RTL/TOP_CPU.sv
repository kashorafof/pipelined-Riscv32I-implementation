module TOP_CPU(
  input wire clk_i, rst_i,

  output wire [31:0] Instruction_mem_addr_o,
  input wire [31:0] Instruction_i,
  

  output wire [31:0] Data_mem_addr_o,
  output wire [31:0] Data_mem_st_data_o,
  output wire [1:0] Data_mem_op_size_o,
  output wire Data_mem_wr_en_o,
  input wire [31:0] Data_mem_read_i,
);

wire stall, flush;
wire branch_en;
Control_unit Control_unit_inst(
  .clk_i(clk_i),
  .rst_i(rst_i),
  .Instruction_i(Instruction_i),
  .EX_rd_addr_i(EX_rd_addr),
  .EX_rd_wr_en_i(EX_rd_wr_en),
  .EX_rd_src_i(EX_rd_src),
  .MEM_rd_addr_i(MEM_rd_addr),
  .MEM_rd_wr_en_i(MEM_rd_wr_en),
  .MEM_rd_src_i(MEM_rd_src),
  .ID_branch_en_i(branch_en),
  .flush_o(flush),
  .stall_o(stall),
  .forward_reg1_o(forward_reg1),
  .forward_reg2_o(forward_reg2)
);

// IF stage signals
wire [31:0] branch_target;
wire [31:0] PC;
assign Instruction_mem_addr_o = PC;

IF_stage IF_stage_inst (
  .clk_i(clk_i),
  .rst_i(rst_i),
  .ID_branch_en_i(branch_en),
  .stall_i(stall),
  .ID_Branch_target_i(branch_target),
  .PC_o(PC),

);


// ID -> EX Control Signals
wire [31:0] ID_EX_read_rs1, ID_EX_read_rs2;
wire ID_EX_mem_wr_en, ID_EX_Ld_sgn;
wire ID_EX_rd_wr_en, ID_EX_rd_src;
wire [4:0] ID_EX_rd_addr;
wire ID_EX_alu_src1;
wire [1:0] ID_EX_alu_src2;
wire [4:0] ID_EX_alu_op;
wire [1:0] ID_EX_mem_op_size;
wire [31:0] ID_EX_imm;
wire [31:0] ID_EX_PC;

// ID -> IF
wire branch_en;
wire [31:0] branch_addr;

// ID stage instance
ID_stage ID_stage_inst (
  .clk_i(clk_i),
  .rst_i(rst_i),
  .flush_i(flush),
  .stall_i(stall),

  .forward_reg1_i(forward_reg1),
  .forward_reg2_i(forward_reg2),
  .Instruction_i(Instruction_i),
  .IF_PC_i(PC),

  .WB_rd_wr_en_i(WB_ID_rd_wr_en),
  .WB_rd_addr_i(WB_ID_rd_addr),
  .WB_wr_data_i(WB_ID_wr_data),

  .EX_ALU_result_i(EX_MEM_ALU_result),
  .MEM_Load_result_i(MEM_WB_Load_result),

  .ID_read_rs1_o(ID_EX_read_rs1),
  .ID_read_rs2_o(ID_EX_read_rs2),

  .ID_mem_wr_en_o(ID_EX_mem_wr_en),
  .ID_Ld_sgn_o(ID_EX_Ld_sgn),

  .ID_rd_wr_en_o(ID_EX_rd_wr_en),
  .ID_rd_src_o(ID_EX_rd_src),
  .ID_rd_addr_o(ID_EX_rd_addr),

  .ID_alu_src1_o(ID_EX_alu_src1),
  .ID_alu_src2_o(ID_EX_alu_src2),
  .ID_alu_op_o(ID_EX_alu_op),
  .ID_mem_op_size_o(ID_EX_mem_op_size),
  .ID_imm_o(ID_EX_imm),
  .ID_PC_o(ID_EX_PC),

  .ID_branch_en_o(branch_en),
  .ID_branch_addr_o(branch_addr)
);

// EX -> MEM Control Signal
wire [31:0] EX_MEM_ALU_result;
wire [4:0] EX_MEM_rd_addr;
wire EX_MEM_rd_wr_en;
wire [1:0] EX_MEM_rd_src;
wire [1:0] EX_MEM_mem_op_size;
wire EX_MEM_mem_wr_en;
wire EX_MEM_Ld_sgn;
wire [31:0] EX_MEM_read_rs2;

// EX stage instance
EX_stage EX_stage_inst (
  .clk_i(clk_i),
  .rst_i(rst_i),

  .ID_ALU_src1_i(ID_EX_alu_src1),
  .ID_ALU_src2_i(ID_EX_alu_src2),
  .ID_rd_addr_i(ID_EX_rd_addr),
  .ID_rd_wr_en_i(ID_EX_rd_wr_en),
  .ID_rd_src_i(ID_EX_rd_src),
  .ID_read_rs1_i(ID_EX_read_rs1),
  .ID_read_rs2_i(ID_EX_read_rs2),
  .ID_imm_i(ID_EX_imm),
  .ID_PC_i(ID_EX_PC),
  .ID_ALU_op_i(ID_EX_alu_op),
  .ID_mem_op_size_i(ID_EX_mem_op_size),
  .ID_mem_wr_en_i(ID_EX_mem_wr_en),
  .ID_Ld_sgn_i(ID_EX_Ld_sgn),

  .EX_ALU_res_o(EX_MEM_ALU_result),
  .EX_rd_addr_o(EX_MEM_rd_addr),
  .EX_rd_wr_en_o(EX_MEM_rd_wr_en),
  .EX_rd_src_o(EX_MEM_rd_src),
  .EX_mem_op_size_o(EX_MEM_mem_op_size),
  .EX_mem_wr_en_o(EX_MEM_mem_wr_en),
  .EX_Ld_sgn_o(EX_MEM_Ld_sgn),
  .EX_read_rs2_o(EX_MEM_read_rs2)
);

// MEM -> WB Control Signal
wire [4:0] MEM_WB_rd_addr;
wire MEM_WB_rd_wr_en;
wire [1:0] MEM_WB_rd_src;
wire [31:0] MEM_WB_Load_result;
wire [31:0] MEM_WB_ALU_result;

MEM_stage MEM_stage_inst (
  .clk_i(clk_i),
  .rst_i(rst_i),

  .EX_ALU_result_i(EX_MEM_ALU_result),
  .EX_rd_i(EX_MEM_rd_addr),
  .EX_rd_wr_en_i(EX_MEM_rd_wr_en),
  .EX_rd_src_i(EX_MEM_rd_src),

  .EX_mem_op_size_i(EX_MEM_mem_op_size),
  .EX_mem_wr_en_i(EX_MEM_mem_wr_en),
  .EX_Ld_sgn_i(EX_MEM_Ld_sgn),
  .EX_rs2_i(EX_MEM_read_rs2),

  .DataMem_Load_result_i(Data_mem_read_i),

  .MEM_mem_addr_o(Data_mem_addr_o),
  .MEM_mem_st_data_o(Data_mem_st_data_o),
  .MEM_mem_wr_en_o(Data_mem_wr_en_o),
  .MEM_mem_op_size_o(Data_mem_op_size_o),

  .MEM_rd_o(MEM_WB_rd_addr),
  .MEM_rd_wr_en_o(MEM_WB_rd_wr_en),
  .MEM_rd_src_o(MEM_WB_rd_src),
  .MEM_Load_result_o(MEM_WB_Load_result),
  .MEM_ALU_result_o(MEM_WB_ALU_result)
);


// WB stage signals
wire WB_ID_rd_wr_en;
wire [4:0] WB_ID_rd_addr;
wire [31:0] WB_ID_wr_data;

WB_stage WB_stage_inst(
  .MEM_rd_addr_i(MEM_WB_rd_addr),
  .MEM_rd_wr_en_i(MEM_WB_rd_wr_en),
  .MEM_rd_src_i(MEM_WB_rd_src),
  .MEM_Load_result_i(MEM_WB_Load_result),
  .MEM_ALU_result_i(MEM_WB_ALU_result),

  .WB_rd_addr_o(WB_ID_rd_addr),
  .WB_rd_wr_en_o(WB_ID_rd_wr_en),
  .WB_wr_data_o(WB_ID_wr_data)
);








endmodule