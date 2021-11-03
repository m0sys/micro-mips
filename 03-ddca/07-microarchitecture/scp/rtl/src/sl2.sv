`timescale 1ns / 1ps
// Create Date: 10/28/2021 09:08:24 AM


module sl2(
    input logic [31:0] a,
    output logic [31:0] y
    );

    // Shift left by 2.
    assign y={ a[29:0], 2'b00 };
endmodule
