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
    input logic [2:0]   alu_control,
    output logic        zero,
    output logic [31:0] pc,
    input logic [31:0]  instr,
    output logic [31:0] alu_out, write_data,
    input logic [31:0]  read_data
    );

    // Define n-bit machine type.
    // `define BIT_WIDTH 32

    logic [4:0] write_reg;
    logic [31:0] pc_next, pc_next_br, pc_plus4, pc_branch;
    logic [31:0] sign_imm, sign_immsh;
    logic [31:0] src_a, src_b;
    logic [31:0] res;

    // Next PC logic.
    flopr #(32) pc_reg(clk, reset, pc_next, pc);
    adder pc_add1(pc, 32'b100, pc_plus4);
    s12 immsh(sign_imm, sign_immsh);
    adder pc_add2(pc_plus4, sign_immsh, pc_branch);
    mux2 #(32) pc_br_mux(pc_plus4, pc_branch, pc_src, pc_next_br);
    mux2 #(32) pc_mux(pc_next_br, { pc_plus4[31:28], instr[25:0], 2'b00 },
                            jump, pc_next); 

    // Register file logic.
    reg_file rf(clk, reg_write, instr[25:21], instr[20:16],
                write_reg, res, src_a, write_data);
    mux2 #(5) wr_mux(instr[20:16], instr[15:11],
                     reg_dst, write_reg);
    mux2 #(32) res_mux(alu_out, read_data, mem_to_reg, res);
    sign_ext se(instr[15:0], sign_imm);

    // ALU logic.
    mux2 #(32) src_b_mux(write_data, sign_imm, alu_src, src_b);
    alu alu(src_a, src_b, alu_control, alu_out, zero);
endmodule
