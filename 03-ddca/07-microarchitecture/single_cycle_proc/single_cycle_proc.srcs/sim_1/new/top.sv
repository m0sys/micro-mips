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
    mips mips(clk, reset, pc, instr, mem_write, data_adr);
    imem imem(pc[7:2], instr);
    dmem dmem(clk, mem_write, data_adr, write_data, read_data);
endmodule
