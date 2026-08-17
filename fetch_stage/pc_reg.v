// PROGRAM COUNTER

`timescale 1ns / 1ps

module pc_reg(
    input wire        clk,
    input wire        rst,
    input wire [31:0] pc_next,
    output reg [31:0] pc
);
    always @(posedge clk or posedge rst) begin
        if(rst)
            pc <= 32'h0000_0000;
        else
            pc <= pc_next;
    end
endmodule

