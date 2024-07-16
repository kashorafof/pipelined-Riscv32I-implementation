module WB_stage(
  input wire [4:0] MEM_rd_addr_i,
  input wire MEM_rd_wr_en_i,
  input wire [1:0] MEM_rd_src_i,
  input wire [31:0] MEM_Load_result_i,
  input wire [31:0] MEM_ALU_result_i,
  
  output wire [4:0] WB_rd_addr_o,
  output wire WB_rd_wr_en_o,
  output wire [31:0] WB_wr_data_o  
);
`include "../Definitions/Definitions.svh"

  assign WB_rd_o = MEM_rd_i;
  assign WB_rd_wr_en_o = MEM_rd_wr_en_i;


 

  assign WB_wr_data_o = (MEM_rd_src_i == `Rd_source_ALU) ? MEM_ALU_result_i : MEM_Load_result_i;

endmodule