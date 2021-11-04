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
    logic instr_or_data_l;
    logic instr_we_l;
    logic enable_wrf_l;
    logic a_alu_input_l;
    logic [1:0] b_alu_input_l2;
    logic [1:0] alu_alt_ctrl_l2; 

    controller c(
        // OUTPUTS
        .enable_wmem_o(enable_wmem_o)
        ,.pc_we_o(pc_we_o)
        ,.instr_or_data_o(instr_or_data_l)
        ,.instr_wreg_o(instr_wreg_l)
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
        ,.instr_or_data_i(instr_or_data_l)
        ,.instr_we_i(instr_we_l)
        ,.enable_wrf_i(enable_wrf_l)
        ,.a_alu_input_i(a_alu_input_l)
        ,.b_alu_input_i2(b_alu_input_l2)
        ,.alu_alt_ctrl_i2(alu_alt_ctrl_l2)
        
        // OUTPUTS
        ,.addr_o32(addr_o32)
        ,.write_data_o32(write_data_o32)
    );


endmodule
