`timescale 1ns / 1ps
// Create Date: 11/04/2021


module data_path(
    // INPUTS
    input logic          clk_i
    ,input logic         reset_i
    ,input logic [31:0]  read_data_i32
    ,input logic         pc_we_i
    ,input logic         instr_or_data_i
    ,input logic         instr_we_i
    ,input logic         enable_wrf_i
    ,input logic         a_alu_input_i
    ,input logic [1:0]   b_alu_input_i2
    ,input logic [1:0]   alu_alt_ctrl_i2
    
    // OUTPUTS
    ,output logic [31:0] addr_o32
    ,output logic [31:0] write_data_o32
    );

    logic [31:0] read_data1_l32;
    logic [31:0] read_data2_l32;
    logic [31:0] sign_imm_l32;
    logic [31:0] src_a_l32;
    logic [31:0] src_b_l32;
    logic [31:0] alu_res_l32;
    logic [31:0] not_set;
    logic zero_o;

    // Nonarchitectural state elements.
    logic [31:0] pc_reg_l32;
    flopenr #(32) pc_reg(clk_i, reset_i, pc_we_i, alu_res_l32, pc_reg_l32);

    logic [31:0] instr_reg_l32;
    flopenr #(32) instr_reg(clk_i, reset_i, instr_we_i, read_data_i32, instr_reg_l32);

    logic [31:0] data_reg_l32;
    flopr #(32) data_reg(clk_i, reset_i, read_data_i32, data_reg_l32);

    logic [31:0] a_reg_l32;
    flopr #(32) a_reg(clk_i, reset_i, read_data1_l32, a_reg_l32);

    logic [31:0] alu_out_reg_l32;
    flopr #(32) alu_out_reg(clk_i, reset_i, alu_res_l32, alu_out_reg_l32);


    // TODO:  Next PC logic.
    
    // Memory address logic.
    mux2 #(32) addr_mux(pc_reg_l32, alu_out_reg_l32, instr_or_data_i, addr_o32); 

    // Register file logic.
    reg_file rf (
        .clk_i(clk_i)
        ,.we3_i(enable_wrf_i)
        ,.ra1_i5(instr_reg_l32[25:21])
        //,.ra2_i5()
        ,.wa3_i5(instr_reg_l32[20:16])
        ,.wd3_i32(data_reg_l32)

        ,.rd1_o32(read_data1_l32)
        //,.rd2_o32()
    );

    // Extension logic.
    sign_ext se(instr_reg_l32[15:0], sign_imm_l32);

    // ALU input selection logic.
    mux2 #(32) src_a_mux(pc_reg_l32, a_reg_l32, a_alu_input_i, src_a_l32);
    mux4 #(32) src_b_mux(not_set, 32'b100, sign_imm_l32, not_set,
                         b_alu_input_i2, src_b_l32);
    

    // ALU logic.
    alu alu(
        .a_i32(src_a_l32)
        ,.b_i32(src_b_l32)
        ,.funct_i6(instr_l32[5:0])
        ,.alt_ctrl_i2(alu_alt_ctrl_i2)
        ,.y_o32(alu_res_l32)
        ,.zero_o(zero_o)
    );
endmodule
