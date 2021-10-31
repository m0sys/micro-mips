`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 09:12:55 AM
// Design Name: 
// Module Name: sign_ext
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


module sign_ext #(parameter WIDTH=8) (
    input logic [WIDTH-1:0] a,
    output logic [31:0] y
    );

    assign y={ { (32 - WIDTH) { a[WIDTH-1] } }, a };
endmodule
