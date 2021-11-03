`timescale 1ns / 1ps
// Create Date: 10/28/2021 09:38:58 AM


module zero_ext(
    input logic a,
    output logic [31:0] y
    );

    assign y={ {31{ 0 }}, a};
endmodule
