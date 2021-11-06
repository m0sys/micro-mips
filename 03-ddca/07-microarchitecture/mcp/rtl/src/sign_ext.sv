`timescale 1ns / 1ps
// Create Date: 11/04/2021


module sign_ext #(parameter WIDTH=16) (
    input logic [WIDTH-1:0] a,
    output logic [31:0] y
    );

    assign y={ { (32 - WIDTH){ a[WIDTH-1] } }, a };
endmodule
