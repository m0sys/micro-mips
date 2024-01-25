`timescale 1ns / 1ps
// Create Date: 10/28/2021 08:44:30 AM


module reg_file(
    input logic         clk,
    input logic         we3,
    input logic [4:0]   ra1, ra2, wa3,
    input logic[31:0]   wd3,
    output logic [31:0] rd1, rd2
    );

    logic [31:0] rf[31:0];

    // Three ported register file. Read two ports combinationally.
    // Write third port on rising edge of clk. Register 0 is hardwired to 0.
    // NOTE: for piplined processor, write third port on falling edge of clk.
    
    always_ff @(posedge clk)
        if (we3) rf[wa3] <= wd3;

    assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
    assign rd2 = (ra2 != 0) ? rf[ra2] : 0;

endmodule
