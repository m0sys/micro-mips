`timescale 1ns / 1ps
// Create Date: 11/08/2021

module ex_mem_flopr #(parameter WIDTH=8)(
    // INPUTS - Execute Stage data
    input logic              clk_i
    ,input logic             reset_i
    ,input logic [WIDTH-1:0] alu_out_ie32
    ,input logic [WIDTH-1:0] write_data_ie32
    ,input logic [4:0]       dst_reg_addr_ie5
    ,input logic             enable_wreg_ie
    ,input logic             mem_to_reg_ie
    ,input logic             enable_wmem_ie

    // OUTPUTS - Memory Stage data
    ,output logic [WIDTH-1:0] alu_out_om32
    ,output logic [WIDTH-1:0] write_data_om32
    ,output logic [4:0]       dst_reg_addr_om5
    ,output logic             enable_wreg_om
    ,output logic             mem_to_reg_om
    ,output logic             enable_wmem_om
    );

    always_ff @(posedge clk_i, posedge reset_i)
        if (reset_i)
        begin
            alu_out_om32 <= 0;
            write_data_om32 <= 0;
            dst_reg_addr_om5 <= 0;
            enable_wreg_om <= 0;
            mem_to_reg_om <= 0;
            enable_wmem_om <= 0;
        end

        else
        begin
            alu_out_om32 <= alu_out_ie32;
            write_data_om32 <= write_data_ie32;
            dst_reg_addr_om5 <= dst_reg_addr_ie5;
            enable_wreg_om <= enable_wreg_ie;
            mem_to_reg_om <= mem_to_reg_ie;
            enable_wmem_om <= enable_wmem_ie;
        end
endmodule
