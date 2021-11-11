`timescale 1ns / 1ps
// Create Date: 11/08/2021

module if_id_flopenr #(parameter WIDTH=8)(
    // INPUTS - Fetch Stage data
    input logic clk_i
    ,input logic reset_i
    ,input logic flush_i
    ,input logic en_i
    ,input logic [WIDTH-1:0] instr_if32
    ,input logic [WIDTH-1:0] pc_plus4_if32

    // OUTPUTS - Decode Stage data
    ,output logic [WIDTH-1:0] instr_od32
    ,output logic [WIDTH-1:0] pc_plus4_od32
    );

    always_ff @(posedge clk_i, posedge reset_i, posedge flush_i)
        if (reset_i || flush_i) 
        begin
            instr_od32 <= 0;
            pc_plus4_od32 <= 0;
        end

        else if (en_i)
        begin
            instr_od32 <= instr_if32;
            pc_plus4_od32 <= pc_plus4_if32;
        end
endmodule
