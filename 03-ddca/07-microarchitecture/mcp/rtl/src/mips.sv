`timescale 1ns / 1ps
// Create Date: 11/04/2021

module mips(
    // INPUTS
    input logic clk_i
    ,input logic reset_i
    ,input logic [31:0] read_data_i32

    // OUTPUTS
    ,output logic enable_wmem_o
    ,output logic [31:0] addr_o32
    ,output logic [31:0] write_data_o32
    );

    // Control signals.
    logic pc_we_l;
    logic [1:0] pc_branch_l2;
    logic instr_or_data_l;
    logic instr_we_l;
    logic reg_dst_rtrd_l;
    logic mem_to_reg_l;
    logic enable_wrf_l;
    logic a_alu_input_l;
    logic [1:0] b_alu_input_l2;
    logic [1:0] alu_alt_ctrl_l2; 

    // Register results.
    logic [31:0] instr_l32;
    logic zero_l;

    // TODO: implement the branch logic within controller to abstract it out
    //       of data path.

    controller c(
        // INPUTS
        .clk_i(clk_i)
        ,.reset_i(reset_i)
        ,.op_i6(instr_l32[31:26])
        ,.funct_i6(instr_l32[5:0])
        ,.zero_i(zero_l)

        // OUTPUTS
        ,.enable_wmem_o(enable_wmem_o)
        ,.pc_we_o(pc_we_o)
        ,.pc_branch_o2(pc_branch_l2)
        ,.instr_or_data_o(instr_or_data_l)
        ,.instr_we_o(instr_we_l)
        ,.reg_dst_rtrd_o(reg_dst_rtrd_l)
        ,.mem_to_reg_o(mem_to_reg_l)
        ,.enable_wrf_o(enable_wrf_l)
        ,.a_alu_input_o(a_alu_input_l)
        ,.b_alu_input_o2(b_alu_input_l2)
        ,.alu_alt_ctrl_o2(alu_alt_ctrl_l2)
    );

    data_path dp(
        .clk_i(clk_i)
        ,.reset_i(reset_i)
        ,.read_data_i32(read_data_i32)
        ,.pc_we_i(pc_we_l)
        ,.pc_branch_i2(pc_branch_l2)
        ,.instr_or_data_i(instr_or_data_l)
        ,.instr_we_i(instr_we_l)
        ,.reg_dst_rtrd_i(reg_dst_rtrd_l)
        ,.mem_to_reg_i(mem_to_reg_l)
        ,.enable_wrf_i(enable_wrf_l)
        ,.a_alu_input_i(a_alu_input_l)
        ,.b_alu_input_i2(b_alu_input_l2)
        ,.alu_alt_ctrl_i2(alu_alt_ctrl_l2)
        
        // OUTPUTS
        ,.addr_o32(addr_o32)
        ,.write_data_o32(write_data_o32)
        ,.instr_o32(instr_l32)
        ,.zero_o(zero_l)
    );


endmodule
