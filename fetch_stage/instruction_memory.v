// INSTRUCTION MEMORY
`timescale 1ns / 1ps

module instruction_memory (
    input  wire [31:0] read_address,
    output wire [31:0] instruction
);
    reg [31:0] mem [0:1023];  // 1024 locations (words), each word of size 32 bit

    // select 1 instruction from 1024 locations
    assign instruction = mem[read_address[11:2]];

    // read the text file containing hexadecimal numbers and populate the array mem
    initial begin
        $readmemh("D:/projects/processor/singlecycle/singlecycle/program.hex", mem);
    end

endmodule
