module ALU (
    input  wire [ 3:0] Op_i,
    input  wire [31:0] InA_i,
    input  wire [31:0] InB_i,
    output wire [31:0] Result_o
);
  `include "../Definitions/Definitions.svh"



wire [31:0] Result_ADD = InA_i + InB_i;
wire [31:0] Result_SUB = InA_i - InB_i;
wire [31:0] Result_AND = InA_i & InB_i;
wire [31:0] Result_OR  = InA_i | InB_i;
wire [31:0] Result_XOR = InA_i ^ InB_i;
wire [31:0] Result_SLL = InA_i << InB_i;
wire [31:0] Result_SRL = InA_i >> InB_i;
wire [31:0] Result_SRA = $signed(InA_i) >>> InB_i;
wire [31:0] Result_SLT = ($signed(InA_i) < $signed(InB_i)) ? 32'b1 : 32'b0;
wire [31:0] Result_SLTU = (InA_i< InB_i) ? 32'b1 : 32'b0;

assign Result = (Op_i == `ALU_ADD)  ? Result_ADD  :
                (Op_i == `ALU_SUB)  ? Result_SUB  :
                (Op_i == `ALU_AND)  ? Result_AND  :
                (Op_i == `ALU_OR)   ? Result_OR   :
                (Op_i == `ALU_XOR)  ? Result_XOR  :
                (Op_i == `ALU_SLL)  ? Result_SLL  :
                (Op_i == `ALU_SRL)  ? Result_SRL  :
                (Op_i == `ALU_SRA)  ? Result_SRA  :
                (Op_i == `ALU_SLT)  ? Result_SLT  :
                (Op_i == `ALU_SLTU) ? Result_SLTU : 32'b0;

endmodule
