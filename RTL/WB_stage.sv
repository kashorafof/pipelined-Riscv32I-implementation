module WB_stage(
  input wire [4:0] MEM_Rd_i,
  input wire MEM_Reg_writeE_i,
  input wire MEM_Rd_source_i,
  input wire [2:0] MEM_Mem_op_size_i,
  input wire [31:0] MEM_Load_result_i,
  input wire [31:0] MEM_ALU_result_i,
  
  output wire [4:0] WB_Rd_o,
  output wire WB_Reg_writeE_o,
  output wire [31:0] WB_Write_data_o  
);


  assign WB_Rd_o = MEM_Rd_i;
  assign WB_Reg_writeE_o = MEM_Reg_writeE_i;

  wire [31:0] Load_value;

  load_extender load_extender_inst (
    .Imm_in(MEM_Load_result_i),
    .Size_i(MEM_Mem_op_size_i)
    .Sign_i(MEM_Load_sign_i),
    .Imm_out(Load_value)
  );

  assign WB_Write_data_o = (MEM_Rd_source_i == `Rd_source_ALU) ? MEM_ALU_result_i : Load_value;

endmodule