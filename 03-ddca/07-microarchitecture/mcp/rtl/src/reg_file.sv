`timescale 1ns / 1ps
// Create Date: 11/04/2021


module reg_file(
    // INPUTS
    input logic          clk_i
    ,input logic         we3_i
    ,input logic [4:0]   ra1_i5
    ,input logic [4:0]   ra2_i5
    ,input logic [4:0]   wa3_i5
    ,input logic[31:0]   wd3_i32

    // OUTPUTS
    ,output logic [31:0] rd1_o32
    ,output logic [31:0] rd2_o32
    );

    logic [31:0] rf[31:0];

    // Three ported register file. Read two ports combinationally.
    // Write third port on rising edge of clk. Register 0 is hardwired to 0.
    // NOTE: for piplined processor, write third port on falling edge of clk.
    
    always_ff @(posedge clk_i)
        if (we3_i) rf[wa3_i5] <= wd3_i32;

    assign rd1_o32 = (ra1_i5 != 0) ? rf[ra1_i5] : 0;
    assign rd2_o32 = (ra2_i5 != 0) ? rf[ra2_i5] : 0;

endmodule
