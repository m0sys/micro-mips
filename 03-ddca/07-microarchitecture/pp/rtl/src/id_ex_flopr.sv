`timescale 1ns / 1ps
// Create Date: 11/08/2021

module id_ex_flopr #(parameter WIDTH=8)(
    // INPUTS - Decode Stage data
    input logic clk_i
    ,input logic reset_i
    ,input logic [WIDTH-1:0] rd1_id32
    ,input logic [WIDTH-1:0] rd2_id32
    ,input logic [4:0] rt_id5
    ,input logic [4:0] rd_id5
    ,input logic [WIDTH-1:0] sign_imm_id32
    ,input logic [WIDTH-1:0] se_shamt_id32
    ,input logic [WIDTH-1:0] pc_plus4_id32

    // OUTPUTS - Execute Stage data
    ,output logic [5:0] funct_oe6
    ,output logic [WIDTH-1:0] rd1_oe32
    ,output logic [WIDTH-1:0] rd2_oe32
    ,output logic [4:0] rt_oe5
    ,output logic [4:0] rd_oe5
    ,output logic [WIDTH-1:0] sign_imm_oe32
    ,output logic [WIDTH-1:0] se_shamt_oe32
    ,output logic [WIDTH-1:0] pc_plus4_oe32
    );

    always_ff @(posedge clk_i, posedge reset_i)
        if (reset_i) 
        begin
            rd1_oe32 <= 0;
            rd2_oe32 <= 0;
            rt_oe5 <= 0;
            rd_oe5 <= 0;
            sign_imm_oe32 <= 0;
            se_shamt_oe32 <= 0;
            pc_plus4_oe32 <= 0;
        end

        else
        begin
            rd1_oe32 <= rd1_id32;
            rd2_oe32 <= rd2_id32;
            rt_oe5 <= rt_id5;
            rd_oe5 <= rd_id5;
            sign_imm_oe32 <= sign_imm_id32;
            se_shamt_oe32 <= se_shamt_id32;
            pc_plus4_oe32 <= pc_plus4_id32;
        end
endmodule
