`timescale 1ns / 1ps
// Create Date: 11/08/2021

module mem_wb_flopr #(parameter WIDTH=8)(
    // INPUTS - Memory Stage data
    input logic              clk_i
    ,input logic             reset_i
    ,input logic [WIDTH-1:0] alu_out_im32
    ,input logic [WIDTH-1:0] read_data_im32
    ,input logic [4:0]       dst_reg_addr_im5
    ,input logic             enable_wreg_im
    ,input logic             mem_to_reg_im

    // OUTPUTS - Writeback Stage data
    ,output logic [WIDTH-1:0] alu_out_owb32
    ,output logic [WIDTH-1:0] read_data_owb32
    ,output logic [4:0]       dst_reg_addr_owb5
    ,output logic             enable_wreg_owb
    ,output logic             mem_to_reg_owb
    );

    always_ff @(posedge clk_i, posedge reset_i)
        if (reset_i)
        begin
            alu_out_owb32 <= 0;
            read_data_owb32 <= 0;
            dst_reg_addr_owb5 <= 0;
            enable_wreg_owb <= 0;
            mem_to_reg_owb <= 0;
        end

        else
        begin
            alu_out_owb32 <= alu_out_im32;
            read_data_owb32 <= read_data_im32;
            dst_reg_addr_owb5 <= dst_reg_addr_im5;
            enable_wreg_owb <= enable_wreg_im;
            mem_to_reg_owb <= mem_to_reg_im;
        end
endmodule
