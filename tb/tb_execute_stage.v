// TESTBENCH: execute stage

`timescale 1ns / 1ps

module tb_execute_stage;

    reg  [31:0] pc;
    reg  [31:0] read_data1;
    reg  [31:0] read_data2;
    reg  [31:0] imm_ext;
    reg  [2:0]  funct3;
    reg         funct7_bit5;
    reg         alu_src;
    reg  [1:0]  alu_op;

    wire [31:0] branch_target;
    wire [31:0] alu_result;
    wire [31:0] write_data_mem;
    wire        zero;

    execute_stage dut (
        .pc(pc),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .imm_ext(imm_ext),
        .funct3(funct3),
        .funct7_bit5(funct7_bit5),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .branch_target(branch_target),
        .alu_result(alu_result),
        .write_data_mem(write_data_mem),
        .zero(zero)
    );

    initial begin
        // Setup initial inputs
        pc          = 32'h0000_0004;
        read_data1  = 32'd10;
        read_data2  = 32'd10;
        imm_ext     = 32'd8;
        funct3      = 3'b000;
        funct7_bit5 = 1'b0;
        alu_src     = 1'b0;
        alu_op      = 2'b10; // R-Type

        #10;
        $display("--- TEST 1: ADD (10 + 10) ---");
        $display("ALU Result = %d (Expected: 20), Zero = %b", alu_result, zero);
        $display("Branch Target = 0x%h (Expected: 0x0C)", branch_target);

        // Test SUB (10 - 10 = 0) to check Zero flag
        funct7_bit5 = 1'b1; // SUB operation
        #10;
        $display("\n--- TEST 2: SUB (10 - 10) ---");
        $display("ALU Result = %d (Expected: 0), Zero = %b (Expected: 1)", alu_result, zero);

        // Test I-Type ADDI (10 + 8) with alu_src = 1
        alu_src = 1'b1;
        alu_op  = 2'b00; // I-Type
        #10;
        $display("\n--- TEST 3: ADDI (10 + Imm 8) ---");
        $display("ALU Result = %d (Expected: 18)", alu_result);

        $finish;
    end

endmodule
