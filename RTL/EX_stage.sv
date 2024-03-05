module EX_stage(
  input wire ID_ALU_src1_i,
  input wire [1:0] ID_ALU_src2_i,
  input wire [4:0] ID_Rd_i,
  input wire ID_Reg_writeE_i,
  input wire [1:0] ID_Rd_source_i,
  input wire [31:0] ID_Read_reg1_i, ID_Read_reg2_i, ID_Immediate_i,
  input wire [3:0] ID_ALU_op_i,
  input wire [2:0] ID_Mem_op_size_i,
  input wire ID_Mem_Write_i,
  input wire ID_Load_sign_i,
  

  output wire [31:0] EX_ALU_result_o,
  output wire [4:0] EX_Rd_o, 
  output wire EX_Reg_writeE_o,
  output wire [1:0] EX_Rd_source_o,  
);


  assign EX_Rd_o = ID_Rd_i;
  assign EX_Reg_writeE_o = ID_Reg_writeE_i;
  assign EX_Rd_source_o = ID_Rd_source_i;

  wire [31:0] OperandA, OperandB;
  assign OperandA = (ID_ALU_src1_i == `ALU_source1_RS1 ) ? ID_Read_reg1_i : ID_PC_i;

  assign OperandB = (ID_ALU_src2_i == `ALU_source2_RS2) ? ID_Read_reg2_i : 
                    (ID_ALU_src2_i == `ALU_source2_IMM) ? ID_Immediate_i : 32'b100;

  ALU ALU_inst(
    .Op_i(ID_ALU_op_i),
    .InA_i(OperandA),
    .InB_i(OperandB),
    .Result_o(EX_ALU_result_o)
  );

endmodule



