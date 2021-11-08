`timescale 1ns / 1ps
// Create Date: 10/28/2021 09:12:55 AM


module sign_ext #(parameter WIDTH=16) (
    input logic [WIDTH-1:0] a,
    output logic [31:0] y
    );

    assign y={ { (32 - WIDTH){ a[WIDTH-1] } }, a };
endmodule
