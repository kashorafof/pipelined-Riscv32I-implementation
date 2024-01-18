module ALU (
    input wire [3:0] Op,
    input wire [31:0] InA,
    input wire [31:0] InB,
    output reg [31:0] Result,
    output reg Compare
);
  `include "../Definitions/alu_definitions.svh"


  always @(*) begin
    Result  = 32'b0;
    Compare = 1'b0;
    case (Op)
      `ADD:  Result = InA + InB;
      `SUB:  Result = InA - InB;
      `AND:  Result = InA & InB;
      `OR:   Result = InA | InB;
      `XOR:  Result = InA ^ InB;
      `SLL:  Result = InA << InB;
      `SRL:  Result = InA >> InB;
      `SRA:  Result = $signed(InA) >>> InB;
      `SLT:  Compare = $signed(InA) < $signed(InB);
      `SLTU: Compare = InA < InB;
      `EQ:   Compare = InA == InB;
      `NE:   Compare = InA != InB;
      `LT:   Compare = $signed(InA) < $signed(InB);
      `LTU:  Compare = InA < InB;
      `GE:   Compare = $signed(InA) >= $signed(InB);
      `GEU:  Compare = InA >= InB;
    endcase
  end

endmodule
