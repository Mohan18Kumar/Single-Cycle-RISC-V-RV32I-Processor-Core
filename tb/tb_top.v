`timescale 1ns / 1ps

module tb_top;

    reg clk;
    reg rst;

    // Instantiate Full RISC-V Processor
    riscv_single_cycle top_cpu (
        .clk(clk),
        .rst(rst)
    );

    // Clock Generation (100 MHz)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;

        #12;
        rst = 0; // Release reset

        // Run processor for 10 clock cycles
        #100;

        // Verify registers inside the register file
        $display("\n===========================================");
        $display("          SIMULATION RESULTS               ");
        $display("===========================================");
        $display("x1 = %d (Expected: 5)",  top_cpu.decode.reg_file.registers[1]);
        $display("x2 = %d (Expected: 10)", top_cpu.decode.reg_file.registers[2]);
        $display("x3 = %d (Expected: 15)", top_cpu.decode.reg_file.registers[3]);
        $display("x4 = %d (Expected: 15)", top_cpu.decode.reg_file.registers[4]);
        $display("Mem[0] = %d (Expected: 15)", top_cpu.dmem.dmem[0]);
        $display("===========================================\n");

        $finish;
    end

endmodule
