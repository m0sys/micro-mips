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
    ,output logic        enable_wmem_o
    ,output logic [31:0] alu_out_o32
    ,output logic [31:0] write_data_o32
    );

    logic alu_wreg_l;
    logic b_alu_input_l;
    logic reg_dst_rtrd_l;
    logic enable_wreg_l; 
    logic pc_j_l;
    logic pc_branch_l;
    logic zero_l;
    logic [1:0] alu_alt_ctrl_l2; // used for instr s.a beq, addi, lw, sw ,etc..
    //logic imm_ext_type_l;
    //logic alu_skip_l;
    //logic [3:0] alu_control_l4;

    controller c(
        // INPUTS
        .op_i6(instr_i32[31:26])
        // ,.funct_i6(instr_i32[5:0])
        ,.zero_i(zero_l) 

        // OUTPUTS
        ,.alu_wreg_o(alu_wreg_l) 
        ,.enable_wmem_o(enable_wmem_o)
        ,.pc_branch_o(pc_branch_l)
        ,.b_alu_input_o(b_alu_input_l)
        ,.reg_dst_rtrd_o(reg_dst_rtrd_l)
        ,.enable_wreg_o(enable_wreg_l)
        ,.pc_j_o(pc_j_l)
        ,.alu_alt_ctrl_o2(alu_alt_ctrl_l2)
        // ,.imm_ext_type_o(imm_ext_type_l)
        // ,.alu_skip_o(alu_skip_l)
        // ,.alu_control_o4(alu_control_l4)
        );

    data_path dp(
        // INPUTS
        .clk_i(clk_i)
        ,.reset_i(reset_i)
        ,.alu_wreg_i(alu_wreg_l)
        ,.pc_branch_i(pc_branch_l)
        ,.b_alu_input_i(b_alu_input_l)
        ,.reg_dst_rtrd_i(reg_dst_rtrd_l)
        ,.enable_wreg_i(enable_wreg_l)
        ,.pc_j_i(pc_j_l)
        ,.alu_alt_ctrl_i2(alu_alt_ctrl_l2)
        ,.instr_i32(instr_i32)
        ,.read_data_i32(read_data_i32)
        // ,.imm_ext_type_i(imm_ext_type_l)
        // ,.alu_skip_i(alu_skip_l)

        // OUTPUTS
        ,.zero_o(zero_l)
        ,.pc_o32(pc_o32)
        ,.alu_out_o32(alu_out_o32)
        ,.write_data_o32(write_data_o32) 
        );
endmodule
