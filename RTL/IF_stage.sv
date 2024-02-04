module IF_stage(
  input clk_i, rst_i;
  input wire ID_PCsrc_i, ID_stall_i;
  input wire [31:0] ID_Branch_target_i;
  output reg [31:0] PC_o;

);

reg [31:0] PC;


always@(*)
begin
  if (rst_i)
    PC <= 32'h0;
end

always @(posedge clk_i)
begin
  PC_o <= PC;
  if (ID_stall_i)
    PC <= PC;
  else
    PC <= ID_PCsrc_i ? ID_Branch_target_i : PC + 32'h4;
end






endmodule