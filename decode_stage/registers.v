// REGISTER FILE: RISC-V contains 32 registers of size 32 bits

`timescale 1ns / 1ps

module registers (
    input  wire        clk,
    input  wire        reg_write,     // Control signal to enable writing
    input  wire [4:0]  read_reg1,     // Instruction[19:15] (rs1)
    input  wire [4:0]  read_reg2,     // Instruction[24:20] (rs2)
    input  wire [4:0]  write_reg,     // Instruction[11:7]  (rd)
    input  wire [31:0] write_data,    // Data from WB stage
    output wire [31:0] read_data1,    // Value of rs1
    output wire [31:0] read_data2     // Value of rs2
);

    reg [31:0] registers [0:31];

    // Read logic: x0 always returns 0
    assign read_data1 = (read_reg1 == 5'd0) ? 32'b0 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 5'd0) ? 32'b0 : registers[read_reg2];

    // Synchronous write logic (prevent writing to x0)
    always @(posedge clk) begin
        if (reg_write && (write_reg != 5'd0)) begin
            registers[write_reg] <= write_data;
        end
    end

endmodule
