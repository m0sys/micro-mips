`timescale 1ns / 1ps
// Create Date: 10/28/2021 08:03:15 AM


module data_path(
    // INPUTS
    input logic         clk_i
    ,input logic        reset_i
    ,input logic        mem_to_reg_i
    ,input logic        pc_branch_i
    ,input logic        b_alu_input_i
    ,input logic        reg_dst_rtrd_i
    ,input logic        enable_wreg_i
    ,input logic        pc_j_i
    ,input logic        apply_shift_i
    ,input logic [1:0]  alu_alt_ctrl_i2
    ,input logic [31:0]  instr_i32
    ,input logic [31:0]  read_data_i32

    // OUTPUTS
    ,output logic [31:0] pc_o32
    ,output logic [31:0] alu_out_o32
    ,output logic        zero_o
    ,output logic [31:0] write_data_o32
    );

    `include "defs/mips_defs.sv"

    logic [4:0] dst_reg_addr_l5;
    logic [31:0] pc_next_l32;
    logic [31:0] pc_next_br_l32;
    logic [31:0] pc_plus4_l32;
    logic [31:0] pc_branch_l32;
    logic [31:0] sign_imm_l32;
    logic [31:0] sign_immsh_l32;
    logic [31:0] se_shamt_l32;
    logic [31:0] src_a_reg_l32;
    logic [31:0] src_a_l32;
    logic [31:0] src_b_l32;
    logic [31:0] res_l32;

    // Next PC logic.
    flopr #(32) pc_reg(clk_i, reset_i, pc_next_l32, pc_o32);
    adder pc_add1(pc_o32, 32'b100, pc_plus4_l32);
    sl2 immsh(sign_imm_l32, sign_immsh_l32);
    adder pc_add2(pc_plus4_l32, sign_immsh_l32, pc_branch_l32);
    mux2 #(32) pc_br_mux(pc_plus4_l32, pc_branch_l32, pc_branch_i, pc_next_br_l32);
    mux2 #(32) pc_mux(pc_next_br_l32, { pc_plus4_l32[31:28], instr_i32[25:0], 2'b00 },
                            pc_j_i, pc_next_l32); 

    // Register file logic.
    reg_file rf(clk_i, enable_wreg_i, instr_i32[25:21], instr_i32[20:16],
                dst_reg_addr_l5, res_l32, src_a_reg_l32, write_data_o32);
    mux2 #(5) dst_reg_mux(instr_i32[20:16], instr_i32[15:11],
                     reg_dst_rtrd_i, dst_reg_addr_l5);
    mux2 #(32) res_mux(alu_out_o32, read_data_i32, mem_to_reg_i, res_l32);

    // ALU logic.
    mux4 #(32) src_b_mux(write_data_o32, sign_imm_l32, se_shamt_l32, se_shamt_l32,
                        { apply_shift_i, b_alu_input_i }, src_b_l32);
    mux2 #(32) src_a_mux(src_a_reg_l32, write_data_o32, apply_shift_i, src_a_l32);
 
    // Extension logic.
    sign_ext se(instr_i32[15:0], sign_imm_l32);
    sign_ext #(5) se2(instr_i32[10:6], se_shamt_l32);

    alu alu(
        .a_i32(src_a_l32)
        ,.b_i32(src_b_l32)
        ,.funct_i6(instr_i32[5:0])
        ,.alt_ctrl_i2(alu_alt_ctrl_i2)
        ,.y_o32(alu_out_o32)
        ,.zero_o(zero_o)
    );


    // TODO: remove when done with op implementations.
    always @(posedge clk_i)
        if (instr_i32[5:0] == `FUNCT6_SLL && instr_i32[31:26] == `INSTR_RTYPE)
        begin
            $display("INSTR_SLL");
            $display("src_a_l32 value: ", src_a_l32);
            $display("src_a_l32 value binary: %b", src_a_l32);
            $display("src_b_l32 value: ", src_b_l32);
            $display("src_b_l32 value: binary: %b", src_b_l32);
            $display("se_shamt_l32: ", se_shamt_l32);
            $display("alu_out_o32: ", alu_out_o32);
            $display("res_l32: ", res_l32);
            $display("res_l32: binary: %b", res_l32);
            $display("write_data_o32: ", write_data_o32);
            $display("write_data_o32: binary: %b", write_data_o32);
            $display("apply_shift_i: ", apply_shift_i);
            $display("enable_wreg_i: ", enable_wreg_i);
            $display("dst_reg_addr_l5 ", dst_reg_addr_l5);
        end

        else if (instr_i32[31:26] == `INSTR_SW)
        begin
            $display("INSTR_SW");
            $display("src_a_l32 value: ", src_a_l32);
            $display("src_a_l32 value binary: %b", src_a_l32);
            $display("src_b_l32 value: ", src_b_l32);
            $display("src_b_l32 value: binary: %b", src_b_l32);
            $display("se_shamt_l32: ", se_shamt_l32);
            $display("alu_out_o32: ", alu_out_o32);
            $display("res_l32: ", res_l32);
            $display("res_l32: binary: %b", res_l32);
            $display("write_data_o32: ", write_data_o32);
            $display("write_data_o32: binary: %b", write_data_o32);
            $display("apply_shift_i: ", apply_shift_i);
            $display("enable_wreg_i: ", enable_wreg_i);
            $display("dst_reg_addr_l5 ", dst_reg_addr_l5);
        end

        else if (instr_i32[31:26] == `INSTR_LW)
        begin
            $display("INSTR_LW");
            $display("src_a_l32 value: ", src_a_l32);
            $display("src_a_l32 value binary: %b", src_a_l32);
            $display("src_b_l32 value: ", src_b_l32);
            $display("src_b_l32 value: binary: %b", src_b_l32);
            $display("se_shamt_l32: ", se_shamt_l32);
            $display("alu_out_o32: ", alu_out_o32);
            $display("res_l32: ", res_l32);
            $display("res_l32: binary: %b", res_l32);
            $display("write_data_o32: ", write_data_o32);
            $display("write_data_o32: binary: %b", write_data_o32);
            $display("apply_shift_i: ", apply_shift_i);
            $display("enable_wreg_i: ", enable_wreg_i);
            $display("dst_reg_addr_l5 ", dst_reg_addr_l5);
        end
        else if (instr_i32[31:26] == `INSTR_J)
            $display("JUMPING BRUH");
        else
        begin
            $display("NO MATCH FOUND");
            $display("INSTR IS: ");
            case (instr_i32[31:26])
                `INSTR_ADDI: $display("INSTR_ADDI");
                default: $display("NO CASE");
            endcase
        end
            
    
endmodule
