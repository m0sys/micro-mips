`timescale 1ns / 1ps
// Create Date: 11/04/2021

module controller_fsm(
    // INPUTS
    input logic clk_i
    ,input logic reset_i
    ,input [5:0]  op_i6

    // OUTPUTS
    ,output logic mem_to_reg_o
    ,output logic reg_dst_rtrd_o
    ,output logic instr_or_data_o
    ,output logic pc_branch_o
    ,output logic [1:0] b_alu_input_o2
    ,output logic a_alu_input_o
    ,output logic instr_we_o
    ,output logic enable_wmem_o
    ,output logic pc_write_o
    ,output logic branch_o
    ,output logic enable_wrf_o
    ,output logic [1:0] alu_alt_ctrl_o2
    // ,output logic [13:0] ctrls_o14
    );

    `include "defs/mips_defs.sv"

    logic [13:0] ctrls_l14;

    // Control Order:
    //
    // Mux selects:
    //      mem_to_reg_o        (MemtoReg)
    //      reg_dst_rtrd_o      (RegDst)
    //      instr_or_data_o     (IorD)
    //      pc_branch_o         (PCSrc)
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
    
    assign {
        // Mux Selects
        mem_to_reg_o
        ,reg_dst_rtrd_o
        ,instr_or_data_o
        ,pc_branch_o
        ,b_alu_input_o2
        ,a_alu_input_o

        // Register Enables
        ,instr_we_o
        ,enable_wmem_o
        ,pc_write_o
        ,branch_o
        ,enable_wrf_o
        ,alu_alt_ctrl_o2
    } = ctrls_l14;

    // State defs
    typedef enum logic [3:0] { 
        FETCH, DECODE, MEM_ADR, MEM_READ, MEM_WB,
        MEM_WRITE, EXECUTE, ALU_WB, BRANCH
    } state_type;

    state_type state;
    state_type nstate;

    // State reg logic.
    always_ff @(posedge clk_i, posedge reset_i)
        if (reset_i) state <= FETCH;
        else         state <= nstate;

    // Next state logic.
    always_comb
        case (state)
            FETCH: // S0 
            begin
                ctrls_l14 <= 14'bxx000101010000;
                nstate <= DECODE;
            end

            DECODE: // S1
            begin
                ctrls_l14 <= 14'bxxxx1100000000;
                case (op_i6) inside
                    `INSTR_LW, `INSTR_SW: nstate <= MEM_ADR;
                    `INSTR_RTYPE: nstate <= EXECUTE;
                    `INSTR_BEQ: nstate <= BRANCH;
                endcase
            end

            MEM_ADR: // S2
            begin
                ctrls_l14 <= 14'bxxxx1010000000;
                case (op_i6)
                    `INSTR_LW: nstate <= MEM_READ;
                    `INSTR_SW: nstate <= MEM_WRITE;
            end
            
            MEM_READ: // S3
            begin
                ctrls_l14 <= 14'bxx1xxxx00000xx;
                nstate <= MEM_WB;
            end

            MEM_WB: // S4
            begin
                ctrls_l14 <= 14'b10xxxxx00001xx;
                nstate <= FETCH;
            end

            MEM_WRITE: // S5
            begin
                ctrls_l14 <= 14'bxx1xxxx01000xx;
                nstate <= FETCH;
            end

            EXECUTE: // S6
            begin
                ctrls_l14 <= 14'bxxxx0010000010;
                nstate <= ALU_WB;
            end

            ALU_WB: // S7
            begin
                ctrls_l14 <= 14'b01xxxxx00001xx;
                nstate <= FETCH;
            end

            BRANCH: // S8
            begin
                ctrls_l14 <= 14'bxxx10010001001;
                nstate <= FETCH;
            end
        endcase
endmodule
