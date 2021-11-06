`timescale 1ns / 1ps
// Create Date: 11/04/2021


module controller( 
    // INPUTS
    input logic           clk_i
    ,input logic          reset_i
    ,input logic [5:0]    op_i6
    ,input logic [5:0]    funct_i6
    ,input logic          zero_i

    // OUTPUTS
    ,output logic         enable_wmem_o
    ,output logic         pc_we_o
    ,output logic [1:0]   pc_branch_o2
    ,output logic         instr_or_data_o
    ,output logic         instr_we_o
    ,output logic         reg_dst_rtrd_o
    ,output logic         mem_to_reg_o
    ,output logic         enable_wrf_o
    ,output logic         a_alu_input_o
    ,output logic [1:0]   b_alu_input_o2
    ,output logic [1:0]   alu_alt_ctrl_o2
    );

    logic branch_l;
    logic pc_write_l;

    controller_fsm fsm(
        .clk_i(clk_i)
        ,.reset_i(reset_i)
        ,.op_i6(op_i6)

        ,.mem_to_reg_o(mem_to_reg_o)
        ,.reg_dst_rtrd_o(reg_dst_rtrd_o)
        ,.instr_or_data_o(instr_or_data_o)
        ,.pc_branch_o2(pc_branch_o2)
        ,.b_alu_input_o2(b_alu_input_o2)
        ,.a_alu_input_o(a_alu_input_o)
        ,.instr_we_o(instr_we_o)
        ,.enable_wmem_o(enable_wmem_o)
        ,.pc_write_o(pc_write_l)
        ,.branch_o(branch_l)
        ,.enable_wrf_o(enable_wrf_o)
        ,.alu_alt_ctrl_o2(alu_alt_ctrl_o2)
    );
    // Control Order:
    //
    // Mux selects:
    //      mem_to_reg_o        (MemtoReg)
    //      reg_dst_rtrd_o      (RegDst)
    //      instr_or_data_o     (IorD)
    //      pc_branch_o2         (PCSrc)
    //      b_alu_input_o2      (ALUSrcB)
    //      a_alu_input_o       (ALUSrcA)
    //
    // Register Enables:
    //      instr_we_o          (IRWrite)
    //      enable_wmem_o       (MemWrite)
    //      pc_write_o          (PCWrite)
    //      branch_o            (Branch)
    //      enable_wrf_o        (RegWrite)
    //      alu_alt_ctrl_o2     (ALUOp)


    // Branching logic.
    assign pc_we_o = (zero_i & branch_l) | pc_write_l;

endmodule
