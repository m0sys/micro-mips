`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 08:52:11 AM
// Design Name: 
// Module Name: adder
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


module adder(
    // INPUTS
    input logic [31:0] a_i32
    ,input logic [31:0] b_i32

    // OUTPUTS
    ,output logic [31:0] y_o32
    );

    assign y_o32=a_i32+b_i32;
endmodule
