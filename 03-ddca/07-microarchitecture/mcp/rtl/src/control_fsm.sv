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
    begin
        if (reset_i) state <= FETCH;
        else         state <= nstate;
        
    end

    // Next state logic.
    always_comb
        //---------------------------- FSM Spec ------------------------------ 
        // LW:    FETCH -> DECODE -> MEM_ADR   -> MEM_READ  -> MEM_WB -> FETCH 
        // SW:    FETCH -> DECODE -> MEM_ADR   -> MEM_WRITE -> FETCH
        // RTYPE: FETCH -> DECODE -> EXECUTE   -> ALU_WB    -> FETCH 
        // BEQ:   FETCH -> DECODE -> BRANCH    -> FETCH 
        // ADDI:  FETCH -> DECODE -> ADDI_EXEC -> ADDI_WB   -> FETCH 
        // J:     FETCH -> DECODE -> JUMP      -> FETCH 
        case (state)
            FETCH: // S0 
            // NOTE: PC can be thought of as IP (instruction pointer).
            //
            // Fetchs the instruction from memory at the address currently
            // held in the PC register. Then the instruction will be loaded 
            // into the IR register. Meanwhile, the PC is also incremented by
            // 4 to point to the next instruction. 
            // NOTE: the PC + 4 must be latched into the PC reg in this stage
            // of the instruction processing. I.e. ALUResult and ALUOut must
            // be the same by the end of this cycle. Furthermore, IR must no
            // longer change until FETCH is called once again.
            begin
                ctrls_l15 <= 15'bxx0000101010000;
                nstate <= DECODE;
            end

            DECODE: // S1
            // Decodes the instruction by first reading the register for the
            // two sources specified by the rs and rt fields in the instruction.
            // The readings are then latched into A and B registers.
            // Then the opcode is sent to this FSM to determine what signals
            // should be presented for the next state. (I.e. it decodes what 
            // the next state of this FSM is based on the opcode provided.)
            // 
            // In this stage we also compute the BEQ target branch by taking
            // the PC+4 computed at stage S0 and adding to it the immediate*4
            // using the ALU. The result is then stored in ALUOut. Notice that
            // since PC+4 and immediates are available during the posedge 
            // ALUOut will have no issues latching onto the computed target
            // address on the negedge of the clock.
            //
            // (I.e. This would not have worked if we were to use values
            // stored in A, B regsiters since the values would not have been
            // available until the negedge - hence, ALUOut would not have been
            // able to latch onto the results in the current cycle.)
            begin
                ctrls_l15 <= 15'bxxxxx1100000000;
                case (op_i6) inside
                    `INSTR_LW, `INSTR_SW: nstate <= MEM_ADR;
                    `INSTR_RTYPE: nstate <= EXECUTE;
                    `INSTR_BEQ: nstate <= BRANCH;
                    `INSTR_ADDI: nstate <= ADDI_EXEC;
                    `INSTR_J: nstate <= JUMP;
                    default:
                    begin
                        ctrls_l15 <= 15'bxxxxxxxxxxxxxxx;
                        nstate <= FETCH;
                    end
                endcase
            end

            MEM_ADR: // S2
            // If the instruction is a mem load or store (lw or sw) the 
            // mcp must compute the address by adding the base address to
            // the se immediate. Thus, the alu is exercised during this stage
            // of the process by performing an add operation. The computed
            // address is then stored in the ALUOut register for use on the 
            // next stage.
            begin
                ctrls_l15 <= 15'bxxxxx1010000000;
                case (op_i6)
                    `INSTR_LW: nstate <= MEM_READ;
                    `INSTR_SW: nstate <= MEM_WRITE;
                    default: 
                    begin
                        ctrls_l15 <= 15'bxxxxxxxxxxxxxxx;
                        nstate <= FETCH;
                    end
                endcase
            end
            
            MEM_READ: // S3
            // If the instruction is lw, mcp must now read data from memory 
            // and write the result of the read into the register file.
            // In this stage the memory is first read and saved in the Data
            // register.
            //
            // NOTE: no writing takes place in this stage.
            begin
                ctrls_l15 <= 15'bxx1xxxxx00000xx;
                nstate <= MEM_WB;
            end

            MEM_WB: // S4
            // Now we write back the contents of the Data register into the
            // register file.
            begin
                ctrls_l15 <= 15'b10xxxxxx00001xx;
                nstate <= FETCH;
            end

            MEM_WRITE: // S5
            // If the instruction is sw, the data from the second port of rf
            // is written to memory. 
            begin
                ctrls_l15 <= 15'bxx1xxxxx01000xx;
                nstate <= FETCH;
            end

            EXECUTE: // S6
            // Executes the instruction by selecting A, B registers and
            // performing the ALU operation specified by the funct field.
            // The ALUResult is then stored in ALUOut.
            //
            // NOTE: I think we need to really be calculating stuff on the
            // posedge of the clock and latching onto things on the negedge 
            // of the clock. That is the assumption that is implicitly being 
            // made based on most of the stage descriptions thus far. The
            // reason is because the FSM triggers on posedge - hence, the ALU
            // will be exercised on the posedge. However, if the latches also
            // happen on the posedge then the latch will not happen during
            // the current stage - but it will instead default to the very 
            // beginning of the next stage. Hence, the latching will always 
            // be one cycle behind on what the spec details. 
            //
            // (This explains why currently the instruction loading is one
            // cycle behind.)
            begin
                ctrls_l15 <= 15'bxxxxx0010000010;
                nstate <= ALU_WB;
            end

            ALU_WB: // S7
            // Writebacks the result stored in ALUOut into the register file.
            begin
                ctrls_l15 <= 15'b01xxxxxx00001xx;
                nstate <= FETCH;
            end

            BRANCH: // S8
            // In this stage the processor compares the two registers stored 
            // in A, B registers at stage S1 and checks if the result is 0.
            // If it is the processor branches to the destination address
            // that was computed by the ALU and stored in ALUOut at stage S1.
            begin
                ctrls_l15 <= 15'bxxx010010001001;
                nstate <= FETCH;
            end

            ADDI_EXEC: // S9
            // In this stage the contents of A register is added to SignImm 
            // and the results ALUResult is stored in ALUOut.
            //
            // NOTE: S2 and S9 are identical, thus they can be combined if
            // desired.
            begin
                ctrls_l15 <= 15'bxxxxx1010000000;
                nstate <= ADDI_WB;
            end

            ADDI_WB: // S10
            // The ALUOut computed at stage S9 is written to rf at the 
            // location specified by the rt field of the instruction.
            begin
                ctrls_l15 <= 15'b00xxxxxx00001xx;
                nstate <= FETCH;
            end

            JUMP: // s11
            // Writes PCJump into PC register by selecting it as PC'. 
            begin
                ctrls_l15 <= 15'bxxx10xxx00100xx;
                nstate <= FETCH;
            end
            default:
            begin
                ctrls_l15 <= 15'bxxxxxxxxxxxxxxx;
                nstate <= FETCH;
            end
        endcase

        // TODO: remove when done implementing all important opcodes.
        always @(posedge clk_i)
        begin
            $display("FSM: Current State: << S%d >>", state);
            //$display("FSM: Next State: << S%d >>", nstate);
            $display("FSM: Current ctrls: S%b", ctrls_l15);
            $display("FSM: SIGNALS:");
            $display("FSM: mem_to_reg_o:", mem_to_reg_o);
            $display("FSM: reg_dst_rtrd_o:", reg_dst_rtrd_o);
            $display("FSM: instr_or_data_o:", instr_or_data_o);
            $display("FSM: pc_branch_o2:", pc_branch_o2);
            $display("FSM: b_alu_input_o2:", b_alu_input_o2);
            $display("FSM: a_alu_input_o:", a_alu_input_o);
            $display("FSM: instr_we_o:", instr_we_o);
            $display("FSM: enable_wmem_o:", enable_wmem_o);
            $display("FSM: pc_write_o:", pc_write_o);
            $display("FSM: branch_o:", branch_o);
            $display("FSM: enable_wrf_o:", enable_wrf_o);
            $display("FSM: alu_alt_ctrl_o2:", alu_alt_ctrl_o2);
        end
endmodule
