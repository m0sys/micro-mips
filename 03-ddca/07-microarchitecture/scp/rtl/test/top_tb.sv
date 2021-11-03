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

// 00073880 => sll $7, $7, 2
// 08000012 => j 0x12 (jump by 12*bytes)
// 20020001 => j 0x11 (original jump)
// 00E53822 => sub $7, $7, $5
// 00073882 => rl $7, $7, 2
// 28E40005 => slti $4, $7, 0x5
// 00E43820 => add $7, $7, $4

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
            if (data_adr===84 & write_data===5) begin
                $display("Simulation succeeded! data_adr=%d , write_data=%d", data_adr, write_data);
                $stop;
            end else if (data_adr !== 80) begin
                $display("Simulation failed. data_adr=%d , write_data=%d", data_adr, write_data);
                $stop;
            end
        end
    end
endmodule
