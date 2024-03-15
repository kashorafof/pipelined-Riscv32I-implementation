module ID_stage (

    input wire clk_i,
    input wire rst_i,  // Clock and reset signals
    input wire ID_stall_in, // Stall signal from ID stage

    // From WB stage
    input wire        WB_reg_wr_en_i,  // Write enable signal from Write Back (WB) stage
    input wire [4:0]  WB_rd_src_i,  // Source register for WB stage
    input wire [31:0] WB_wr_data_i,  // Data to be written in WB stage

    // From IF stage
    input wire [31:0] IF_Instruction_i,  // Instruction from Instruction Fetch (IF) stage
    input wire [31:0] IF_PC_i,  // Program Counter from IF stage

    // Data forwarding signals
    // for ALU operation
    input wire [31:0] EX_ALU_result_i,  // ALU result from EX stage
    input wire [4:0]  EX_Rd_i,  // Source register for EX stage
    input wire        EX_Reg_writeE_i,  // Write enable signal from EX stage
    input wire [1:0]  EX_Rd_source_i,  // Source register for EX stage

    // Feedbacked from memory stage
    // for Load operation
    input wire [31:0] MEM_Load_result_i,  // Load result from MEM stage
    input wire [4:0]  MEM_rd_i,  // Source register for MEM stage
    input wire        MEM_rd_wr_en_i,  // Write enable signal from MEM stage
    input wire [1:0]  MEM_rd_src_i,  // Source register for MEM stage


    // From EX stage to next stages
    output wire [31:0] ID_read_rs1_o, ID_read_rs2_o,  // Read registers for next stages

    // Control signals
    output reg ID_rd_wr_en_o,
    output reg ID_mem_wr_en_o,
    output reg ID_Ld_sgn_o,
    output reg ID_flush_o,

    output reg         ID_alu_src1_o,
    output reg [1:0]   ID_alu_src2_o,
    output reg [3:0]   ID_alu_op_o,  // ALU operation 
    output reg [2:0]   ID_mem_op_size_o,  // Memory operation size
    output reg [1:0]   ID_rd_src_o,  // Source register for Write operation
    output reg [4:0]   ID_rd_addr_o,  // Instruction format
    output reg [31:0]  ID_imm_o,

    // For Branching
    output reg ID_stall_o
    output reg ID_pc_src_o,  // 0 -> PC + 4, 1 -> ID_branch_addr_o
    output reg [31:0]  ID_branch_addr_o,  // Branch target address
    output reg ID_pc_o, 
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
      .ID_wr_data_i(WB_wr_data_i),
      .ID_reg_wr_en_i(WB_reg_wr_en_i),
      .ID_rd_i(WB_rd_src_i),
      .ID_rs1_i(Rs1),
      .ID_rs2_i(Rs2),
      .Read_reg1_o(Rs1_reg),
      .Read_reg2_o(Rs2_reg)
  );


  wire isJALR, isLUI;
  reg JumpE, BranchE;
  // for data frowarding 
  assign ID_read_rs1_o = (EX_Reg_writeE_i & (EX_Rd_i == Rs1) & (EX_Rd_source_i == `Rd_source_ALU) & (Rs1 != 0)) ? EX_ALU_result_i :
                (MEM_rd_wr_en_i & (MEM_Rd_i == Rs1) & (MEM_rd_src_i == `Rd_source_MEM) & (Rs1 != 0)) ? MEM_Load_result_i :
                (isLUI) ? 0 : Rs1_reg;

  assign ID_read_rs2_o = (EX_Reg_writeE_i & (EX_Rd_i == Rs2) & (EX_Rd_source_i == `Rd_source_ALU) & (Rs2 != 0)) ? EX_ALU_result_i :
                (MEM_rd_wr_en_i & (MEM_Rd == Rs2) & (MEM_Rd_source == `Rd_source_MEM) & (Rs2 != 0)) ? MEM_Load_result_i :
                Rs2_reg;

  // In the case that the previous istruction is load and the current instruction have a data dependece for it, stall the pipeline
  assign ID_stall_o = ((EX_Rd_i == Rs1 | EX_Rd_i == Rs2) & EX_Reg_writeE_i & (EX_Rd_source_i == `Rd_source_MEM)) ? 1'b1 : 1'b0;




  wire Reg_wr_en,;
  wire Jump_en;
  wire Branch_en,;
  wire Mem_wr_en,;
  wire Load_sign,;
  wire Rd_source;
  wire isJALR;
  wire isLUI;
  wire       ALU_src1_o;
  wire [1:0] ALU_src2_o;
  wire [3:0] ALU_op_o;
  wire [2:0] Format_o, Mem_size_o, ComparitorOp_o;

  // Instance of Control Unit
  Instruction_decoder Instruction_decoder_inst (
    .ID_Instruction_i(IF_Instruction_i),
    .Reg_writeE_o(WB_reg_wr_en_i),
    .Jump_en_o(JumpE),
    .Branch_en_o(BranchE),
    .Mem_wr_en_o(ID_mem_wr_en_o),
    

  );



  // Instance of Branch Comparator
  Branch_generator Branch_generator_inst (
      .ID_Rs1_i(Read_reg1),
      .ID_Rs2_i(Read_reg2),
      .ID_PC_i(IF_PC_i),
      .ID_Immediate_i(ID_imm_o ),
      .ID_ComparitorOp_i(ComparitorOp),
      .ID_BranchE_i(BranchE),
      .ID_JumpE_i(JumpE),
      .ID_isJALR_i(isJALR),
      .PC_source_o(PC_source_o),
      .ID_branch_addr_o(ID_branch_addr_o)
  );

  // Instance of Immediate Extender
  Immediate_extender Immediate_extender_inst (
      .Instruction_i(Instruction),
      .Format_i(Format),
      .ID_imm_o(ID_imm_o)
  );








endmodule
