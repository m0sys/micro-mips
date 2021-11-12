`timescale 1ns / 1ps
// Create Date: 11/10/2021

module hazy_unit(
    // INPUTS
    input logic branch_id
    ,input logic mem_to_reg_ie
    ,input logic enable_wreg_ie
    ,input logic mem_to_reg_im
    ,input logic enable_wreg_im
    ,input logic enable_wreg_iwb

    ,input logic [4:0] rs_id5
    ,input logic [4:0] rt_id5

    ,input logic [4:0] rs_ie5
    ,input logic [4:0] rt_ie5

    ,input logic [4:0] dst_reg_addr_ie5
    ,input logic [4:0] dst_reg_addr_im5
    ,input logic [4:0] dst_reg_addr_iwb5

    // OUTPUTS
    ,output logic is_hazy_o
    ,output logic forward_rd1_o
    ,output logic forward_rd2_o
    ,output logic [1:0] forward_src_a_o2
    ,output logic [1:0] forward_src_b_o2
    );

    logic lw_stall_l;
    logic branch_stall_l;

    // Hazard detection logic - LW data hazard; requires stalling for 2c.
    assign lw_stall_l = ((rs_id5 === rt_ie5) || (rt_id5 === rt_ie5)) && mem_to_reg_ie;

    // Forwarding logic for branch arguments.
    assign forward_rd1_o = (rs_id5 != 0)
                        && (rs_id5 == dst_reg_addr_im5) 
                        && enable_wreg_im;

    assign forward_rd2_o = (rt_id5 != 0) 
                        && (rt_id5 == dst_reg_addr_im5) 
                        && enable_wreg_im;

    // Hazard detection logic - control hazards; requires stalling for 1c.
    assign branch_stall_l = branch_id && enable_wreg_ie
    && (dst_reg_addr_ie5 == rs_id5 || dst_reg_addr_ie5 == rt_id5)
    || branch_id && mem_to_reg_im 
    && (dst_reg_addr_im5 == rs_id5 || dst_reg_addr_im5 == rt_id5);

    // Forwarding logic for RAW sln.
    always_comb 
        // FIXME: this condition should hold!
        if (rs_ie5 != 0 && rs_ie5 == dst_reg_addr_im5 && enable_wreg_im) 
            forward_src_a_o2 = 2'b10;

        else if (rs_ie5 != 0 && rs_ie5 == dst_reg_addr_iwb5 && enable_wreg_iwb)
            forward_src_a_o2 = 2'b01;

        else 
            forward_src_a_o2 = 2'b00;

    always_comb 
        if (rt_ie5 != 0 && rt_ie5 == dst_reg_addr_im5 && enable_wreg_im)
            forward_src_b_o2 = 2'b10;

        else if (rt_ie5 != 0 && rt_ie5 == dst_reg_addr_iwb5 && enable_wreg_iwb)
            forward_src_b_o2 = 2'b01;

        else 
            forward_src_b_o2 = 2'b00;

    assign is_hazy_o = lw_stall_l || branch_stall_l;
endmodule
