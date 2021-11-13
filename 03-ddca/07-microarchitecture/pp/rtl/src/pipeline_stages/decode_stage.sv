`timescale 1ns / 1ps
// Create Date: 11/10/2021

module decode_stage(
    // INPUTS
    input logic         clk_i
    ,input logic        branch_i
    ,input logic [31:0] instr_id32
    ,input logic [31:0] pc_plus4_id32
    ,input logic [31:0] alu_out_im32
    ,input logic        forward_rd1_id
    ,input logic        forward_rd2_id
    ,input logic [4:0]  dst_reg_addr_iwb5
    ,input logic [31:0] res_iwb32
    ,input logic        enable_wreg_iwb

    // OUTPUTS
    ,output logic branch_o
    ,output logic zero_o
    ,output logic [5:0] op_o6
    ,output logic [5:0] funct_o6
    ,output logic [31:0] rd1_o32
    ,output logic [31:0] rd2_o32
    ,output logic [31:0] pc_branch_o32
    ,output logic [31:0] sign_imm_o32
    ,output logic [31:0] se_shamt_o32
    );

    // NOTE: After this stage all input controls are D stage type controls.
    //      e.g. enable_wreg_i === enable_wreg_ld

    logic [31:0] forwarding_rd1_l32;
    logic [31:0] forwarding_rd2_l32;
    logic [31:0] rd1_l32;
    logic [31:0] rd2_l32;
    logic [31:0] sign_immsh_l32;

    // Register file logic.
    // NOTE: write back is done at WB stage - and read is done at DECODE 
    //       stage.
    reg_file rf(clk_i, enable_wreg_iwb, instr_id32[25:21], instr_id32[20:16],
                dst_reg_addr_iwb5, res_iwb32, rd1_o32, rd2_o32);

    // Hazard solution for handling control hazard.
    
    // Handle RAW for beq args.
    mux2 #(32) forward_rd1_mux(rd1_o32, alu_out_im32, forward_rd1_id,
                               forwarding_rd1_l32
                               );
    mux2 #(32) forward_rd2_mux(rd2_o32, alu_out_im32, forward_rd2_id,
                               forwarding_rd2_l32
                               );

    assign branch_o = branch_i;
    assign zero_o = forwarding_rd1_l32 == forwarding_rd2_l32;

    // Extension logic.
    sign_ext se(instr_id32[15:0], sign_imm_o32);
    sign_ext #(5) se2(instr_id32[10:6], se_shamt_o32);

    // PC branch logic.
    sl2 immsh(sign_imm_o32, sign_immsh_l32);
    adder pc_add2(pc_plus4_id32, sign_immsh_l32, pc_branch_o32);

    // Decode Control Wiring.
    assign op_o6 = instr_id32[31:26];
    assign funct_o6 = instr_id32[5:0];

    always @(posedge clk_i)
    begin
		$display("\n\n");
		$display("New CLK");
        $display("DP: DS: rd1_o32: ", rd1_o32);
        $display("DP: DS: rd2_o32: ", rd2_o32);
        $display("DP: DS: sign_imm_o32: ", sign_imm_o32);
        $display("DP: DS: sign_imm_o32 bin: %b", sign_imm_o32);
        $display("DP: DS: instr_id32[15:0]: ", instr_id32[15:0]);
        $display("DP: DS: instr_id32[15:0]: %b", instr_id32[15:0]);
        $display("DP: DS: alu_out_im32: ", alu_out_im32);
        $display("DP: DS: forward_rd1_id: ", forward_rd1_id);
        $display("DP: DS: forward_rd2_id: ", forward_rd2_id);
        $display("DP: DS: forwarding_rd1_l32: ", forwarding_rd1_l32);
        $display("DP: DS: forwarding_rd2_l32: ", forwarding_rd2_l32);
        $display("DP: DS: rs: ", instr_id32[25:21]);
        $display("DP: DS: rt: ", instr_id32[20:16]);
    end
endmodule
