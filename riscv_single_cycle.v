// TOP MODULE: RISC-V single cycle processor

`timescale 1ns / 1ps

module riscv_single_cycle (
    input wire clk,
    input wire rst
);

    // --- WIRES ---

    // Fetch Stage Wires
    wire [31:0] pc;
    wire [31:0] pc_plus_4;
    wire [31:0] instruction;

    // Control Unit Wires
    wire        branch;
    wire        mem_read;
    wire        mem_to_reg;
    wire [1:0]  alu_op;
    wire        mem_write;
    wire        alu_src;
    wire        reg_write;

    // Decode Stage Wires
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] imm_ext;

    // Execute Stage Wires
    wire [31:0] branch_target;
    wire [31:0] alu_result;
    wire [31:0] write_data_mem;
    wire        zero;
    wire        pc_src;

    // Memory & Writeback Wires
    wire [31:0] mem_read_data;
    wire [31:0] write_data_wb;

    // --- 1. FETCH STAGE ---
    // PC Source logic: PC_src = Branch AND Zero
    assign pc_src = branch & zero;

    fetch_stage fetch (
        .clk(clk),
        .rst(rst),
        .pc_src(pc_src),
        .branch_target(branch_target),
        .pc_out(pc),
        .pc_plus_4(pc_plus_4),
        .instruction(instruction)
    );

    // --- 2. DECODE STAGE ---
    decode_stage decode (
        .clk(clk),
        .instruction(instruction),
        .reg_write_wb(reg_write),
        .write_reg_wb(instruction[11:7]), // rd field
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

    // --- 3. EXECUTE STAGE ---
    execute_stage execute (
        .pc(pc),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .imm_ext(imm_ext),
        .funct3(instruction[14:12]),
        .funct7_bit5(instruction[30]),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .branch_target(branch_target),
        .alu_result(alu_result),
        .write_data_mem(write_data_mem),
        .zero(zero)
    );

    // --- 4. DATA MEMORY STAGE ---
    data_memory dmem (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(alu_result),
        .write_data(write_data_mem),
        .read_data(mem_read_data)
    );

    // --- 5. WRITEBACK STAGE ---
    // Selects between ALU Result (0) and Memory Read Data (1)
    mux2x1 wb_mux (
        .d0(alu_result),
        .d1(mem_read_data),
        .sel(mem_to_reg),
        .y(write_data_wb)
    );

endmodule
