`timescale 1ns / 1ps
// Create Date: 10/28/2021 07:38:37 AM


module controller(
    // INPUTS
    input logic [5:0] op_i6
    ,input logic zero_i

    // OUTPUTS
    ,output logic mem_to_reg_o
    ,output logic enable_wmem_o
    ,output logic pc_branch_o
    ,output logic b_alu_input_o
    ,output logic reg_dst_rtrd_o
    ,output logic enable_wreg_o
    ,output logic pc_j_o
    ,output logic [1:0] alu_alt_ctrl_o2
    );

    logic branch_l;

    main_dec md(
        .op_i6(op_i6)
        ,.mem_to_reg_o(mem_to_reg_o)
        ,.enable_wmem_o(enable_wmem_o)
        ,.branch_o(branch_l)
        ,.b_alu_input_o(b_alu_input_o)
        ,.reg_dst_rtrd_o(reg_dst_rtrd_o)
        ,.enable_wreg_o(enable_wreg_o)
        ,.pc_j_o(pc_j_o)
        ,.alu_alt_ctrl_o2(alu_alt_ctrl_o2)
    );

    assign pc_branch_o = branch_l & zero_i;
endmodule
