`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2021 03:57:30 PM
// Design Name: 
// Module Name: upper_ext
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


module upper_ext(
    input logic [15:0] a,
    output logic [31:0] y
    );

    assign y = {a[15:0], { 16{1'b0} }};
endmodule
