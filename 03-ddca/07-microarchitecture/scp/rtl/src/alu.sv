`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 09:43:17 AM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [2:0] ctrl,
    output logic [31:0] y,
    output logic zero_y
    );
    // 32-bit alu.
    //
    // Define n-bit machine type.
    // TODO: Figure out how to pass constants as parameter in verilog.
    // `define BIT_WIDTH 32

    logic [32-1:0] b_logical_sel, b_arith_sel, or_res, and_res, zero_res, add_res;
    mux2 #(32) ba_sel(b, ~b, ctrl[2], b_logical_sel);
    mux2 #(32) bl_sel(b, -b, ctrl[2], b_arith_sel);

    assign or_res=a|b_logical_sel;
    assign and_res=a&b_logical_sel; 
    assign add_res=a+b_arith_sel;
    zero_ext zext(add_res[32-1], zero_res);

    mux4 #(32) res_mux(and_res, or_res, add_res, zero_res, ctrl[1:0], y);
    assign zero_y = (y == 0) ? 1 : 0;
endmodule
