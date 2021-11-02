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
    input logic [31:0] a_i32,
    input logic [31:0] b_i32,
	input logic [5:0] funct_i6,
    input logic [1:0] alt_ctrl_i2,
    output logic [31:0] y_o32,
    output logic zero_o
    );

	`include "defs/mips_defs.sv"

    // 32-bit alu.
    //
    // Define n-bit machine type.
    // TODO: Figure out how to pass constants as parameter in verilog.
    // `define BIT_WIDTH 32

	/*
    logic [32-1:0] b_logical_sel, b_arith_sel, or_res, and_res, zero_res, add_res;
    mux2 #(32) ba_sel(b, ~b, ctrl[2], b_logical_sel);
    mux2 #(32) bl_sel(b, -b, ctrl[2], b_arith_sel);

    assign or_res=a|b_logical_sel;
    assign and_res=a&b_logical_sel; 
    assign add_res=a+b_arith_sel;
    zero_ext zext(add_res[32-1], zero_res);

    mux4 #(32) res_mux(and_res, or_res, add_res, zero_res, ctrl[1:0], y);
	*/
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
            //`FUNCT6_SLL: 	  y_o32 <= a_i32 << b_i32;
            //`FUNCT6_SRL: 	  y_o32 <= a_i32 >> b_i32;

            default: case(alt_ctrl_i2)
				`ALU_ADD_ALT: y_o32 <= a_i32 + b_i32;
                `ALU_SUB_ALT: y_o32 <= a_i32 - b_i32;
                default:      y_o32 <= 31'bx;
			endcase
		endcase



   

    assign zero_o = (y_o32 == 32'b0) ? 1 : 0;

endmodule
