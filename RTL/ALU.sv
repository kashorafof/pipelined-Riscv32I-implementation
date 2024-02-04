module ALU (
    input  wire [ 3:0] Op,
    input  wire [31:0] InA,
    input  wire [31:0] InB,
    output reg  [31:0] Result
);
  `include "../Definitions/alu_definitions.svh"




  always @(*) begin
    Result = 32'b0;
    case (Op)
      `ADD:  Result = InA + InB;
      `SUB:  Result = InA - InB;
      `AND:  Result = InA & InB;
      `OR:   Result = InA | InB;
      `XOR:  Result = InA ^ InB;
      `SLL:  Result = InA << InB;
      `SRL:  Result = InA >> InB;
      `SRA:  Result = $signed(InA) >>> InB;
      `SLT:  Result = ($signed(InA) < $signed(InB)) ? 1 : 0;
      `SLTU: Result = (InA < InB) ? 1 : 0;
    endcase
  end

endmodule
