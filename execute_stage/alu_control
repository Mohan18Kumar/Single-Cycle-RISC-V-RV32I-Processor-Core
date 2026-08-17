// ALU CONTROL

`timescale 1ns / 1ps

module alu_control (
    input  wire [1:0] alu_op,
    input  wire [2:0] funct3,
    input  wire       funct7_bit5, // Instruction[30]
    output reg  [3:0] alu_ctrl
);

    always @(*) begin
        case (alu_op)
            2'b00: alu_ctrl = 4'b0010; // ADD (for Load/Store/ADDI)
            2'b01: alu_ctrl = 4'b0110; // SUB (for BEQ)
            2'b10: begin              // R-Type Instructions
                case (funct3)
                    3'b000: begin
                        if (funct7_bit5)
                            alu_ctrl = 4'b0110; // SUB
                        else
                            alu_ctrl = 4'b0010; // ADD
                    end
                    3'b110: alu_ctrl = 4'b0001; // OR
                    3'b111: alu_ctrl = 4'b0000; // AND
                    3'b010: alu_ctrl = 4'b0111; // SLT
                    default: alu_ctrl = 4'b0000;
                endcase
            end
            default: alu_ctrl = 4'b0010;
        endcase
    end

endmodule
