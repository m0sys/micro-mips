`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 09:08:24 AM
// Design Name: 
// Module Name: s12
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


module sl2(
    input logic [31:0] a_i32,
    output logic [31:0] y_o32
    );

    // Shift a_i32 by 2 to the left (mult by 4).

    assign y_o32={ a_i32[29:0], 2'b00 };
endmodule
