`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 07:38:37 AM
// Design Name: 
// Module Name: controller
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


module controller(
    // INPUTS
    input logic [5:0] op_i6
    // ,input logic [5:0] funct_i6
    ,input logic zero_i
    
    // OUTPUTS
    ,output logic alu_wreg_o // select for whether alu_out or read_data 
                               // is saved to reg_file
                               
    ,output logic enable_wmem_o // write enable for dmem
    ,output logic pc_branch_o    // select for whether to take beq

    ,output logic b_alu_input_o   // select for b input to alu
                              // this selects between ext hardware and reg_file output
                              
    ,output logic reg_dst_rtrd_o   // select to determine destination register to
                              // save the results (instr[20:16] | instr[15:11])
                              // in reg_file
                              
    ,output logic enable_wreg_o // write enable for reg_file
    ,output logic pc_j_o      // select for whether to take j (vs beq | pcplus4)
    // ,output logic imm_ext_type_o // select between sign_ext or upper_imm_ext

    // ,output logic alu_skip_o // select for whether to skip alu and use input b 
                             // extended for write_back
    // ,output logic [3:0] alu_control_o4
    ,output logic [1:0] alu_alt_cltr_o2
    );

    logic branch_l;
    logic [1:0] alu_op_l2; 

    main_dec md(
        // INPUTS
        .op_i6(op_i6)

        // OUTPUTS
        ,.alu_wreg_o(alu_wreg_o)
        ,.enable_wmem_o(enable_wmem_o)
        ,.branch_o(branch_l) 
        ,.b_alu_input_o(b_alu_input_o)
        ,.reg_dst_rtrd_o(reg_dst_rtrd_o)
        ,.enable_wreg_o(enable_wreg_o) 
        ,.pc_j_o(pc_j_o)
        // ,.imm_ext_type_o(imm_ext_type_o)
        // ,.alu_skip_o(alu_skip_o)
        ,.alu_alt_cltr_o2(alu_alt_cltr_o2)
        );

    /*
    alu_dec ad(
        // INPUTS
        .funct_i6(funct_i6)
        ,.alu_op_i2(alu_op_l2)

        // OUTPUTS
        ,.alu_control_o4(alu_control_o4)
        );
        */

    // Determine whether to take branch or not (beq).
    assign pc_branch_o = branch_l & zero_i;
endmodule
