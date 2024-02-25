module ALU (
    input  wire [ 3:0] Op_i,
    input  wire [31:0] InA_i,
    input  wire [31:0] InB_i,
    output wire [31:0] Result_o
);
  `include "../Definitions/alu_definitions.svh"



wire [31:0] Result_ADD = InA + InB;
wire [31:0] Result_SUB = InA - InB;
wire [31:0] Result_AND = InA & InB;
wire [31:0] Result_OR = InA | InB;
wire [31:0] Result_XOR = InA ^ InB;
wire [31:0] Result_SLL = InA << InB;
wire [31:0] Result_SRL = InA >> InB;
wire [31:0] Result_SRA = $signed(InA) >>> InB;
wire [31:0] Result_SLT = ($signed(InA) < $signed(InB)) ? 32'b1 : 32'b0;
wire [31:0] Result_SLTU = (InA < InB) ? 32'b1 : 32'b0;

assign Result = (Op == `ADD)  ? Result_ADD  :
                (Op == `SUB)  ? Result_SUB  :
                (Op == `AND)  ? Result_AND  :
                (Op == `OR)   ? Result_OR   :
                (Op == `XOR)  ? Result_XOR  :
                (Op == `SLL)  ? Result_SLL  :
                (Op == `SRL)  ? Result_SRL  :
                (Op == `SRA)  ? Result_SRA  :
                (Op == `SLT)  ? Result_SLT  :
                (Op == `SLTU) ? Result_SLTU : 32'b0;

endmodule
