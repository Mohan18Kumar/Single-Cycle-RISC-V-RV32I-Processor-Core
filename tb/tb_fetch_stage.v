// TESTBENCH: fetch stage
`timescale 1ns / 1ps

module tb_fetch_stage;
    // Signals to connect to the fetch stage
    reg        clk;
    reg        rst;
    reg        pc_src;
    reg [31:0] branch_target;

    wire [31:0] pc_out;
    wire [31:0] pc_plus_4;
    wire [31:0] instruction;

    // Instantiate the Fetch Stage module
    fetch_stage dut (
        .clk(clk),
        .rst(rst),
        .pc_src(pc_src),
        .branch_target(branch_target),
        .pc_out(pc_out),
        .pc_plus_4(pc_plus_4),
        .instruction(instruction)
    );

    // Clock Generation (100MHz -> 10ns period)
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        pc_src = 0;
        branch_target = 32'h0000_0020; // Example branch target: address 32 (0x20)

        // Hold reset for 12ns, then release
        #12;
        rst = 0;

        // --- TEST 1: Sequential Fetch (pc_src = 0) ---
        // Expecting PC = 0x00, 0x04, 0x08, 0x0C on consecutive clock edges
        #10; // PC = 0x00000000, instruction = 00500193
        #10; // PC = 0x00000004, instruction = 00a00213
        #10; // PC = 0x00000008, instruction = 004182b3

        // --- TEST 2: Branch Taken (pc_src = 1) ---
        // Simulate a taken branch to branch_target (0x00000020)
        pc_src = 1;
        #10; // On rising clock edge, PC should jump to 0x00000020

        // --- TEST 3: Return to Sequential Fetch ---
        pc_src = 0;
        #10; // PC should now be 0x00000024 (0x20 + 4)
        #10; // PC should be 0x00000028

        $display("Verification Complete!");
        $finish;
    end

    // Monitor outputs in console terminal
    initial begin
        $monitor("Time=%0t | rst=%b | pc_src=%b | PC=0x%h | PC+4=0x%h | Instruction=0x%h",
                 $time, rst, pc_src, pc_out, pc_plus_4, instruction);
    end

endmodule
