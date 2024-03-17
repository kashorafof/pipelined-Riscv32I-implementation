module Control_unit(
  input wire clk_i, rst_i,

  input wire [31:0] Instruction_i,
  input wire [31:0] PC_i,

  input wire [4:0]  EX_rd_addr_i,  // Source register for EX stage
  input wire        EX_rd_wr_en_i,  // Write enable signal from EX stage
  input wire [1:0]  EX_rd_src_i,  // Source register for EX stage


  input wire [4:0]  MEM_rd_addr_i,  // Source register for MEM stage
  input wire        MEM_rd_wr_en_i,  // Write enable signal from MEM stage
  input wire        MEM_rd_src_i,  // Source register for MEM stage

  
  input wire        ID_branch_en_i,  // 0 -> PC + 4, 1 -> ID_branch_addr_o

  output reg flush_o, stall_o,
  output reg [1:0] forward_reg1_O,
  output reg [1:0] forward_reg2_O,

);

  wire [6:0] Opcode;
  wire [2:0] Funct3;
  wire [6:0] Funct7;

  assign Opcode = Instruction_i[6:0];
  assign Funct3 = Instruction_i[14:12];
  assign Funct7 = Instruction_i[31:25];

  assign rs1_addr = Instruction[19:15];
  assign rs2_addr = Instruction[24:20];


  // Forward if:
  // if the EX_rd_wr_en and EX_rd_addr is for Rs1 or Rs2 and the source is ALU -> Forward from EX
  // if the mme_rd_wr_en and mem_rd_addr is for Rs1 or Rs2 and the source is MEM -> Forward from MEM
  // if the reg is zero -> give a zero value

  // In case of WB stage, the data is already written in the register file
  always*(posedge clk_i)
  begin
    if (rst_i)
    begin
      flush_o <= 1'b0;
      stall_o <= 1'b0;
      forward_reg1_O <= 2'b00;
      forward_reg2_O <= 2'b00;

    end
    else
    begin

      flush_o <= 1'b0;
      stall_o <= 1'b0;
      forward_reg1_O <= `forward_reg1_RS1;
      forward_reg2_O <= `forward_reg2_RS1;


      if (MEM_rd_wr_en_i)
      begin
        if (MEM_rd_addr_i == rs1_addr && rs1_addr != 0)
          forward_reg1_O <= `forward_reg1_MEM;
        if (MEM_rd_addr_i == rs2_addr && rs2_addr != 0)
          forward_reg2_O <= `forward_reg2_MEM;
      end
      if (EX_rd_wr_en_i)
      begin
        if (EX_rd_addr_i == rs1_addr && rs1_addr != 0)
          forward_reg1_O <= `forward_reg1_EX;
        if (EX_Rd_i == rs2_addr && rs2_addr != 0)
          forward_reg2_O <= `forward_reg2_EX;
      end
      if (rs1_addr == 0)
        forward_reg1_O <= `forward_reg1_Zero;
      if (rs2_addr == 0)
        forward_reg2_O <= `forward_reg2_Zero;
    end


    // Stall the pipeline 
    // if there are a Load instruction in the EX stage

    always@* begin
      if ( EX_rd_wr_en_i && ( EX_rd_addr_i == rs1_addr || EX_rd_addr_i == rs2_addr )  
                      && ( EX_rd_src_i != 0 ) && ( EX_rd_src_i == `Rd_source_MEM ) )
        stall_o = 1'b1;
      else
        stall_o = 1'b0;
    end


    // Flush the pipeline if a branch or jump is taken or there are any exception
    always@* begin
      if (ID_branch_en_i)
        flush_o = 1'b1;
      else
        flush_o = 1'b0;
    end




  end


endmodule