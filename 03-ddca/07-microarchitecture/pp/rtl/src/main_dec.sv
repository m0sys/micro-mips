`timescale 1ns / 1ps
// Create Date: 10/28/2021 07:43:49 AM


module main_dec(
    // INPUTS
    input logic [5:0]  op_i6
    ,input logic [5:0]  funct_i6

    // OUTPUTS
    ,output logic       mem_to_reg_o
    ,output logic       enable_wmem_o
    ,output logic       branch_o
    ,output logic       b_alu_input_o
    ,output logic       reg_dst_rtrd_o
    ,output logic       enable_wreg_o
    ,output logic       pc_j_o
    ,output logic       apply_shift_o
    ,output logic [1:0] alu_alt_ctrl_o2
    );

    `include "defs/mips_defs.sv"

    logic [8:0] ctrls_l9;
    assign { 
        enable_wreg_o
        ,reg_dst_rtrd_o
        ,b_alu_input_o
        ,branch_o
        ,enable_wmem_o
        ,mem_to_reg_o
        ,pc_j_o
        ,alu_alt_ctrl_o2
    } = ctrls_l9;

    // assign apply_shift_o = funct_i6 == |{ `FUNCT6_SLL, `FUNCT6_SRL } ? 1 : 0;
    // always_comb
    //     case(funct_i6)
    //         |{ `FUNCT6_SLL, `FUNCT6_SRL }: apply_shift_o <= 1;
    //         default:                       apply_shift_o <= 0;
    //     endcase

    always_comb
        if (funct_i6 == `FUNCT6_SLL || funct_i6 == `FUNCT6_SRL)
            apply_shift_o <= 1;
        else
            apply_shift_o <= 0;

    always_comb
        case(op_i6)
            `INSTR_RTYPE:                  ctrls_l9 <= 9'b110000010;
            `INSTR_LW:                     ctrls_l9 <= 9'b101001000; 
            `INSTR_SW:                     ctrls_l9 <= 9'b001010000;
            //`INSTR_LUI:                   ctrls_l9 <= 9'bxxxxxxxxx;
            `INSTR_BEQ:                     ctrls_l9 <= 9'b000100001;
            `INSTR_BNE:                     ctrls_l9 <= 9'b000100001;
            `INSTR_J:                      ctrls_l9 <= 9'b000000100;
            //`INSTR_JAL:                   ctrls_l9 <= 9'bxxxxxxxxx;
            `INSTR_ADDI:                   ctrls_l9 <= 9'b101000000; 
            `INSTR_SLTI:                  ctrls_l9 <= 9'b101000011;
            default:                       ctrls_l9 <= 9'bxxxxxxxxx; // illegal op
        endcase
        
endmodule
