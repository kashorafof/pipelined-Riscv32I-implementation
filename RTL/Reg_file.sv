module Reg_file(
    input wire Clk, Reset
    input wire [31:0] Write_data, 
    input wire [4:0] Reg_write, 
    input wire [4:0] Rd, Rs1, Rs2,
    output wire [31:0] Read_reg1, Read_reg2
  );

  reg [31:0] registers [31:0];

  assign Read_reg1 = registers[Rs1];
  assign Read_reg2 = registers[Rs2];

  always @(posedge clk or posedge Reset)
  begin
    if (Reset)
    begin
      integer i;
      for (i=0; i<32; i=i+1)
        registers[i] <= 0;
    end
    else
      if (Reg_write != 0)
      begin
        registers[Reg_write] <= Write_data;
      end
  end
endmodule
