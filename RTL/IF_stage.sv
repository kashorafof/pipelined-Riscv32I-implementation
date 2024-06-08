module IF_stage(
  input clk_i, rst_i,
  input wire ID_branch_en_i, stall_i,
  input wire [31:0] ID_Branch_target_i,
  output reg [31:0] PC_o
);

reg [31:0] PC;


always@(*)
begin
  if (rst_i)
    PC <= 32'h0;
end

always @(posedge clk_i)
begin
  PC_o = ID_branch_en_i ? ID_Branch_target_i : PC;
  if (stall_i)
  begin
    PC = PC;
    PC_o = PC-32'h4; // Send the same IP again
  end
  else if (ID_branch_en_i)
  begin
    PC = ID_Branch_target_i; // the pipeline will be flushed so PC_o will not matter    
  end
  else
    PC = PC + 32'h4;
  
end


endmodule