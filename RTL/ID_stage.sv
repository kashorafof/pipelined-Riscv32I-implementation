module ID_stage (

    input clk_i,
    rst_i,  // Clock and reset signals
    input ID_stall_in, // Stall signal from ID stage

    // From WB stage
    input wire WB_Reg_writeE_i,  // Write enable signal from Write Back (WB) stage
    input wire [4:0] WB_Rd_source_i,  // Source register for WB stage
    input wire [31:0] WB_Write_data_i,  // Data to be written in WB stage

    // From IF stage
    input wire [31:0] IF_Instruction_i,  // Instruction from Instruction Fetch (IF) stage
    input wire [31:0] IF_PC_i,  // Program Counter from IF stage

    // Data forwarding signals
    // for ALU operation
    input wire [31:0] EX_ALU_result_i,  // ALU result from EX stage
    input wire [4:0] EX_Rd_i,  // Source register for EX stage
    input wire EX_Reg_writeE_i,  // Write enable signal from EX stage
    input wire [1:0] EX_Rd_source_i,  // Source register for EX stage
    // for Load operation
    input wire [31:0] MEM_Load_result_i,  // Load result from MEM stage
    input wire [4:0] MEM_Rd_i,  // Source register for MEM stage
    input wire MEM_Reg_writeE_i,  // Write enable signal from MEM stage
    input wire [1:0] MEM_Rd_source_i,  // Source register for MEM stage


    // From EX stage to next stages
    output wire [31:0] Read_reg1_o, Read_reg2_o,  // Read registers for next stages

    // Control signals
    output wire Reg_writeE_o,
    output wire ALU_src1_o,
    output wire Mem_Write_o,
    output wire Load_sign_o_o,
    output wire IF_flush_o,

    output wire [1:0] ALU_src2_o,
    output wire [3:0] ALU_op_o,  // ALU operation 
    output wire [2:0] Mem_op_size_o,  // Memory operation size
    output wire [1:0] Rd_source_o,  // Source register for Write operation
    output wire [4:0] Rd_o,  // Instruction format
    output wire [31:0] Immediate_o,

    // For Branching
    output wire [31:0] Branch_target_o,  // Branch target address
    output wire PCSrc_o,  // 0 -> PC + 4, 1 -> Branch_target_o
    output wire stall_o
);
  `include "../Definitions/Opcode_definitions.svh"

  // Internal signals
  wire [4:0] Rs1, Rs2, Rd;
  assign Rs1 = IF_Instruction_i[19:15];
  assign Rs2 = IF_Instruction_i[24:20];
  assign Rd  = IF_Instruction_i[11:7];
  wire [31:0] Rs1_reg, Rs2_reg;


  // Instance of Register File
  Register_file RegisterFile_inst (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .ID_Write_data_i(WB_Write_data_i),
      .ID_RegWriteE_i(WB_Reg_writeE_i),
      .ID_Rd_i(WB_Rd_source_i),
      .ID_Rs1_i(Rs1),
      .ID_Rs2_i(Rs2),
      .Read_reg1_o(Rs1_reg),
      .Read_reg2_o(Rs2_reg)
  );


  wire isJALR, isLUI;
  reg JumpE, BranchE;
  // for data frowarding 
  assign Read_reg1_o = (EX_Reg_writeE_i & (EX_Rd_i == Rs1) & (EX_Rd_source_i == `Rd_source_ALU) & (Rs1 != 0)) ? EX_ALU_result_i :
                (MEM_Reg_writeE_i & (MEM_Rd_i == Rs1) & (MEM_Rd_source_i == `Rd_source_MEM) & (Rs1 != 0)) ? MEM_Load_result_i :
                (isLUI) ? 0 : Rs1_reg;

  assign Read_reg2_o = (EX_Reg_writeE_i & (EX_Rd_i == Rs2) & (EX_Rd_source_i == `Rd_source_ALU) & (Rs2 != 0)) ? EX_ALU_result_i :
                (MEM_Reg_writeE_i & (MEM_Rd == Rs2) & (MEM_Rd_source == `Rd_source_MEM) & (Rs2 != 0)) ? MEM_Load_result_i :
                Rs2_reg;

  // In the case that the previous istruction is load and the current instruction have a data dependece for it, stall the pipeline
  assign stall_o = ((EX_Rd_i == Rs1 | EX_Rd_i == Rs2) & EX_Reg_writeE_i & (EX_Rd_source_i == `Rd_source_MEM)) ? 1'b1 : 1'b0;







  // Instance of Control Unit
  Control_unit Control_unit_inst (
      .Instruction_i(Instruction),
      .Reg_write_o(Reg_writeE),
      .ALU_src1_o(ALU_src1),
      .ALU_src2_o(ALU_src2),
      .JumpE_o(JumpE),
      .BranchE_o(BranchE),
      .Mem_Write_o(Mem_Write_o),
      .Load_sign_o(Load_sign_o),
      .ALU_op_o(ALU_op),
      .Mem_op_size_o(Mem_op_size),
      .Rd_source_o(Rd_source),
      .Format_o(Format),
      .Branch_condition_o(Branch_condition),
      .isJALR_o(isJALR),
      .isLUI_o(isLUI)
  );

  // Instance of Branch Comparator
  Branch_generator Branch_generator_inst (
      .ID_Rs1_i(Read_reg1),
      .ID_Rs2_i(Read_reg2),
      .ID_PC_i(IF_PC_i),
      .ID_Immediate_i(Immediate_o ),
      .ID_ComparitorOp_i(ComparitorOp),
      .ID_BranchE_i(BranchE),
      .ID_JumpE_i(JumpE),
      .ID_isJALR_i(isJALR),
      .PC_source_o(PC_source_o),
      .Branch_target_o(Branch_target_o)
  );



  // Instance of Immediate Extender
  Immediate_extender Immediate_extender_inst (
      .Instruction_i(Instruction),
      .Format_i(Format),
      .Immediate_o(Immediate_o)
  );






endmodule
