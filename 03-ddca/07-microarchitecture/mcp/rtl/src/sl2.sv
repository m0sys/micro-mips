`timescale 1ns / 1ps
// Create Date: 11/04/2021


module sl2(
    input logic [31:0] a,
    output logic [31:0] y
    );

    // Shift left by 2.
    assign y={ a[29:0], 2'b00 };
endmodule
