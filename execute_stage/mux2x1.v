// 2x 1 multiplexer

`timescale 1ns / 1ps

module mux2x1(
    input  wire [31:0] d0,  // sel = 0, PC = PC + 4
    input  wire [31:0] d1,  // sel = 1, pC = PC + offset
    input  wire        sel,
    output wire [31:0] y
);
    assign y = sel ? d1 : d0;
endmodule
