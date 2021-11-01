// -----------------------
// RTYPE FORMAT
//------------------------
// op|rs|rt|rd|shamt|funct
// 6b|5b|5b|5b| 5b  | 6b
//
//------------------------
// ITYPE FORMAT
//------------------------
// op|rs|rt|imm
// 6b|5b|5b|16b
//
//------------------------
// JTYPE FORMAT
//------------------------
// op|addr
// 6b|26b

// Instructions
`define INSTR_RTYPE 6'b000000
`define INSTR_LW    6'b100011
`define INSTR_SW    6'b101011
`define INSTR_LUI   6'b001111
`define INSTR_BEQ   6'b000100
`define INSTR_BNE   6'b000101
`define INSTR_J     6'b000010
`define INSTR_JAL   6'b000011
`define INSTR_ADDI  6'b001000
`define INSTR_SLTI  6'b001010

// ALU Ops
`define FUNCT6_ADD 6'b100000
`define FUNCT6_SUB 6'b100010
`define FUNCT6_AND 6'b100100
`define FUNCT6_OR  6'b100101
`define FUNCT6_NOR 6'b100111
`define FUNCT6_XOR 6'b100110
`define FUNCT6_SLT 6'b101010
`define FUNCT6_SLL 6'b000000
`define FUNCT6_SRL 6'b000010

// ALU Alt Control
`define ALU_ADD_ALT 2'b00
`define ALU_SUB_ALT 2'b01
`define ALU_DIS_ALT 2'b10


