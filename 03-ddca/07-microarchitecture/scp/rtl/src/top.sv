`timescale 1ns / 1ps
// Create Date: 10/28/2021 10:37:58 AM


module top(
    // INPUTS
    input logic clk_i
    ,input logic reset_i

    // OUTPUTS
    ,output logic [31:0] write_data_o32
    ,output logic [31:0] data_addr_o32
    ,output logic mem_write_o
    );

    logic [31:0] pc_l32, instr_l32, read_data_l32;

    // Init processor and mems.
    mips mips(
        .clk_i(clk_i)
        ,.reset_i(reset_i)
        ,.instr_i32(instr_l32)
        ,.read_data_i32(read_data_l32)

        ,.pc_o32(pc_l32)
        ,.enable_wmem_o(mem_write_o)
        ,.alu_out_o32(data_addr_o32)
        ,.write_data_o32(write_data_o32)
    );

    imem imem(pc_l32[7:2], instr_l32);
    dmem dmem(clk_i, mem_write_o, data_addr_o32, write_data_o32, read_data_l32);
endmodule
