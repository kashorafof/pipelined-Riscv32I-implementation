module MEM_stage(
  input wire clk_i, rst_i,
  
  input wire [31:0] EX_ALU_result_i,
  input wire [4:0] EX_rd_i,
  input wire EX_rd_wr_en_i,
  input wire [1:0] EX_rd_src_i,
  
  input wire [2:0] EX_mem_op_size_i,
  input wire EX_mem_wr_en_i,
  input wire EX_Ld_sgn_i,
  input wire [31:0] EX_rs2_i,

  // The data from the Memory module
  input wire [31:0] DataMem_Load_result_i,
  // To pass the data to the TOP module to operate with the memory module
  output wire [31:0] MEM_mem_addr_o,
  output wire [31:0] MEM_mem_st_data_o,
  output wire MEM_mem_wr_en_o,
  output wire [1:0] MEM_mem_op_size_o,

  // To continue passing the controls to the next stage
  output reg [4:0] MEM_rd_o,
  output reg MEM_rd_wr_en_o,
  output reg [1:0] MEM_rd_src_o,
  output reg [31:0] MEM_Load_result_o,
  output reg [31:0] MEM_ALU_result_o
);


  assign MEM_mem_addr_o = EX_ALU_result_i;
  assign MEM_mem_st_data_o = EX_rs2_i;
  assign MEM_mem_wr_en_o = rst_i ? 1'b0 : EX_mem_wr_en_i;
  assign MEM_mem_op_size_o = EX_mem_op_size_i;

  wire [31:0] Load_value;
  load_extender load_extender_inst (
    .Imm_in(DataMem_Load_result_i),
    .Size_i(MEM_mem_op_size_o),
    .Sign_i(EX_Ld_sgn_i),
    .Imm_out(Load_value)
  );


  always @(posedge clk_i) begin
    if(rst_i) begin
      MEM_rd_o <= 5'b0;
      MEM_rd_wr_en_o <= 1'b0;
      MEM_rd_src_o <= 2'b0;
    end else begin
      MEM_rd_o <= EX_rd_i;
      MEM_rd_wr_en_o <= EX_rd_wr_en_i;
      MEM_rd_src_o <= EX_rd_src_i;
      MEM_Load_result_o <= Load_value;
      MEM_ALU_result_o <= EX_ALU_result_i;
    end
  end

endmodule