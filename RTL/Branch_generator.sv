module Branch_generator(
  input wire [31:0] ID_Rs1_i, ID_Rs2_i, ID_PC_i, ID_Immediate_i,
  input wire [2:0] ID_ComparitorOp_i,
  input wire ID_BranchE_i, ID_JumpE_i, ID_isJALR_i,
  output wire PC_source_o,
  output wire [31:0] Branch_target_o
);
  `include "../Definitions/Branch_generator.svh"
  `include "../Definitions/Opcode_definitions.svh"
  wire comparision_result;
  assign comparision_result = (ID_ComparitorOp_i == `EQ)   ? ID_Rs1_i == ID_Rs2_i :
                              (ID_ComparitorOp_i == `NE)   ? ID_Rs1_i != ID_Rs2_i :
                              (ID_ComparitorOp_i == `LT)   ? ID_Rs1_i < ID_Rs2_i :
                              (ID_ComparitorOp_i == `GE)   ? ID_Rs1_i >= ID_Rs2_i :
                              (ID_ComparitorOp_i == `LTU)  ? ID_Rs1_i < ID_Rs2_i :
                              (ID_ComparitorOp_i == `GEU)  ? ID_Rs1_i >= ID_Rs2_i :
                              1'b0;

  assign Branch_target_o = (ID_isJALR_i ? ID_Rs1_i + ID_Immediate_i : ID_PC_i + ID_Immediate_i); 
  assign PC_source_o = ((ID_BranchE_i & comparision_result) | ID_JumpE_i) ? `PC_source_Branch : `PC_source_PC;

  
  
  
              

endmodule