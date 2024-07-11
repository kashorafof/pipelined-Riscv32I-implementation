`ifndef definitions
`define definitions

// Format definitions
`define I_Format 3'b000
`define S_Format 3'b001
`define B_Format 3'b010
`define U_Format 3'b011
`define J_Format 3'b100
`define R_Format 3'b101

// Branch generator definitions
`define EQ 3'b000
`define NE 3'b001
`define LT 3'b010
`define GE 3'b011
`define LTU 3'b100
`define GEU 3'b101

// ALU definitions
`define ALU_ADD 4'b0000
`define ALU_SUB 4'b0001
`define ALU_SLL 4'b0010
`define ALU_SRL 4'b0011
`define ALU_SRA 4'b0100
`define ALU_XOR 4'b0101
`define ALU_AND 4'b0110
`define ALU_OR 4'b0111
`define ALU_SLT 4'b1000
`define ALU_SLTU 4'b1001


//OPCODE definitions
`define OPCODE_R 7'B0110011
`define OPCODE_I 7'B0010011
`define OPCODE_LD 7'B0000011
`define OPCODE_S 7'B0100011
`define OPCODE_B 7'B1100011

`define OPCODE_JAL 7'B1101111
`define OPCODE_JALR 7'B1100111
`define OPCODE_AUIPC 7'B0010111
`define OPCODE_LUI 7'B0110111



//funct 3
// R-type
`define F3_ADD_SUB 3'B000
`define F3_SLL 3'B001
`define F3_SLT 3'B010
`define F3_SLTU 3'B011
`define F3_XOR 3'B100
`define F3_SRL_SRA 3'B101
`define F3_OR 3'B110
`define F3_AND 3'B111

// I-type
`define F3_ADDI 3'B000
`define F3_SLLI 3'B001
`define F3_SLTI 3'B010
`define F3_SLTIU 3'B011
`define F3_XORI 3'B100
`define F3_SRLI_SRAI 3'B101
`define F3_ORI 3'B110
`define F3_ANDI 3'B111

// LD-type
`define F3_LB 3'B000
`define F3_LH 3'B001
`define F3_LW 3'B010
`define F3_LBU 3'B100
`define F3_LHU 3'B101

// S-type
`define F3_SB 3'B000
`define F3_SH 3'B001
`define F3_SW 3'B010

// B-type
`define F3_BEQ 3'B000
`define F3_BNE 3'B001
`define F3_BLT 3'B100
`define F3_BGE 3'B101
`define F3_BLTU 3'B110
`define F3_BGEU 3'B111

//funct 7
`define F7_ADD 7'B0000000
`define F7_SUB 7'B0100000
`define F7_SRL 7'B0000000
`define F7_SRA 7'B0100000

// Memory definitions
`define Word 2'b00
`define Half 2'b01
`define Byte 2'b10
`define Signed 1'b1
`define Unsigned 1'b0

`define Read 1'b0
`define Write 1'b1

`define Jump 1'b1
`define No_jump 1'b0

`define Branch 1'b1
`define No_branch 1'b0


`define Rd_source_ALU 1'b0
`define Rd_source_MEM 1'b1

`define forward_reg1_RS1 2'b00
`define forward_reg1_EX 2'b01
`define forward_reg1_MEM 2'b10
`define forward_reg1_Zero 2'b11



`define forward_reg2_RS2 2'b00
`define forward_reg2_EX 2'b01
`define forward_reg2_MEM 2'b10
`define forward_reg2_Zero 2'b11


`define ALU_source1_RS1 1'b0
`define ALU_source1_PC 1'b1

`define ALU_source2_RS2 2'b00
`define ALU_source2_IMM 2'b01
`define ALU_source2_4 2'b10


`define PC_source_PC 1'b0
`define PC_source_Branch 1'b1

`define NOP_instruction 32'h00000013


`endif 