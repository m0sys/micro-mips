`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 10:23:37 AM
// Design Name: 
// Module Name: top_tb
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


// SLL_instr: 00021080 

module top_tb(
    );

    logic clk;
    logic reset;

    logic [31:0] write_data, data_adr;
    logic mem_write;

    // Init device to be tested.
    top dut(clk, reset, write_data, data_adr, mem_write);

    // Init test.
    initial
    begin
        reset <= 1; #22; reset <= 0;
    end

    // Gen clock to sequence tests.
    always
    begin
        clk <= 1; #5; clk <= 0; #5;
    end

    // Check results.
    always @(negedge clk)
    begin
        if (mem_write) begin
            if (data_adr===84 & write_data===7) begin
                $display("Simulation succeeded!");
                $stop;
            end else if (data_adr !== 80) begin
                $display("Simulation failed.");
                $stop;
            end
        end
    end
endmodule
