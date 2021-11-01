`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 08:44:30 AM
// Design Name: 
// Module Name: reg_file
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


module reg_file(
    // INPUTS
    input logic         clk_i
    ,input logic        we3_i
    ,input logic [4:0]  raddr1_i5
    ,input logic [4:0]  raddr2_i5
    ,input logic [4:0]  waddr3_i5
    ,input logic [31:0] wdata3_i32 // what to save in loc wa3

    // OUTPUTS
    ,output logic [31:0] rdata1_o32
    ,output logic [31:0] rdata2_o32
    );

    logic [31:0] rf_l32x32[31:0];

    // Three ported register file. Read two ports combinationally.
    // Write third port on rising edge of clk. Register 0 is hardwired to 0.
    // NOTE: for piplined processor, write third port on falling edge of clk.
    
    always_ff @(posedge clk_i)
        if (we3_i) rf_l32x32[waddr3_i5] <= wdata3_i32;

    assign rdata1_o32 = (raddr1_i5 != 0) ? rf_l32x32[raddr1_i5] : 0;
    assign rdata2_o32 = (raddr2_i5 != 0) ? rf_l32x32[raddr2_i5] : 0;

endmodule
