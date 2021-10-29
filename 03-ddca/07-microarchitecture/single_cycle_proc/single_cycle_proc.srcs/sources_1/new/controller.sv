`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 07:38:37 AM
// Design Name: 
// Module Name: controller
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


module controller(
    input logic [5:0] op, funct,
    input logic zero,
    output logic mem_to_reg, mem_write,
    output logic pc_src, alu_src,
    output logic reg_dst, reg_write,
    output logic jump,
    output logic imm_ext_type,
    output logic alu_skip,
    output logic [3:0] alu_control
    );

    logic [1:0] alu_op;
    logic branch;

    main_dec md(op, mem_to_reg, mem_write, branch,
                alu_src, reg_dst, reg_write, jump, alu_op);

    alu_dec ad(funct, alu_op, alu_control);

    assign pc_src = branch & zero;
endmodule
