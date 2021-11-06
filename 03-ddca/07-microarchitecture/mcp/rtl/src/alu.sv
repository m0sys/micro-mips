`timescale 1ns / 1ps
// Create Date: 11/04/2021


module alu(
    input logic        clk_i,
    input logic [31:0] a_i32,
    input logic [31:0] b_i32,
	input logic [5:0] funct_i6,
    input logic [1:0] alt_ctrl_i2,
    output logic [31:0] y_o32,
    output logic zero_o
    );

	`include "defs/mips_defs.sv"

   	// TODO: Figure out how to do inverse args.
    always_comb
    begin
        case(funct_i6)
            `FUNCT6_ADD: 	  y_o32 <= a_i32 + b_i32;
            `FUNCT6_SUB: 	  y_o32 <= a_i32 - b_i32;
            `FUNCT6_AND: 	  y_o32 <= a_i32 & b_i32;
            `FUNCT6_OR:  	  y_o32 <= a_i32 | b_i32;
            //`FUNCT6_NOR: 	  y_o32 <= ~(a_i32 | b_i32);
            //`FUNCT6_XOR: 	  y_o32 <= a_i32 ^ b_i32;
            `FUNCT6_SLT: 	  y_o32 <= a_i32 < b_i32 ? 1 : 0;
            `FUNCT6_SLL: 	  y_o32 <= a_i32 << b_i32;
            `FUNCT6_SRL: 	  y_o32 <= a_i32 >> b_i32;

            default: case(alt_ctrl_i2)
				`ALU_ADD_ALT: 
                begin
                    $display("ALU: ALU ADD ALT");
                    y_o32 <= a_i32 + b_i32;
                end
                `ALU_SUB_ALT: y_o32 <= a_i32 - b_i32;
                `ALU_SLT_ALT: y_o32 <= a_i32 < b_i32 ? 1 : 0;
                default:
                begin
                    $display("ALU: DEFAULT");
                    y_o32 <= 31'bx;
                end
			endcase
		endcase
    end
   
    assign zero_o = (y_o32 == 32'b0) ? 1 : 0;

    always @(posedge clk_i)
    begin
        $display("ALU: FUNCT I6: %b", funct_i6);
        $display("ALU: ALT ALU CTRL: %b", alt_ctrl_i2);
        $display("ALU: a_i32: ", a_i32);
        $display("ALU: b_i32: ", b_i32);
        $display("ALU: y_o32: ", y_o32);
    end

endmodule
