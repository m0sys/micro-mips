`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2021 08:13:03 AM
// Design Name: 
// Module Name: mux8
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


module mux8 #(parameter WIDTH=8) (
    input logic [WIDTH-1:0] d0, d1, d2, d3, d4, d5, d6, d7,
    input logic [2:0] s,
    output logic [WIDTH-1:0] y
    );

    logic [WIDTH-1:0] low, high;

    mux4 #(WIDTH) low_mux(d0, d1, d2, d3, s[1:0], low);
    mux4 #(WIDTH) high_mux(d4, d5, d6, d7, s[1:0], high);
    mux2 #(WIDTH) res_mux(low, high, s[2], y);
endmodule
