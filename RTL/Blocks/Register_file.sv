module Register_file (
    input wire clk_i, rst_i,
    input wire ID_reg_wr_en_i,
    input wire [4:0] ID_rd_i,
    input wire [4:0] ID_rs1_i, 
    input wire [4:0] ID_rs2_i,
    input wire [31:0] ID_wr_data_i,

    output wire [31:0] Read_reg1_o, Read_reg2_o
);

  reg [31:0] Registers[31:0];

  assign Read_reg1_o = (ID_rs1_i == ID_rd_i) ? ID_wr_data_i : Registers[ID_rs1_i];
  assign Read_reg2_o = (ID_rs2_i == ID_rd_i) ? ID_wr_data_i : Registers[ID_rs2_i];


  integer i;
  always @* begin
    if (rst_i) begin
      for (i = 0; i < 32; i = i + 1) Registers[i] <= 0;
    end
  end

  always @(negedge clk_i) begin
    if (ID_reg_wr_en_i && (ID_rd_i != 0)) begin
      Registers[ID_rd_i] <= ID_wr_data_i;
    end
  end

endmodule
