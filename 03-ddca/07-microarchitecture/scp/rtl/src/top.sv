`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 10:37:58 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input logic clk, reset,
    output logic [31:0] write_data, data_adr,
    output logic mem_write
    );

    logic [31:0] pc, instr, read_data;

    // Init processor and mems.
    mips mips(
        // INPUTS
        .clk_i(clk)
        ,.reset_i(reset)
        ,.instr_i32(instr)
        ,.read_data_i32(read_data)

        // OUTPUTS
        ,.pc_o32(pc)
        ,.enable_wmem_o(mem_write)
        ,.alu_out_o32(data_adr)
        ,.write_data_o32(write_data)
    );
    imem imem(pc[7:2], instr);
    dmem dmem(
        // INPUTS
        .clk_i(clk)
        ,.we_i(mem_write)
        ,.addr_i32(data_adr)
        ,.wdata_i32(write_data)

        // OUTPUTS
        ,.rdata_o32(read_data)
    );
endmodule
