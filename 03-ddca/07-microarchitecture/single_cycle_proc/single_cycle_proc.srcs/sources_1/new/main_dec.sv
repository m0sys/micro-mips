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
    ,output logic       imm_ext_type_o
    ,output logic       alu_skip_o
    ,output logic [1:0] alu_op_o2
    );

    logic [10:0] controls_l11;
    assign { 
		reg_write_o
		,reg_dst_o
		,alu_src_o
		,branch_o
		,mem_write_o
		,mem_to_reg_o
		,jump_o
		,imm_ext_type_o
		,alu_skip_o
		,alu_op_o2 
	} = controls_l11;

    always_comb
        case(op_i6)
            6'b000000: controls_l11 <= 11'b11000000010; // RTYPE
            6'b100011: controls_l11 <= 11'b10100100000; // LW
            6'b001111: controls_l11 <= 11'b10100101100; // LUI
            6'b101011: controls_l11 <= 11'b00101000000; // SW
            6'b000100: controls_l11 <= 11'b00010000001; // BEQ
            6'b001000: controls_l11 <= 11'b10100000000; // ADDI
            6'b000010: controls_l11 <= 11'b00000010000; // J
            default:   controls_l11 <= 11'bxxxxxxxxxxx; // illegal op
        endcase
endmodule
