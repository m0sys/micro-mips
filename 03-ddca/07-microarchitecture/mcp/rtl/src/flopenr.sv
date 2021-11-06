`timescale 1ns / 1ps
// Create Date: 11/04/2021


module flopenr #(parameter WIDTH=8) (
    input logic clk
    ,input logic reset
    ,input logic en
    ,input logic [WIDTH-1:0] d
    ,output logic [WIDTH-1:0] q
    );

    always_ff @(negedge clk, negedge reset)
        if (reset) q <= 0;
        else if (en) q <= d;
endmodule
