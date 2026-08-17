// TESTBENCH: decode stage
`timescale 1ns / 1ps

module tb_decode_stage;
    // Inputs to DUT
    reg        clk;
    reg [31:0] instruction;
    reg        reg_write_wb;
    reg [4:0]  write_reg_wb;
    reg [31:0] write_data_wb;

    // Outputs from DUT
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] imm_ext;
    wire        branch;
    wire        mem_read;
    wire        mem_to_reg;
    wire [1:0]  alu_op;
    wire        mem_write;
    wire        alu_src;
    wire        reg_write;

    // Instantiate Decode Stage
    decode_stage dut (
        .clk(clk),
        .instruction(instruction),
        .reg_write_wb(reg_write_wb),
        .write_reg_wb(write_reg_wb),
        .write_data_wb(write_data_wb),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .imm_ext(imm_ext),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reg_write_wb = 0;
        write_reg_wb = 0;
        write_data_wb = 0;
        instruction = 0;

        #10;

        // --- STEP 1: Write initial test data into Register x1 = 32'h00000042 ---
        reg_write_wb = 1;
        write_reg_wb = 5'd1;          // Target register x1
        write_data_wb = 32'h00000042; // Test value 66
        #10;                          // Clock edge writes to reg file
        reg_write_wb = 0;              // Disable write

        // --- TEST 1: Test R-Type instruction: add x3, x1, x0 ---
        // opcode=0110011, rs2=x0 (5'd0), rs1=x1 (5'd1), rd=x3 (5'd3)
        instruction = 32'b0000000_00000_00001_000_00011_0110011;
        #10;
        $display("--- TEST 1: R-Type (ADD) ---");
        $display("rs1 val=%h (Expected: 42), rs2 val=%h (Expected: 0)", read_data1, read_data2);
        $display("RegWrite=%b, ALUSrc=%b, ALUOp=%b", reg_write, alu_src, alu_op);

        // --- TEST 2: Test I-Type instruction: addi x2, x1, -5 ---
        // imm = -5 (12'hFFF), rs1=x1 (5'd1), opcode=0010011
        instruction = 32'b111111111011_00001_000_00010_0010011;
        #10;
        $display("\n--- TEST 2: I-Type (ADDI with imm=-5) ---");
        $display("rs1 val=%h, Immediate=%d (Expected: -5)", read_data1, $signed(imm_ext));
        $display("RegWrite=%b, ALUSrc=%b, ALUOp=%b", reg_write, alu_src, alu_op);

        // --- TEST 3: Test Load Instruction: lw x2, 8(x1) ---
        // imm = 8, rs1=x1, opcode=0000011
        instruction = 32'b000000001000_00001_010_00010_0000011;
        #10;
        $display("\n--- TEST 3: Load Word (LW) ---");
        $display("Immediate=%d, MemRead=%b, MemtoReg=%b", imm_ext, mem_read, mem_to_reg);

        // --- TEST 4: Test Branch Instruction: beq x1, x0, 16 ---
        // opcode=1100011
        instruction = 32'b0000000_00000_00001_000_10000_1100011;
        #10;
        $display("\n--- TEST 4: Branch Equal (BEQ) ---");
        $display("Branch=%b, RegWrite=%b, ALUOp=%b", branch, reg_write, alu_op);

        $finish;
    end

endmodule
