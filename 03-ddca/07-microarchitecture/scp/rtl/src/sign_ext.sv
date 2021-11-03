`timescale 1ns / 1ps
// Create Date: 10/28/2021 09:12:55 AM


module sign_ext(
    input logic [15:0] a,
    output logic [31:0] y
    );

    assign y={ { 16{ a[15] } }, a };
endmodule
