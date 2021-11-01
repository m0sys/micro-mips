`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 07:43:49 AM
// Design Name: 
// Module Name: main_dec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module main_dec(
    // INPUTS
    input logic [5:0]  op_i6

    // OUTPUTS
    ,output logic       mem_to_reg_o
    ,output logic       mem_write_o
    ,output logic       branch_o
    ,output logic       alu_src_o
    ,output logic       reg_dst_o
    ,output logic       reg_write_o
    ,output logic       jump_o
    //,output logic       imm_ext_type_o
    //,output logic       alu_skip_o
    ,output logic [1:0] alu_alt_cltr_o2
    );

    `include "defs/mips_defs.sv"

    logic [8:0] controls_l9;
    assign { 
		reg_write_o
		,reg_dst_o
		,alu_src_o
		,branch_o
		,mem_write_o
		,mem_to_reg_o
		,jump_o
		//,imm_ext_type_o
		//,alu_skip_o
		,alu_alt_cltr_o2 
	} = controls_l7;

    always_comb
        case(op_i6)
            `INSTR_RTYPE: controls_l9 <= 9'b110000010;
            `INSTR_LW:    controls_l9 <= 9'b101001000; 
            `INSTR_SW:    controls_l9 <= 9'b001010000;
            `INSTR_LUI:   controls_l9 <= 9'b101001000;
            `INSTR_BEQ:   controls_l9 <= 9'b000100001;
            `INSTR_BNE:   controls_l9 <= 9'bxxxxxxxxx;
            `INSTR_J:     controls_l9 <= 9'b000000100;
            `INSTR_JAL:   controls_l9 <= 9'bxxxxxxxxx;
            `INSTR_ADDI:  controls_l9 <= 9'b101000000; 
            `INSTR_SLTI:  controls_l9 <= 9'bxxxxxxxxx;
            default:      controls_l9 <= 9'bxxxxxxxxx; // illegal op
        endcase
endmodule
