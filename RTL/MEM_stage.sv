module MEM_stage(
  input wire clk_i, rst_i,
  
  input wire [31:0] EX_ALU_result_i,
  input wire [4:0] EX_Rd_i,
  input wire EX_Reg_writeE_i,
  input wire [1:0] EX_Rd_source_i,
  
  input wire [2:0] EX_Mem_op_size_i,
  input wire EX_Mem_Write_i,
  input wire EX_Load_sign_i,
  input wire [31:0] EX_RS2_i // the data to be stored in case of S_TYPE instruction

  // To pass the data to the TOP module to operate with the memory module
  output wire [31:0] MEM_DataMem_addr_o,

  // To continue passing the controls to the next stage
  output wire [4:0] MEM_Rd_o,
  output wire MEM_Reg_writeE_o,
  output wire [1:0] MEM_Rd_source_o
  output wire [2:0] MEM_Mem_op_size_o
  output wire MEM_Load_sign_o;
);


  assign MEM_Rd_o = EX_Rd_i;
  assign MEM_Reg_writeE_o = EX_Reg_writeE_i;
  assign MEM_Rd_source_o = EX_Rd_source_i;
  assign MEM_DataMem_addr_o = EX_ALU_result_i;
  assign MEM_Mem_op_size_o = EX_Mem_op_size_i;
  assign MEM_Load_sign_o = EX_Load_sign_i;

  






endmodule