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
    input logic         clk, reset,
    output logic [31:0] pc,
    input logic [31:0]  instr,
    output logic        mem_write,
    output logic [31:0] alu_out, write_data,
    input logic [31:0]  read_data
    );

    logic mem_to_reg, alu_src, reg_dst,
          reg_write, jump, pc_src, zero;

    logic [2:0] alu_control;

    controller c(instr[31:26], instr[5:0], zero, 
                 mem_to_reg, mem_write, pc_src,
                 alu_src, reg_dst, reg_write, jump,
                 alu_control);

    data_path dp(clk, reset, mem_to_reg, pc_src,
                 alu_src, reg_dst, reg_write, jump,
                 alu_control,
                 zero, pc, instr,
                 alu_out, write_data, read_data);
endmodule
