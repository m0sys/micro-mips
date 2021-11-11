`timescale 1ns / 1ps
// Create Date: 10/28/2021 08:03:15 AM


module data_path(
    // INPUTS
    input logic         clk_i
    ,input logic        reset_i
    ,input logic        mem_to_reg_i
    ,input logic        branch_i        // to be pipelined until DEC stage
    ,input logic        pc_beq_i        // is only valid after DEC stage
    //,input logic        pc_bne_i
    ,input logic        b_alu_input_i
    ,input logic        reg_dst_rtrd_i
    ,input logic        enable_wreg_i
    ,input logic        enable_wmem_i
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
    ,output logic        enable_wmem_o
    ,output logic [5:0]  op_o6
    ,output logic [5:0]  funct_o6
    ,output logic        branch_o       // to be provided to controller once
                                        // zero_o is available at DEC stage
    );

    `include "defs/mips_defs.sv"

    // FIXME: beq & bne form complete set.

    // -------------------------------------------------------------------- //
    // LOGIC DECLR -------------------------------------------------------- //
    // -------------------------------------------------------------------- //

    // Fetch Stage -------------------------------------------------------- //
    
    // Stage Wires.
    logic [31:0] pc_plus4_lf32;

    // Hazard Detection Unit Wires.
    logic stall_lf;
    
    // Decode Stage ------------------------------------------------------- //

    // Pipelined Data.
    logic [31:0] instr_ld32;
    logic [31:0] pc_plus4_ld32;

    // Stage Wires.
    logic [31:0] rd1_ld32;
    logic [31:0] rd2_ld32;
    logic [31:0] sign_imm_ld32;
    logic [31:0] se_shamt_ld32;
    logic [31:0] pc_branch_ld32;

    // Hazard Detection Unit Wires.
    logic stall_ld;
    logic forward_rd1_ld;
    logic forward_rd2_ld;

    // Execute Stage ------------------------------------------------------ //

    // Pipelined Data.
    logic [5:0] funct_le6;
    logic [31:0] rd1_le32;
    logic [31:0] rd2_le32;
    logic [4:0]  rs_le5;
    logic [4:0]  rt_le5;
    logic [4:0]  rd_le5;
    logic [31:0] sign_imm_le32;
    logic [31:0] se_shamt_le32;

    // Pipelined Controls.
    logic enable_wreg_le;
    logic mem_to_reg_le;
    logic enable_wmem_le;
    logic [1:0] alu_alt_ctrl_le2;
    logic b_alu_input_le;
    logic apply_shift_le;
    logic reg_dst_rtrd_le;

    // Stage Wires.
    logic [31:0] write_data_le32;
    logic [4:0]  dst_reg_addr_le5;
    logic [31:0] alu_out_le32;
    logic zero_le;

    // Hazard Detection Unit Wires.
    logic [1:0] forward_src_a_le2;
    logic [1:0] forward_src_b_le2;
    logic       flush_le;
    
    // Memory Stage ------------------------------------------------------- //

    // Pipelined Data.
    logic [31:0] alu_out_lm32;
    logic [31:0] write_data_lm32;
    logic [4:0] dst_reg_addr_lm5;

    // Pipelined Controls.
    logic enable_wreg_lm;
    logic mem_to_reg_lm;
    logic enable_wmem_lm;

    // Writeback Stage ---------------------------------------------------- //

    // Pipelined Data.
    logic [31:0] alu_out_lwb32;
    logic [31:0] read_data_lwb32;
    logic [4:0] dst_reg_addr_lwb5;

    // Pipelined Controls.
    logic enable_wreg_lwb;
    logic mem_to_reg_lwb;
    
    // Stage Wires.
    logic [31:0] res_lwb32;

    // -------------------------------------------------------------------- //
    // Hazard Unit -------------------------------------------------------- //
    // -------------------------------------------------------------------- //

    logic is_hazy_l;
    hazy_unit hu(
        // INPUTS
        .branch_id(branch_i)
        ,.mem_to_reg_ie(mem_to_reg_le)
        ,.enable_wreg_ie(enable_wreg_le)
        ,.mem_to_reg_im(mem_to_reg_lm)
        ,.enable_wreg_im(enable_wreg_lm)
        ,.enable_wreg_iwb(enable_wreg_lwb)

        ,.rs_id5(instr_ld32[25:21])
        ,.rt_id5(instr_ld32[20:16])

        ,.rs_ie5(rs_le5)
        ,.rt_ie5(rt_le5)

        ,.dst_reg_addr_ie5(dst_reg_addr_le5)
        ,.dst_reg_addr_im5(dst_reg_addr_lm5)
        ,.dst_reg_addr_iwb5(dst_reg_addr_lwb5)

        // OUTPUTS
        ,.is_hazy_o(is_hazy_l)
        ,.forward_rd1_o(forward_rd1_ld)
        ,.forward_rd2_o(forward_rd2_ld)
        ,.forward_src_a_o2(forward_src_a_le2)
        ,.forward_src_b_o2(forward_src_b_le2)
    );

    // NOTE: for some reason these assigns are required?
    assign stall_lf = is_hazy_l;
    assign stall_ld = is_hazy_l;
    assign flush_le = is_hazy_l;

    // -------------------------------------------------------------------- //
    // Fetch Stage -------------------------------------------------------- //
    // -------------------------------------------------------------------- //
    
    fetch_stage fs(
        .clk_i(clk_i)
        ,.reset_i(reset_i)
        ,.is_hazy_i(stall_lf)
        ,.pc_beq_id(pc_beq_i)
        ,.pc_j_id(pc_j_i)
        ,.pc_branch_id32(pc_branch_ld32)
        ,.pc_plus4_id32(pc_plus4_ld32)
        ,.instr_id32(instr_ld32)

        ,.pc_o32(pc_o32)
        ,.pc_plus4_o32(pc_plus4_lf32)
    );

    // Stage Transition: FETCH -> DECODE.
    if_id_flopenr #(32) fd_flopenr(
        .clk_i(clk_i)
        ,.reset_i(reset_i)
        ,.flush_i(pc_beq_i)
        ,.en_i(!stall_ld)
        
        // FETCH
        ,.instr_if32(instr_i32)
        ,.pc_plus4_if32(pc_plus4_lf32)

        // DECODE
        ,.instr_od32(instr_ld32)
        ,.pc_plus4_od32(pc_plus4_ld32)
    );

    // -------------------------------------------------------------------- //
    // Decode Stage ------------------------------------------------------- //
    // -------------------------------------------------------------------- //

    decode_stage ds(
        .clk_i(clk_i)
        ,.branch_i(branch_i)
        ,.instr_id32(instr_ld32)
        ,.pc_plus4_id32(pc_plus4_ld32)
        ,.alu_out_im32(alu_out_lm32)
        ,.forward_rd1_id(forward_rd1_ld)
        ,.forward_rd2_id(forward_rd2_ld)
        ,.dst_reg_addr_iwb5(dst_reg_addr_lwb5)
        ,.res_iwb32(res_lwb32)
        ,.enable_wreg_iwb(enable_wreg_lwb)
        
        ,.branch_o(branch_o)
        ,.zero_o(zero_o)
        ,.op_o6(op_o6)
        ,.funct_o6(funct_o6)
        ,.rd1_o32(rd1_ld32)
        ,.rd2_o32(rd2_ld32)
        ,.pc_branch_o32(pc_branch_ld32)
        ,.sign_imm_o32(sign_imm_ld32)
        ,.se_shamt_o32(se_shamt_ld32)
    );

    // Stage Transition: DECODE -> EXECUTE.
    id_ex_flopr #(32) de_flopr (
        .clk_i(clk_i)
        ,.reset_i(reset_i)
        ,.flush_i(flush_le)

        // DECODE
        ,.funct_id6(instr_ld32[5:0])
        ,.rd1_id32(rd1_ld32)
        ,.rd2_id32(rd2_ld32)
        ,.rs_id5(instr_ld32[25:21])
        ,.rt_id5(instr_ld32[20:16])
        ,.rd_id5(instr_ld32[15:11])
        ,.sign_imm_id32(sign_imm_ld32)
        ,.se_shamt_id32(se_shamt_ld32)

        ,.enable_wreg_id(enable_wreg_i)
        ,.mem_to_reg_id(mem_to_reg_i)
        ,.enable_wmem_id(enable_wmem_i)
        ,.alu_alt_ctrl_id2(alu_alt_ctrl_i2)
        ,.b_alu_input_id(b_alu_input_i)
        ,.apply_shift_id(apply_shift_i)
        ,.reg_dst_rtrd_id(reg_dst_rtrd_i)

        // EXECUTE
        ,.funct_oe6(funct_le6)
        ,.rd1_oe32(rd1_le32)
        ,.rd2_oe32(rd2_le32)
        ,.rs_oe5(rs_le5)
        ,.rt_oe5(rt_le5)
        ,.rd_oe5(rd_le5)
        ,.sign_imm_oe32(sign_imm_le32)
        ,.se_shamt_oe32(se_shamt_le32)

        ,.enable_wreg_oe(enable_wreg_le)
        ,.mem_to_reg_oe(mem_to_reg_le)
        ,.enable_wmem_oe(enable_wmem_le)
        ,.alu_alt_ctrl_oe2(alu_alt_ctrl_le2)
        ,.b_alu_input_oe(b_alu_input_le)
        ,.apply_shift_oe(apply_shift_le)
        ,.reg_dst_rtrd_oe(reg_dst_rtrd_le)
    );

    // -------------------------------------------------------------------- //
    // Execute Stage ------------------------------------------------------ //
    // -------------------------------------------------------------------- //

    exec_stage es(
        .rd1_ie32(rd1_le32)
        ,.rd2_ie32(rd2_le32)
        ,.alu_out_im32(alu_out_lm32)
        ,.res_iwb32(res_lwb32)
        ,.forward_src_a_ie2(forward_src_a_le2)
        ,.forward_src_b_ie2(forward_src_b_le2)

        ,.rt_ie5(rt_le5)
        ,.rd_ie5(rd_le5)
        ,.reg_dst_rtrd_ie(reg_dst_rtrd_le)
        ,.sign_imm_ie32(sign_imm_le32)
        ,.se_shamt_ie32(se_shamt_le32)
        ,.apply_shift_ie(apply_shift_le)
        ,.b_alu_input_ie(b_alu_input_le)
        ,.funct_ie6(funct_le6)
        ,.alu_alt_ctrl_ie2(alu_alt_ctrl_le2)

        ,.write_data_o32(write_data_le32)
        ,.dst_reg_addr_o5(dst_reg_addr_le5)
        ,.alu_out_o32(alu_out_le32)
        ,.zero_o(zero_le)
    );

    // Stage Transition: EXECUTE -> MEM.
    ex_mem_flopr #(32) em_flopr(
        .clk_i(clk_i)
        ,.reset_i(reset_i)

        // EXECUTE
        ,.alu_out_ie32(alu_out_le32)
        ,.write_data_ie32(write_data_le32)
        ,.dst_reg_addr_ie5(dst_reg_addr_le5)

        ,.enable_wreg_ie(enable_wreg_le)
        ,.mem_to_reg_ie(mem_to_reg_le)
        ,.enable_wmem_ie(enable_wmem_le)

        // MEM
        ,.alu_out_om32(alu_out_lm32)
        ,.write_data_om32(write_data_lm32)
        ,.dst_reg_addr_om5(dst_reg_addr_lm5)

        ,.enable_wreg_om(enable_wreg_lm)
        ,.mem_to_reg_om(mem_to_reg_lm)
        ,.enable_wmem_om(enable_wmem_lm)
    );

    // -------------------------------------------------------------------- //
    // Memory Stage ------------------------------------------------------- //
    // -------------------------------------------------------------------- //

    // NOTE: read_data_i32 is read_data_im32.
    
    assign enable_wmem_o = enable_wmem_lm;
    assign alu_out_o32 = alu_out_lm32;
    assign write_data_o32 = write_data_lm32;

    // Stage Transition: MEM -> WB.
    mem_wb_flopr #(32) mem_wb_flopr(
        .clk_i(clk_i)
        ,.reset_i(reset_i)

        // MEM
        ,.alu_out_im32(alu_out_lm32)
        ,.read_data_im32(read_data_i32)
        ,.dst_reg_addr_im5(dst_reg_addr_lm5)

        ,.enable_wreg_im(enable_wreg_lm)
        ,.mem_to_reg_im(mem_to_reg_lm)

        // WB
        ,.alu_out_owb32(alu_out_lwb32)
        ,.read_data_owb32(read_data_lwb32)
        ,.dst_reg_addr_owb5(dst_reg_addr_lwb5)

        ,.enable_wreg_owb(enable_wreg_lwb)
        ,.mem_to_reg_owb(mem_to_reg_lwb)
    );

    // -------------------------------------------------------------------- //
    // Writeback Stage ---------------------------------------------------- //
    // -------------------------------------------------------------------- //

    mux2 #(32) res_mux(alu_out_lwb32, read_data_lwb32, mem_to_reg_lwb,
                       res_lwb32);



    // TODO: remove when done with op implementations.
    always @(posedge clk_i)
    begin
        // FIXME: BEQ is causing issues with pipeline hazards.
        $display("\n\n");
        $display("instr_ld32: %b", instr_ld32);
        case(instr_ld32[31:26])
            `INSTR_RTYPE: $display("RTYPE"); 
            `INSTR_LW:    $display("LW");    
            `INSTR_SW:    $display("SW");    
            `INSTR_BEQ:   $display("BEQ");
            `INSTR_BNE:   $display("BNE");  
            `INSTR_J:     $display("J");     
            `INSTR_ADDI:  $display("ADDI"); 
            `INSTR_SLTI:  $display("SLTI");  
            default: $display("What you doin bruh!!?");
        endcase

        if (instr_ld32[5:0] == `FUNCT6_SLL && instr_ld32[31:26] == `INSTR_RTYPE)
        begin
            $display("INSTR_SLL");
            //$display("src_a_le32 value: ", src_a_le32);
            //$display("src_a_le32 value binary: %b", src_a_le32);
            //$display("src_b_le32 value: ", src_b_le32);
            //$display("src_b_le32 value: binary: %b", src_b_le32);
            $display("se_shamt_le32: ", se_shamt_le32);
            $display("alu_out_o32: ", alu_out_o32);
            $display("res_lwb32: ", res_lwb32);
            $display("res_lwb32: binary: %b", res_lwb32);
            $display("write_data_o32: ", write_data_o32);
            $display("write_data_o32: binary: %b", write_data_o32);
            $display("apply_shift_le: ", apply_shift_le);
            $display("enable_wreg_lwb: ", enable_wreg_lwb);
            $display("dst_reg_addr_lwb5 ", dst_reg_addr_lwb5);
        end

        else if (instr_ld32[5:0] == `FUNCT6_SRL && instr_ld32[31:26] == `INSTR_RTYPE)
        begin
            $display("INSTR_SRL");
            //$display("src_a_le32 value: ", src_a_le32);
            //$display("src_a_le32 value binary: %b", src_a_le32);
            //$display("src_b_le32 value: ", src_b_le32);
            //$display("src_b_le32 value: binary: %b", src_b_le32);
            $display("se_shamt_le32: ", se_shamt_le32);
            $display("alu_out_o32: ", alu_out_o32);
            $display("res_lwb32: ", res_lwb32);
            $display("res_lwb32: binary: %b", res_lwb32);
            $display("write_data_o32: ", write_data_o32);
            $display("write_data_o32: binary: %b", write_data_o32);
            $display("apply_shift_le: ", apply_shift_le);
            $display("enable_wreg_lwb: ", enable_wreg_lwb);
            $display("dst_reg_addr_lwb5 ", dst_reg_addr_lwb5);
        end

        else if (instr_ld32[31:26] == `INSTR_SW)
        begin
            $display("INSTR_SW");
            //$display("src_a_le32 value: ", src_a_le32);
            //$display("src_a_le32 value binary: %b", src_a_le32);
            //$display("src_b_le32 value: ", src_b_le32);
            //$display("src_b_le32 value: binary: %b", src_b_le32);
            $display("se_shamt_le32: ", se_shamt_le32);
            $display("alu_out_o32: ", alu_out_o32);
            $display("res_lwb32: ", res_lwb32);
            $display("res_lwb32: binary: %b", res_lwb32);
            $display("write_data_o32: ", write_data_o32);
            $display("write_data_o32: binary: %b", write_data_o32);
            $display("apply_shift_le: ", apply_shift_le);
            $display("enable_wreg_lwb: ", enable_wreg_lwb);
            $display("dst_reg_addr_lwb5 ", dst_reg_addr_lwb5);
        end

        else if (instr_ld32[31:26] == `INSTR_LW)
        begin
            $display("INSTR_LW");
            //$display("src_a_le32 value: ", src_a_le32);
            //$display("src_a_le32 value binary: %b", src_a_le32);
            //$display("src_b_le32 value: ", src_b_le32);
            //$display("src_b_le32 value: binary: %b", src_b_le32);
            $display("se_shamt_le32: ", se_shamt_le32);
            $display("alu_out_o32: ", alu_out_o32);
            $display("res_lwb32: ", res_lwb32);
            $display("res_lwb32: binary: %b", res_lwb32);
            $display("write_data_o32: ", write_data_o32);
            $display("write_data_o32: binary: %b", write_data_o32);
            $display("apply_shift_le: ", apply_shift_le);
            $display("enable_wreg_lwb: ", enable_wreg_lwb);
            $display("dst_reg_addr_lwb5 ", dst_reg_addr_lwb5);
        end
        else if (instr_ld32[31:26] == `INSTR_J)
            $display("JUMPING BRUH");
        else
        begin
            $display("NO MATCH FOUND");
            $display("INSTR IS: ");
            case (instr_ld32[31:26])
                `INSTR_ADDI: $display("INSTR_ADDI");
                `INSTR_BEQ: $display("INSTR_BEQ");
                `INSTR_BNE: $display("INSTR_BNE");
                default: $display("NO CASE");
            endcase
        end
    end
endmodule
