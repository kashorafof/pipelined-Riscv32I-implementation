module Register_file (
    input wire clk_i,
    rst_i,
    input wire [31:0] ID_Write_data_i,
    input wire ID_RegWriteE_i,
    input wire [4:0] ID_Rd_i,
    ID_Rs1_i,
    ID_Rs2_i,
    output wire [31:0] Read_reg1_o,
    Read_reg2_o
);

  reg [31:0] Registers[31:0];

  assign Read_reg1_o = (ID_Rs1_i == ID_Rd_i) ? ID_Write_data_i : Registers[Rs1_i];
  assign Read_reg2_o = (ID_Rs2_i == ID_Rd_i) ? ID_Write_data_i : Registers[Rs2_i];


  integer i;
  always @* begin
    if (rst_i) begin
      for (i = 0; i < 32; i = i + 1) Registers[i] <= 0;
    end
  end

  always @(negedge clk_i) begin
    if (ID_egWriteE_i && (ID_Rd_i != 0)) begin
      Registers[ID_Rd_i] <= ID_Write_data_i;
    end
  end

endmodule
