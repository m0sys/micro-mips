`timescale 1ns / 1ps
// Create Date: 11/11/2021

module exec_stage(
    // INPUTS
    input logic [31:0]  rd1_ie32
    ,input logic [31:0] rd2_ie32
    ,input logic [31:0] alu_out_im32
    ,input logic [31:0] res_iwb32
    ,input logic [1:0]  forward_src_a_ie2
    ,input logic [1:0]  forward_src_b_ie2
    ,input logic [4:0]  rt_ie5
    ,input logic [4:0]  rd_ie5
    ,input logic        reg_dst_rtrd_ie
    ,input logic [31:0] sign_imm_ie32
    ,input logic [31:0] se_shamt_ie32
    ,input logic        apply_shift_ie        
    ,input logic        b_alu_input_ie
    ,input logic [5:0]  funct_ie6
    ,input logic [1:0]  alu_alt_ctrl_ie2

    // OUTPUTS
    ,output logic [31:0] write_data_o32
    ,output logic [4:0]  dst_reg_addr_o5
    ,output logic [31:0] alu_out_o32
    ,output logic        zero_o
    
    );

    logic [31:0] forwarding_src_a_l32;
    logic [31:0] forwarding_src_b_l32;
    logic [31:0] src_a_l32;
    logic [31:0] src_b_l32;

    // Forwarding logic for RAW hazard solution.
    mux4 #(32) forward_a_mux(rd1_ie32,
                             res_iwb32, 
                             alu_out_im32, 
                             alu_out_im32,
                             forward_src_a_ie2,
                             forwarding_src_a_l32
                         );
    mux4 #(32) foward_b_mux(rd2_ie32,
                            res_iwb32,
                            alu_out_im32,
                            alu_out_im32,
                            forward_src_b_ie2,
                            forwarding_src_b_l32
                         );

    assign write_data_o32 = forwarding_src_b_l32;
 
    mux2 #(5) dst_reg_mux(rt_ie5, rd_ie5,
                     reg_dst_rtrd_ie, dst_reg_addr_o5);
                 

    // ALU input selects.
    mux4 #(32) src_b_mux(write_data_o32, sign_imm_ie32, se_shamt_ie32,
                         se_shamt_ie32,
                         { apply_shift_ie, b_alu_input_ie }, src_b_l32);
    mux2 #(32) src_a_mux(forwarding_src_a_l32, write_data_o32, 
                         apply_shift_ie,
                         src_a_l32);

    // ALU logic.
    alu alu(
        .a_i32(src_a_l32)
        ,.b_i32(src_b_l32)
        ,.funct_i6(funct_ie6)
        ,.alt_ctrl_i2(alu_alt_ctrl_ie2)
        ,.y_o32(alu_out_o32)
        ,.zero_o(zero_o)
        );
endmodule
