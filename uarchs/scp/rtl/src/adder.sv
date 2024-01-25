`timescale 1ns / 1ps
// Create Date: 10/28/2021 08:52:11 AM


module adder(
    input logic [31:0] a, b,
    output logic [31:0] y
    );

    assign y=a+b;
endmodule
