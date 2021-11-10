`timescale 1ns / 1ps
// Create Date: 11/08/2021

module id_ex_flopr #(parameter WIDTH=8)(
    // INPUTS - Decode Stage data
    input logic clk_i
    ,input logic reset_i
    ,output logic [5:0] funct_id6
    ,input logic [WIDTH-1:0] rd1_id32
    ,input logic [WIDTH-1:0] rd2_id32
    ,input logic [4:0] rs_id5
    ,input logic [4:0] rt_id5
    ,input logic [4:0] rd_id5
    ,input logic [WIDTH-1:0] sign_imm_id32
    ,input logic [WIDTH-1:0] se_shamt_id32
    ,input logic [WIDTH-1:0] pc_plus4_id32
    ,input logic             enable_wreg_id
    ,input logic             mem_to_reg_id
    ,input logic             enable_wmem_id
    ,input logic             branch_id
    ,input logic             pc_j_id
    ,input logic [1:0]       alu_alt_ctrl_id2
    ,input logic             b_alu_input_id
    ,input logic             apply_shift_id
    ,input logic             reg_dst_rtrd_id

    // OUTPUTS - Execute Stage data
    ,output logic [5:0] funct_oe6
    ,output logic [WIDTH-1:0] rd1_oe32
    ,output logic [WIDTH-1:0] rd2_oe32
    ,output logic [4:0] rs_oe5
    ,output logic [4:0] rt_oe5
    ,output logic [4:0] rd_oe5
    ,output logic [WIDTH-1:0] sign_imm_oe32
    ,output logic [WIDTH-1:0] se_shamt_oe32
    ,output logic [WIDTH-1:0] pc_plus4_oe32
    ,output logic             enable_wreg_oe
    ,output logic             mem_to_reg_oe
    ,output logic             enable_wmem_oe
    ,output logic             branch_oe
    ,output logic             pc_j_oe
    ,output logic [1:0]       alu_alt_ctrl_oe2
    ,output logic             b_alu_input_oe
    ,output logic             apply_shift_oe
    ,output logic             reg_dst_rtrd_oe
    );

    always_ff @(posedge clk_i, posedge reset_i)
        if (reset_i) 
        begin
            funct_oe6 <= 0;
            rd1_oe32 <= 0;
            rd2_oe32 <= 0;
            rt_oe5 <= 0;
            rd_oe5 <= 0;
            sign_imm_oe32 <= 0;
            se_shamt_oe32 <= 0;
            pc_plus4_oe32 <= 0;
            enable_wreg_oe <= 0;
            mem_to_reg_oe <= 0;
            enable_wmem_oe <= 0;
            branch_oe <= 0;
            pc_j_oe <= 0;
            alu_alt_ctrl_oe2 <= 0;
            b_alu_input_oe <= 0;
            apply_shift_oe <= 0;
            reg_dst_rtrd_oe <= 0;
        end

        else
        begin
            funct_oe6 <= funct_id6;
            rd1_oe32 <= rd1_id32;
            rd2_oe32 <= rd2_id32;
            rt_oe5 <= rt_id5;
            rd_oe5 <= rd_id5;
            sign_imm_oe32 <= sign_imm_id32;
            se_shamt_oe32 <= se_shamt_id32;
            pc_plus4_oe32 <= pc_plus4_id32;
            enable_wreg_oe <= enable_wreg_id;
            mem_to_reg_oe <= mem_to_reg_id;
            enable_wmem_oe <= enable_wmem_id;
            branch_oe <= branch_id;
            pc_j_oe <= pc_j_id;
            alu_alt_ctrl_oe2 <= alu_alt_ctrl_id2;
            b_alu_input_oe <= b_alu_input_id;
            apply_shift_oe <= apply_shift_id;
            reg_dst_rtrd_oe <= reg_dst_rtrd_id;
        end
endmodule
