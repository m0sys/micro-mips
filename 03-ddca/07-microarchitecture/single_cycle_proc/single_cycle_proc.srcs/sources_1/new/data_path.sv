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
    input logic         clk, reset,
    input logic         mem_to_reg, pc_src,
    input logic         alu_src, reg_dst,
    input logic         reg_write, jump,
    input logic         imm_ext_type,
    input logic         alu_skip,
    input logic [3:0]   alu_control,
    output logic        zero,
    output logic [31:0] pc,
    input logic [31:0]  instr,
    output logic [31:0] alu_out, write_data,
    input logic [31:0]  read_data
    );

    // Define n-bit machine type.
    // `define BIT_WIDTH 32

    // NOTE: I'm not fond of comments when possible to avoid - but
    //       this language's expressiveness sucks. 

    logic [4:0] write_reg;
    logic [31:0] pc_next, pc_next_br, pc_plus4, pc_branch;
    logic [31:0] sign_imm, sign_immsh, ext_shamt, upper_imm_ext;
    logic [31:0] src_a, src_b;
    logic [31:0] ext_sel;
    logic [31:0] src_a_sel;
    logic [31:0] skip_sel;
    logic [31:0] res;

    // Next PC logic.
    flopr #(32) pc_reg(clk, reset, pc_next, pc);
    adder pc_add1(pc, 32'b100, pc_plus4); // byte incr pc adder
    s12 immsh(sign_imm, sign_immsh);
    adder pc_add2(pc_plus4, sign_immsh, pc_branch); // branch pc adder
    // Determines whether to take the target branch or the pcplus4 addr.
    mux2 #(32) pc_br_mux(pc_plus4, pc_branch, pc_src, pc_next_br);
    // Determines whether to take the unconditional jump or pc_br_mux result.
    mux2 #(32) pc_mux(pc_next_br, { pc_plus4[31:28], instr[25:0], 2'b00 },
                            jump, pc_next); 

                // reg_write, alu_src, mem_to_reg

    // Register file logic.
    reg_file rf(clk, reg_write, instr[25:21], instr[20:16],
                write_reg, res, src_a, write_data);
    // Determines the write-back location depending on instruction type.
    mux2 #(5) wr_mux(instr[20:16], instr[15:11],
                     reg_dst, write_reg);
    // Determines if write-back should be skip_sel result (alu_out or ext_sel) or read_data.
    mux2 #(32) res_mux(skip_sel, read_data, mem_to_reg, res);

    // Extension logic.
    sign_ext se(instr[15:0], sign_imm);
    upper_ext ue(instr[15:0], upper_imm_ext);
    mux2 #(32) ext_mux(sign_imm, upper_imm_ext, imm_ext_type, ext_sel);

    // Logic for skipping alu and using extended src_b.
    mux2 #(32) skip_alu_mux(ext_sel, alu_out, alu_skip, skip_sel);

    // ALU logic.
    // Determines which src to use as second arg to alu.
    mux2 #(32) src_b_mux(write_data, sign_imm, alu_src, src_b);
    // Determines if src_a should be shamt.
    mux2 #(32) src_a_mux(ext_shamt, src_a, shamt_src, src_a_sel);
    sign_ext  se2(instr[10:6], ext_shamt);
    alu alu(src_a, src_b, alu_control, alu_out, zero);
endmodule
