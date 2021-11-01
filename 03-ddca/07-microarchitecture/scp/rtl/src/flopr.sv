`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 09:15:42 AM
// Design Name: 
// Module Name: flopr
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


module flopr #(parameter WIDTH=8) (
    // INPUTS
    input logic clk_i
    ,input logic reset_i
    ,input logic [WIDTH-1:0] d_i

    // OUTPUTS
    ,output logic [WIDTH-1:0] q_o
    );

    always_ff @(posedge clk_i, posedge reset_i)
        if (reset_i) q_o <= 0;
        else q_o <= d_i;
endmodule
