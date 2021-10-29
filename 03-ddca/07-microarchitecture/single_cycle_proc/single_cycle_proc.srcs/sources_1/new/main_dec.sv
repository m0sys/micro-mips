`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 07:43:49 AM
// Design Name: 
// Module Name: main_dec
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


module main_dec(
    input logic [5:0]  op,
    output logic       mem_to_reg, mem_write,
    output logic       branch, alu_src,
    output logic       reg_dst, reg_write,
    output logic       jump,
    output logic       imm_ext_type,
    output logic       alu_skip,
    output logic [1:0] alu_op
    );

    logic [8:0] controls;
    assign { reg_write, reg_dst, alu_src, branch, mem_write,
             mem_to_reg, jump, imm_ext_type, alu_skip, alu_op } = controls;

    always_comb
        case(op)
            6'b000000: controls <= 11'b11000000010; // RTYPE
            6'b100011: controls <= 11'b10100100000; // LW
            6'b001111: controls <= 11'b10100101100; // LUI
            6'b101011: controls <= 11'b00101000000; // SW
            6'b000100: controls <= 11'b00010000001; // BEQ
            6'b001000: controls <= 11'b10100000000; // ADDI
            6'b000010: controls <= 11'b00000010000; // J
            default:   controls <= 11'bxxxxxxxx0xx; // illegal op
        endcase
endmodule
