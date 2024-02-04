`ifndef Opcode_definitions
`define Opcode_definitions

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


`define Read 1'b0
`define Write 1'b1

`define Jump 1'b1
`define No_jump 1'b0

`define Branch 1'b1
`define No_branch 1'b0


`define Rd_source_ALU 1'b0
`define Rd_source_MEM 1'b1

`define ALU_source1_RS1 1'b0
`define ALU_source1_PC 1'b1

`define ALU_source2_RS2 2'b00
`define ALU_source2_IMM 2'b01
`define ALU_source2_4 2'b10


`define PC_source_PC 1'b0
`define PC_source_Branch 1'b1

`define NOP_instruction 32'h00000013

`endif
