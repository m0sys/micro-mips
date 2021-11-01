`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 07:52:59 AM
// Design Name: 
// Module Name: alu_dec
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


module alu_dec(
    // INPUTS
    // input logic [5:0]  funct_i6
    // ,input logic [1:0]  alu_op_i2

    // // OUTPUTS
    // ,output logic [3:0] alu_control_o4
    );

    // `include "defs/mips_defs.sv"

    // always_comb
    //     case(alu_op_i2)
    //         2'b00: alu_control_o4 <= 4'b0010; // add (for lw/sw/addi)
    //         2'b01: alu_control_o4 <= 4'b1010; // sub (for beq)
    //         default: case(funct_i6)
    //                     `FUNCT6_ADD: alu_control_o4 <= 4'b0010;
    //                     `FUNCT6_SUB: alu_control_o4 <= 4'b1010;
    //                     `FUNCT_AND:  alu_control_o4 <= 4'b0000;
    //                     `FUNCT6_OR:  alu_control_o4 <= 4'b0001;
    //                     `FUNCT6_NOR: alu_control_o4 <= 4'bxxxx;
    //                     `FUNCT6_XOR: alu_control_o4 <= 4'bxxxx;
    //                     `FUNCT6_SLT: alu_control_o4 <= 4'b1011; 
    //                     `FUNCT6_SLL: alu_control_o4 <= 4'b0100;
    //                     `FUNCT6_SRL: alu_control_o4 <= 4'bxxxx;
    //                     default:     alu_control_o4 <= 4'bxxxx; // ???
    //                  endcase
    //     endcase
endmodule
