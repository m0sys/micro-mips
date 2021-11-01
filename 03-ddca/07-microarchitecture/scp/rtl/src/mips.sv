`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 07:29:48 AM
// Design Name: 
// Module Name: mips
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


module mips(
    // INPUTS
    input logic          clk_i
    ,input               reset_i
    ,input logic  [31:0] instr_i32
    ,input logic  [31:0] read_data_i32

    // OUTPUTS
    ,output logic [31:0] pc_o32
    ,output logic        mem_write_o
    ,output logic [31:0] alu_out_o32
    ,output logic [31:0] write_data_o32
    );

    logic mem_to_reg_l;
    logic alu_src_l;
    logic reg_dst_l;
    logic reg_write_l; 
    logic jump_l;
    logic pc_src_l;
    logic zero_l;
    //logic imm_ext_type_l;
    //logic alu_skip_l;
    //logic [3:0] alu_control_l4;
    logic [1:0] alu_alt_ctrl_l2; // used for instr s.a beq, addi, lw, sw ,etc..

    controller c(
        // INPUTS
        .op_i6(instr_i32[31:26])
        ,.funct_i6(instr_i32[5:0])
        ,.zero_i(zero_l) 

        // OUTPUTS
        ,.mem_to_reg_o(mem_to_reg_l) 
        ,.mem_write_o(mem_write_o)
        ,.pc_src_o(pc_src_l)
        ,.alu_src_o(alu_src_l)
        ,.reg_dst_o(reg_dst_l)
        ,.reg_write_o(reg_write_l)
        ,.jump_o(jump_l)
        // ,.imm_ext_type_o(imm_ext_type_l)
        // ,.alu_skip_o(alu_skip_l)
        // ,.alu_control_o4(alu_control_l4)
        ,.alu_alt_ctrl_o2(alu_alt_ctrl_l2)
        );

    data_path dp(
        // INPUTS
        .clk_i(clk_i)
        ,.reset_i(reset_i)
        ,.mem_to_reg_i( mem_to_reg_l)
        ,.pc_src_i(pc_src_i)
        ,.alu_src_i(alu_src_l)
        ,.reg_dst_i(reg_dst_l)
        ,.reg_write_i(reg_write_l)
        ,.jump_i(jump_l)
        // ,.imm_ext_type_i(imm_ext_type_l)
        // ,.alu_skip_i(alu_skip_l)
        ,.alu_alt_ctrl_i2(alu_alt_ctrl_o2)
        ,.instr_i32(instr_i32)
        ,.read_data_i32(read_data_i32)

        // OUTPUTS
        ,.zero_o(zero_l)
        ,.pc_o32(pc_o32)
        ,.alu_out_o32(alu_out_o32)
        ,.write_data_o32(write_data_o32) 
        );
endmodule
