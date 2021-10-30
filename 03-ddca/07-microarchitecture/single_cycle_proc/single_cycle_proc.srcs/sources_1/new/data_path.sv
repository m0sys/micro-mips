`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 08:03:15 AM
// Design Name: 
// Module Name: data_path
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


module data_path(
    // INPUTS
    input logic         clk_i
    ,input logic        reset_i
    ,input logic        mem_to_reg_i
    ,input logic        pc_src_i
    ,input logic        alu_src_i
    ,input logic        reg_dst_i
    ,input logic        reg_write_i
    ,input logic        jump_i
    ,input logic        imm_ext_type_i
    ,input logic        alu_skip_i
    ,input logic [3:0]  alu_control_i4
    ,input logic [31:0] instr_i32
    ,input logic [31:0] read_data_i32

    // OUTPUTS
    ,output logic zero_o
    ,output logic [31:0] pc_o32
    ,output logic [31:0] alu_out_o32
    ,output logic [31:0] write_data_o32
    );

    // Define n-bit machine type.
    // `define BIT_WIDTH 32

    // NOTE: I'm not fond of comments when possible to avoid - but
    //       this language's expressiveness sucks. 

    logic [4:0] write_reg_l5;
    logic [31:0] pc_next_l32; 
    logic [31:0] pc_next_br_l32; 
    logic [31:0] pc_plus4_l32;
    logic [31:0] pc_branch_l32;
    logic [31:0] sign_imm_l32;
    logic [31:0] sign_immsh_l32;
    logic [31:0] ext_shamt_l32;
    logic [31:0] upper_imm_ext_l32;
    logic [31:0] src_a_l32;
    logic [31:0] src_b_l32;
    logic [31:0] ext_mres_l32;
    logic [31:0] src_a_mres_l32;
    logic [31:0] skip_mres_l32;
    logic [31:0] res_l32;

    // Next PC logic.
    flopr #(32) pc_reg(clk_i, reset_i, pc_next_l32, pc_o32);
    adder pc_add1(pc_o32, 32'b100, pc_plus4_l32); // byte incr pc adder
    s12 immsh(sign_imm_l32, sign_immsh_l32);
    adder pc_add2(pc_plus4_l32, sign_immsh_l32, pc_branch_l32); // branch pc adder
    // Determines whether to take the target branch or the pcplus4 addr.
    mux2 #(32) pc_br_mux(pc_plus4_l32, pc_branch_l32, pc_src_i, pc_next_br_l32);
    // Determines whether to take the unconditional jump or pc_br_mux result.
    mux2 #(32) pc_mux(pc_next_br_l32, { pc_plus4_l32[31:28], instr_i32[25:0], 2'b00 },
                            jump_i, pc_next_l32); 

                // reg_write, alu_src, mem_to_reg

    // Register file logic.
    reg_file rf(clk_i, reg_write_i, instr_i32[25:21], instr_i32[20:16],
                write_reg_l5, resl32, src_a_l32, write_data_o32);
    // Determines the write-back location depending on instruction type.
    mux2 #(5) wr_mux(instr_i32[20:16], instr_i32[15:11],
                     reg_dst_i, write_reg_l5);
    // Determines if write-back should be skip_sel result (alu_out or ext_sel) or read_data.
    mux2 #(32) res_mux(skip_mres_l32, read_data_i32, mem_to_reg_i, res_l32);

    // Extension logic.
    sign_ext #(16) se(inst_i32[15:0], sign_imm_l32);
    upper_ext ue(instr_i32[15:0], upper_imm_ext_l32);
    mux2 #(32) ext_mux(sign_imm_l32, upper_imm_ext_l32, imm_ext_type_i, ext_mres_l32);

    // Logic for skipping alu and using extended src_b.
    mux2 #(32) skip_alu_mux(ext_mres_l32, alu_out_o32, alu_skip_i, skip_mres_l32);

    // ALU logic.
    // Determines which src to use as second arg to alu.
    mux2 #(32) src_b_mux(write_data_o32, ext_mres_l32, alu_src_i, src_b_l32);
    // Determines if src_a should be shamt.
    // FIXME: might be a bug someplace in sll wiring.
    //// mux2 #(32) src_a_mux(ext_shamt_l32, src_a_l32, shamt_src, src_a_sel);
    sign_ext #(5)  se2(instr_i32[10:6], ext_shamt_l32);
    alu alu(src_a_l32, src_b_l32, alu_control_i4, alu_out_o32, zero_o);
endmodule
