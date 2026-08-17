// ALU

`timescale 1ns / 1ps

module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  alu_ctrl,
    output reg  [31:0] alu_result,
    output wire        zero
);

    always @(*) begin
        case (alu_ctrl)
            4'b0000: alu_result = a & b;                      // AND
            4'b0001: alu_result = a | b;                      // OR
            4'b0010: alu_result = a + b;                      // ADD
            4'b0110: alu_result = a - b;                      // SUB
            4'b0111: alu_result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLT
            default: alu_result = 32'b0;
        endcase
    end

    // Zero flag output for branch condition evaluating (a == b when a - b == 0)
    assign zero = (alu_result == 32'b0) ? 1'b1 : 1'b0;

endmodule
