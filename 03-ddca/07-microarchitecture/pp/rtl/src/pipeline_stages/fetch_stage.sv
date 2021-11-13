`timescale 1ns / 1ps
// Create Date: 11/10/2021

module fetch_stage(
    // INPUTS
    input logic clk_i
    ,input logic reset_i
    ,input logic is_hazy_i
    ,input logic pc_beq_id
    ,input logic pc_j_id
    ,input logic [31:0] pc_branch_id32
    ,input logic [31:0] pc_plus4_id32
    ,input logic [31:0] instr_id32

    // OUTPUTS
    ,output logic [31:0] pc_o32 
    ,output logic [31:0] pc_plus4_o32
    );

    //`include "../flopenr.sv"

    // NOTE: We should not decode the instruction prior to the Decode Stage.

    logic [31:0] pc_l32;
    logic [31:0] pc_next_l32;
    logic [31:0] pc_plus4_l32;
    logic [31:0] pc_next_br_l32;

    flopenr #(32) pc_reg(clk_i, reset_i, !is_hazy_i, pc_next_l32, pc_l32);

    // Next PC logic.
    adder pc_add1(pc_l32, 32'b100, pc_plus4_l32);

    mux2 #(32) pc_br_mux(pc_plus4_l32, pc_branch_id32, pc_beq_id,
                         pc_next_br_l32);

    mux2 #(32) pc_mux(pc_next_br_l32, { pc_plus4_id32[31:28],
                                         instr_id32[25:0], 2'b00 },
                      pc_j_id, pc_next_l32); 

    assign pc_o32 = pc_l32;
    assign pc_plus4_o32 = pc_plus4_l32;
endmodule
