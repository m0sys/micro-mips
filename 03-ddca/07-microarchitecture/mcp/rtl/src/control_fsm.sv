`timescale 1ns / 1ps
// Create Date: 11/04/2021

module controller_fsm(
    // INPUTS
    input logic         clk_i
    ,input logic        reset_i
    ,input [5:0]        op_i6

    // OUTPUTS
    ,output logic       mem_to_reg_o
    ,output logic       reg_dst_rtrd_o
    ,output logic       instr_or_data_o
    ,output logic [1:0] pc_branch_o2
    ,output logic [1:0] b_alu_input_o2
    ,output logic       a_alu_input_o
    ,output logic       instr_we_o
    ,output logic       enable_wmem_o
    ,output logic       pc_write_o
    ,output logic       branch_o
    ,output logic       enable_wrf_o
    ,output logic [1:0] alu_alt_ctrl_o2
    );

    `include "defs/mips_defs.sv"

    logic [14:0] ctrls_l15;

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
    
    assign {
        // Mux Selects
        mem_to_reg_o
        ,reg_dst_rtrd_o
        ,instr_or_data_o
        ,pc_branch_o2
        ,b_alu_input_o2
        ,a_alu_input_o

        // Register Enables
        ,instr_we_o
        ,enable_wmem_o
        ,pc_write_o
        ,branch_o
        ,enable_wrf_o
        ,alu_alt_ctrl_o2
    } = ctrls_l15;

    // State defs
    typedef enum logic [3:0] { 
        FETCH, DECODE, MEM_ADR, MEM_READ, MEM_WB,
        MEM_WRITE, EXECUTE, ALU_WB, BRANCH, ADDI_EXEC, ADDI_WB, JUMP
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
                ctrls_l15 <= 15'bxx0000101010000;
                nstate <= DECODE;
            end

            DECODE: // S1
            begin
                ctrls_l15 <= 15'bxxxxx1100000000;
                case (op_i6) inside
                    `INSTR_LW, `INSTR_SW: nstate <= MEM_ADR;
                    `INSTR_RTYPE: nstate <= EXECUTE;
                    `INSTR_BEQ: nstate <= BRANCH;
                    `INSTR_J: nstate <= JUMP;
                endcase
            end

            MEM_ADR: // S2
            begin
                ctrls_l15 <= 15'bxxxxx1010000000;
                case (op_i6)
                    `INSTR_LW: nstate <= MEM_READ;
                    `INSTR_SW: nstate <= MEM_WRITE;
                endcase
            end
            
            MEM_READ: // S3
            begin
                ctrls_l15 <= 15'bxx1xxxxx00000xx;
                nstate <= MEM_WB;
            end

            MEM_WB: // S4
            begin
                ctrls_l15 <= 15'b10xxxxxx00001xx;
                nstate <= FETCH;
            end

            MEM_WRITE: // S5
            begin
                ctrls_l15 <= 15'bxx1xxxxx01000xx;
                nstate <= FETCH;
            end

            EXECUTE: // S6
            begin
                ctrls_l15 <= 15'bxxxxx0010000010;
                nstate <= ALU_WB;
            end

            ALU_WB: // S7
            begin
                ctrls_l15 <= 15'b01xxxxxx00001xx;
                nstate <= FETCH;
            end

            ADDI_EXEC: // S9
            begin
                ctrls_l15 <= 15'bxxxxx1010000000;
                nstate <= ADDI_WB;
            end

            ADDI_WB: // S10
            begin
                ctrls_l15 <= 15'b00xxxxxx00001xx;
                nstate <= FETCH;
            end

            BRANCH: // S8
            begin
                ctrls_l15 <= 15'bxxx010010001001;
                nstate <= FETCH;
            end

            JUMP: // s10
            begin
                ctrls_l15 <= 15'bxxx10xxx00100xx;
                nstate <= FETCH;
            end
        endcase
endmodule
