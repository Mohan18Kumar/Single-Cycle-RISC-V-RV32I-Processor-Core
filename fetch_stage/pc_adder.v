// Adder -> to move to next instruction (PC+4) or move to branch instruction (PC+offset)

`timescale 1ns / 1ps

module pc_adder(
    input wire  [31:0] a,
    input wire  [31:0] b,
    output wire [31:0] y
);
    assign y = a + b;
endmodule
