`timescale 1ns / 1ps

module mem(
    // INPUTS
    input logic clk_i
    ,input logic we_i
    ,input logic [31:0] addr_i32
    ,input logic [31:0] write_data_i32

    // OUTPUTS
    ,output logic [31:0] read_data_o32
    );

    logic [31:0] RAM[63:0];

    initial 
    begin
        $readmemh("memfile.dat", RAM);
    end

    assign read_data_o32 = RAM[a[31:2]]; // word aligned
    always @(posedge clk_i)
        if (we_i)
            RAM[a[31:2]] <= write_data_i32;
endmodule
