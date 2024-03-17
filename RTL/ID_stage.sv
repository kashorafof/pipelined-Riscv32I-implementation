module ID_stage (

    input wire clk_i,
    input wire rst_i,  // Clock and reset signals

    // From control unit
    input wire flush_i, // Stall signal from ID stage.
    input wire stall_i,  // Stall signal from ID stage.
    input wire [1:0] forward_reg1_i;
    input wire [1:0] forward_reg2_i;

    // From WB stage
    input wire        WB_reg_wr_en_i,  // Write enable signal from Write Back (WB) stage
    input wire [4:0]  WB_rd_addr_i,  // Source register for WB stage
    input wire [31:0] WB_wr_data_i,  // Data to be written in WB stage

    // From IF stage
    input wire [31:0] IF_Instruction_i,  // Instruction from Instruction Fetch (IF) stage
    input wire [31:0] IF_PC_i,  // Program Counter from IF stage

    // Data forwarding
    input wire [31:0] EX_ALU_result_i,  // ALU result from EX stage
    input wire [31:0] MEM_Load_result_i,  // Load result from MEM stage


    output reg [31:0] ID_read_rs1_o, ID_read_rs2_o,  // Read registers for next stages

    // Control signals
    output reg ID_mem_wr_en_o,
    output reg ID_Ld_sgn_o,
    output reg ID_flush_o,

    output reg         ID_rd_wr_en_o,
    output reg         ID_rd_src_o,  // Source register for Write operation
    output reg [4:0]   ID_rd_addr_o,  // Instruction format

    output reg         ID_alu_src1_o,
    output reg [1:0]   ID_alu_src2_o,
    output reg [3:0]   ID_alu_op_o,  // ALU operation 
    output reg [2:0]   ID_mem_op_size_o,  // Memory operation size
    output reg [31:0]  ID_imm_o,

    // For Branching
    output reg ID_branch_en_o,  // 0 -> PC + 4, 1 -> ID_branch_addr_o
    output reg [31:0]  ID_branch_addr_o,  // Branch target address
);
  `include "../Definitions/Opcode_definitions.svh"

  // Internal signals
  wire [4:0] rs1_addr, rs2_addr, rd;
  wire [31:0] Instruction;
  assign Instruction = (flush_i) ? `NOP_instruction : IF_Instruction_i;
  assign rs1_addr = Instruction[19:15];
  assign rs2_addr = Instruction[24:20];
  assign rd  = Instruction[11:7];
  wire [31:0] rs1_reg, rs2_reg;


  // Instance of Register File
  Register_file RegisterFile_inst (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .ID_wr_data_i(WB_wr_data_i),
      .ID_reg_wr_en_i(WB_reg_wr_en_i),
      .ID_rd_i(WB_rd_addr_i),
      .ID_rs1_i(rs1_addr),
      .ID_rs2_i(rs2_addr),
      .Read_reg1_o(rs1_reg),
      .Read_reg2_o(rs2_reg)
  );


  wire isJALR, isLUI;
  reg JumpE, BranchE;
  wire [31:0] ID_read_rs1, ID_read_rs2;

  assign ID_read_rs1 = (forward_reg1_i == `forward_reg1_rs1) ? rs1_reg :
                       (forward_reg1_i == `forward_reg1_EX) ? EX_ALU_result_i :
                       (forward_reg1_i == `forward_reg1_MEM) ? MEM_Load_result_i :
                       32'b0;
  assign ID_read_rs2 = (forward_reg2_i == `forward_reg2_rs2) ? rs2_reg :
                        (forward_reg2_i == `forward_reg2_EX) ? EX_ALU_result_i :
                        (forward_reg2_i == `forward_reg2_MEM) ? MEM_Load_result_i :
                        32'b0;
  
  
  wire Reg_wr_en,;
  wire Jump_en;
  wire Branch_en,;
  wire Mem_wr_en,;
  wire Load_sign,;
  wire rd_source;
  wire isJALR;
  wire isLUI;
  wire       ALU_src1;
  wire [1:0] ALU_src2;
  wire [3:0] ALU_op;
  wire [2:0] Format, Mem_size, ComparitorOp;


  // Instance of Control Unit
  Instruction_decoder Instruction_decoder_inst (
    .ID_Instruction_i(Instruction),
    .Reg_writeE_o(WB_reg_wr_en_i),
    .Jump_en_o(JumpE),
    .Branch_en_o(BranchE),
    .Mem_wr_en_o(ID_mem_wr_en_o),
    

  );

  wire PC_source;
  wire [31:0] branch_addr;
  // Instance of Branch Comparator
  Branch_generator Branch_generator_inst (
      .ID_rs1_i(Read_reg1),
      .ID_rs2_i(Read_reg2),
      .ID_PC_i(IF_PC_i),
      .ID_Immediate_i(ID_imm_o ),
      .ID_ComparitorOp_i(ComparitorOp),
      .ID_BranchE_i(BranchE),
      .ID_JumpE_i(JumpE),
      .ID_isJALR_i(isJALR),
      .PC_source_o(PC_source),
      .ID_branch_addr_o(branch_addr)
  );


  wire [31:0] Immediate;
  // Instance of Immediate Extender
  Immediate_extender Immediate_extender_inst (
      .Instruction_i(Instruction),
      .Format_i(Format),
      .ID_imm_o(Immediate)
  );


  // in case of flush the instruction will be NOP instruction.
  always@(posedge clk_i)
  begin
    if (stall_i)
      begin
        ID_rd_wr_en_o <= 0;
        ID_mem_wr_en_o <= 0;
        ID_branch_en_o <= 0;
      end
    else
      begin
        ID_rd_wr_en_o <= Reg_wr_en;
        ID_mem_wr_en_o <= Mem_wr_en;
        ID_branch_en_o <= PC_source;
      end

    ID_Ld_sgn_o <= Load_sign;
    ID_alu_src1_o <= ALU_src1;
    ID_alu_src2_o <= ALU_src2;
    ID_alu_op_o <= ALU_op;
    ID_mem_op_size_o <= Mem_size;
    ID_rd_src_o <= rd_source;
    ID_rd_addr_o <= rd;
    ID_imm_o <= Immediate;
    ID_branch_addr_o <= branch_addr;
    ID_read_rs1_o <= ID_read_rs1;
    ID_read_rs2_o <= ID_read_rs2;

  end






endmodule
