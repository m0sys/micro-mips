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
    // INPUTS
    input logic [5:0] op_i6
    // ,input logic [5:0] funct_i6
    ,input logic zero_i
    
    // OUTPUTS
    ,output logic mem_to_reg_o
    ,output logic mem_write_o
    ,output logic pc_src_o
    ,output logic alu_src_o
    ,output logic reg_dst_o
    ,output logic reg_write_o
    ,output logic jump_o
    ,output logic imm_ext_type_o
    ,output logic alu_skip_o
    // ,output logic [3:0] alu_control_o4
    );

    logic branch_l;
    // logic [1:0] alu_op_l2;

    main_dec md(
        // INPUTS
        .op_i6(op_i6)

        // OUTPUTS
        ,.mem_to_reg_o(mem_to_reg_o)
        ,.mem_write_o(mem_write_o)
        ,.branch_o(branch_l)
        ,.alu_src_o(alu_src_o)
        ,.reg_dst_o(reg_dst_o)
        ,.reg_write_o(reg_write_o) 
        ,.jump_o(jump_o)
        ,.imm_ext_type_o(imm_ext_type_o)
        ,.alu_skip_o(alu_skip_o)
        // ,.alu_op_o2(alu_op_l2)
        );

    /*
    alu_dec ad(
        // INPUTS
        .funct_i6(funct_i6)
        ,.alu_op_i2(alu_op_l2)

        // OUTPUTS
        ,.alu_control_o4(alu_control_o4)
        );
        */

    // Determine whether to take branch or not (beq).
    assign pc_src_o = branch_l & zero_i;
endmodule
