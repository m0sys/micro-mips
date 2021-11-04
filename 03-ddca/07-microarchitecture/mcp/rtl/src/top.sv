`timescale 1ns / 1ps

module top(
    // INPUTS
    input logic clk_i
    ,input logic reset_i

    // OUTPUTS
    ,output logic [31:0] write_data_o32
    ,output logic [31:0] addr_o32
    ,output logic mem_write_o
    );

    logic [31:0] read_data_l32;

    mips mips(
        .clk_i(clk_i)
        ,.reset_i(reset_i)
        ,.read_data_i32(read_data_l32)

        ,.enable_wmem_o(mem_write_o)
        ,.addr_o32(addr_o32)
        ,.write_data_o32(write_data_o32)
    );

    mem mem(
        .clk_i(clk_i)
        ,.we_i(mem_write_o)
        ,.addr_i32(addr_o32)
        ,.write_data_i32(write_data_o32)
        
        ,.read_data_o32(read_data_l32)
    );
endmodule
