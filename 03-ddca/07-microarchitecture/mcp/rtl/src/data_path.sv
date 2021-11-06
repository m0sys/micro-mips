`timescale 1ns / 1ps
// Create Date: 11/04/2021


module data_path(
    // INPUTS
    input logic          clk_i
    ,input logic         reset_i
    ,input logic [31:0]  read_data_i32
    ,input logic         pc_we_i
    ,input logic [1:0]   pc_branch_i2
    ,input logic         instr_or_data_i
    ,input logic         instr_we_i
    ,input logic         reg_dst_rtrd_i
    ,input logic         mem_to_reg_i
    ,input logic         enable_wrf_i
    ,input logic         a_alu_input_i
    ,input logic [1:0]   b_alu_input_i2
    ,input logic [1:0]   alu_alt_ctrl_i2
    
    // OUTPUTS
    ,output logic [31:0] addr_o32
    ,output logic [31:0] write_data_o32
    ,output logic zero_o
    ,output logic [31:0] instr_o32
    );

    logic [31:0] read_data1_l32;
    logic [31:0] read_data2_l32;
    logic [4:0]  dst_reg_addr_l5;
    logic [31:0] wb_l32;
    logic [31:0] sign_imm_l32;
    logic [31:0] sign_immsh_l32;
    logic [31:0] src_a_l32;
    logic [31:0] src_b_l32;
    logic [31:0] alu_res_l32;
    logic [31:0] next_pc_l32;
    logic [31:0] not_set;

    // ---------------------------- Datapath spec ----------------------------
    // 1. All reads must occur during the posedge of the clock. 
    // 2. All writes mustoccur during the negedge of the clock.

    // Nonarchitectural state elements.
    logic [31:0] pc_reg_l32;
    flopenr #(32) pc_reg(clk_i, reset_i, pc_we_i, next_pc_l32, pc_reg_l32);

    logic [31:0] instr_reg_l32;
    flopenr #(32) instr_reg(clk_i, reset_i, instr_we_i, read_data_i32, instr_reg_l32);

    logic [31:0] data_reg_l32;
    flopr #(32) data_reg(clk_i, reset_i, read_data_i32, data_reg_l32);

    logic [31:0] a_reg_l32;
    flopr #(32) a_reg(clk_i, reset_i, read_data1_l32, a_reg_l32);

    logic [31:0] b_reg_l32;
    flopr #(32) b_reg(clk_i, reset_i, read_data2_l32, b_reg_l32);

    logic [31:0] alu_out_reg_l32;
    flopr #(32) alu_out_reg(clk_i, reset_i, alu_res_l32, alu_out_reg_l32);


    // Next PC logic.
    // NOTE: This mux selects between current cycle's alu result,
    // previous cycle's alu result (which is stored in alu_out_reg_l32), or
    // the jump target result computed on current cycle.
    mux4 #(32) pc_next_mux(alu_res_l32, alu_out_reg_l32,
                           { pc_reg_l32[31:28], instr_reg_l32[25:0], 2'b00 },
                           not_set, pc_branch_i2, next_pc_l32);
    
    // Memory address logic.
    mux2 #(32) addr_mux(pc_reg_l32, alu_out_reg_l32, instr_or_data_i, addr_o32); 

    // RF input selection logic.
    mux2 #(5) waddr_mux(instr_reg_l32[20:16], instr_reg_l32[15:11], 
                        reg_dst_rtrd_i, dst_reg_addr_l5);

    // Write back logic.
    mux2 #(32) write_back_mux(alu_out_reg_l32, data_reg_l32, mem_to_reg_i,
                              wb_l32);

    // Register file logic.
    reg_file rf (
        .clk_i(clk_i)
        ,.we3_i(enable_wrf_i)
        ,.ra1_i5(instr_reg_l32[25:21])
        ,.ra2_i5(instr_reg_l32[20:16])
        ,.wa3_i5(dst_reg_addr_l5)
        ,.wd3_i32(wb_l32)

        ,.rd1_o32(read_data1_l32)
        ,.rd2_o32(read_data2_l32)
    );

    // Extension logic.
    sign_ext se(instr_reg_l32[15:0], sign_imm_l32);
    sl2 sl2(sign_imm_l32, sign_immsh_l32);

    // ALU input selection logic.
    mux2 #(32) src_a_mux(pc_reg_l32, a_reg_l32, a_alu_input_i, src_a_l32);
    mux4 #(32) src_b_mux(b_reg_l32, 32'b100, sign_imm_l32, sign_immsh_l32,
                         b_alu_input_i2, src_b_l32);
    

    // ALU logic.
    alu alu(
        .clk_i(clk_i)
        ,.a_i32(src_a_l32)
        ,.b_i32(src_b_l32)
        ,.funct_i6(instr_reg_l32[5:0])
        ,.alt_ctrl_i2(alu_alt_ctrl_i2)
        ,.y_o32(alu_res_l32)
        ,.zero_o(zero_o)
    );

    // Memory write logic.
    assign write_data_o32 = b_reg_l32;

    // Send back the loaded instruction.
    assign instr_o32 = instr_reg_l32;

    // TODO: remove when done with op implementations.
    always @(posedge clk_i)
    begin
        $display("DP: >>>>>>>>>>>>>>>>>>>>>POSEDGE<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("DP: instr_reg_l32 (IR): %b", instr_reg_l32);
        $display("DP: pc_reg_l32 (PC): ", pc_reg_l32);
        $display("DP: alu_res_l32 (ALUResult): ", alu_res_l32);
        $display("DP: alu_out_reg_l32 (ALUOut): ", alu_out_reg_l32);
        $display("DP: src_a_l32: ", src_a_l32);
        $display("DP: src_b_l32: ", src_b_l32);
        $display("DP: read_data1_l32: (RD1) ", read_data1_l32);
        $display("DP: read_data2_l32: (RD2) ", read_data2_l32);
        $display("DP: a_reg_l32 (A): ", a_reg_l32);
        $display("DP: b_reg_l32 (B): ", b_reg_l32);
        $display("DP: write_data_o32 (WD): ", write_data_o32);
        $display("DP: addr_o32 (Adr): ", addr_o32);
        $display("\n");
        $display("DP: SIGNALS:");
        $display("DP: MUX SELECTS:");
        $display("DP: mem_to_reg_i: ", mem_to_reg_i);
        $display("DP: reg_dst_rtrd_i: ", reg_dst_rtrd_i);
        $display("DP: instr_or_data_i: ", instr_or_data_i);
        $display("DP: pc_branch_i2: ", pc_branch_i2);
        $display("DP: b_alu_input_i2: ", b_alu_input_i2);
        $display("DP: a_alu_input_i: ", a_alu_input_i);
        $display("DP: REGISTER ENABLES:");
        $display("DP: instr_we_i: ", instr_we_i);
        $display("DP: pc_we_i: ", pc_we_i);
        $display("DP: enable_wrf_i: ", enable_wrf_i);
        $display("DP: alu_alt_ctrl_i2: ", alu_alt_ctrl_i2);
        case (instr_reg_l32[31:26])
            `INSTR_RTYPE:
            begin
                $display("--->>> DP: INSTR_RTYPE <<<---");
            end

            `INSTR_LW:
            begin
                $display("--->>> DP: INSTR_LW <<<---");
            end

            `INSTR_SW:
            begin
                $display("--->>> DP: INSTR_SW <<<---");
            end

            `INSTR_BEQ:
            begin
                $display("--->>> DP: INSTR_BEQ <<<---");
            end

            `INSTR_ADDI:
            begin
                $display("--->>> DP: INSTR_ADDI <<<---");
            end

            `INSTR_J:       
            begin
                $display("--->>> DP: INSTR_J <<<---");
            end
            default:
                $display("--->>> DP: INSTR_NO_MATCH <<<---");
        endcase
    end

    always @(negedge clk_i)
    begin
        $display("DP: >>>>>>>>>>>>>>>>>>>>>NEGEDGE<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("DP: instr_reg_l32 (IR): %b", instr_reg_l32);
        $display("DP: pc_reg_l32 (PC): ", pc_reg_l32);
        $display("DP: alu_res_l32 (ALUResult): ", alu_res_l32);
        $display("DP: alu_out_reg_l32 (ALUOut): ", alu_out_reg_l32);
        $display("DP: src_a_l32: ", src_a_l32);
        $display("DP: src_b_l32: ", src_b_l32);
        $display("DP: read_data1_l32: (RD1) ", read_data1_l32);
        $display("DP: read_data2_l32: (RD2) ", read_data2_l32);
        $display("DP: a_reg_l32 (A): ", a_reg_l32);
        $display("DP: b_reg_l32 (B): ", b_reg_l32);
        $display("DP: write_data_o32 (WD): ", write_data_o32);
        $display("DP: addr_o32 (Adr): ", addr_o32);
        $display("\n");
        $display("DP: SIGNALS:");
        $display("DP: MUX SELECTS:");
        $display("DP: mem_to_reg_i: ", mem_to_reg_i);
        $display("DP: reg_dst_rtrd_i: ", reg_dst_rtrd_i);
        $display("DP: instr_or_data_i: ", instr_or_data_i);
        $display("DP: pc_branch_i2: ", pc_branch_i2);
        $display("DP: b_alu_input_i2: ", b_alu_input_i2);
        $display("DP: a_alu_input_i: ", a_alu_input_i);
        $display("DP: REGISTER ENABLES:");
        $display("DP: instr_we_i: ", instr_we_i);
        $display("DP: pc_we_i: ", pc_we_i);
        $display("DP: enable_wrf_i: ", enable_wrf_i);
        $display("DP: alu_alt_ctrl_i2: ", alu_alt_ctrl_i2);
        case (instr_reg_l32[31:26])
            `INSTR_RTYPE:
            begin
                $display("--->>> DP: INSTR_RTYPE <<<---");
            end

            `INSTR_LW:
            begin
                $display("--->>> DP: INSTR_LW <<<---");
            end

            `INSTR_SW:
            begin
                $display("--->>> DP: INSTR_SW <<<---");
            end

            `INSTR_BEQ:
            begin
                $display("--->>> DP: INSTR_BEQ <<<---");
            end

            `INSTR_ADDI:
            begin
                $display("--->>> DP: INSTR_ADDI <<<---");
            end

            `INSTR_J:       
            begin
                $display("--->>> DP: INSTR_J <<<---");
            end
            default:
                $display("--->>> DP: INSTR_NO_MATCH <<<---");
        endcase
    end

endmodule
