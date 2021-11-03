`timescale 1ns / 1ps
// Create Date: 10/28/2021 09:32:26 AM


module mux4 #(parameter WIDTH=8) (
    input logic [WIDTH-1:0] d0, d1, d2, d3,
    input logic [1:0] s,
    output logic [WIDTH-1:0] y
    );

    logic [WIDTH-1:0] low, high;

    mux2 #(WIDTH) low_mux(d0, d1, s[0], low);
    mux2 #(WIDTH) high_mux(d2, d3, s[0], high);
    mux2 #(WIDTH) res_mux(low, high, s[1], y);
endmodule
