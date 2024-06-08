module TOP_CPU(
  input wire clk_i, rst_i,

  output wire [31:0] Instruction_mem_addr_o,
  input wire [31:0] Instruction_i,
  

  output wire [31:0] Data_mem_addr_o,
  input wire [31:0] Data_mem_read_i,
  output wire [31:0] Data_mem_write_i,
  output wire [1:0] Data_mem_op_size_i,
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
  .PC_o(PC)
);

// ID stage signals







endmodule