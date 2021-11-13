`timescale 1ns / 1ps
// Create Date: 10/28/2021 09:43:17 AM


module alu(
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
				`ALU_ADD_ALT: y_o32 <= a_i32 + b_i32;
                `ALU_SUB_ALT: y_o32 <= a_i32 - b_i32;
                `ALU_SLT_ALT: y_o32 <= a_i32 < b_i32 ? 1 : 0;
                default:      y_o32 <= 31'bx;
			endcase
		endcase
   
    assign zero_o = (y_o32 == 32'b0) ? 1 : 0;
endmodule
