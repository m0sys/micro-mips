`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 10:41:10 AM
// Design Name: 
// Module Name: dmem
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


module dmem(
    input logic clk_i
    ,input logic we_i
    ,input logic [31:0] addr_i32
    ,input logic [31:0] wdata_i32
    ,output logic [31:0] rdata_o32
    );

    logic [31:0] RAM[63:0];
    assign rdata_o32=RAM[addr_i32[31:2]]; // word aligned
    
    always_ff @(posedge clk_i)
        if (we_i) RAM[addr_i32[31:2]] <= wdata_i32;
endmodule
