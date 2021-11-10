`timescale 1ns / 1ps
// Create Date: 11/08/2021

module if_id_flopenr #(parameter WIDTH=8)(
    // INPUTS - Fetch Stage data
    input logic clk_i
    ,input logic reset_i
    ,input logic en_i
    ,input logic [WIDTH-1:0] instr_if32
    ,input logic [WIDTH-1:0] pc_plus4_if32
    //,input logic             enable_wreg_if
    //,input logic             mem_to_reg_if
    //,input logic             enable_wmem_if

    // OUTPUTS - Decode Stage data
    ,output logic [WIDTH-1:0] instr_od32
    ,output logic [WIDTH-1:0] pc_plus4_od32
    //,output logic             enable_wreg_od
    //,output logic             mem_to_reg_od
    //,output logic             enable_wmem_od
    );

    always_ff @(posedge clk_i, posedge reset_i)
        if (reset_i) 
        begin
            instr_od32 <= 0;
            pc_plus4_od32 <= 0;
            //enable_wreg_od <= 0;
            //mem_to_reg_od <= 0;
            //enable_wmem_od <= 0;
        end

        else if (en_i)
        begin
            instr_od32 <= instr_if32;
            pc_plus4_od32 <= pc_plus4_if32;
            //enable_wreg_od <= enable_wreg_if;
            //mem_to_reg_od <= mem_to_reg_if;
            //enable_wmem_od <= enable_wmem_if;
        end
endmodule
