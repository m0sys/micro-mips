`timescale 1ns / 1ps
// Create Date: 10/28/2021 09:15:42 AM


module flopr #(parameter WIDTH=8) (
    input logic clk, reset, 
    input logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
    );

    always_ff @(posedge clk, posedge reset)
        if (reset) q <= 0;
        else q <= d;
endmodule
