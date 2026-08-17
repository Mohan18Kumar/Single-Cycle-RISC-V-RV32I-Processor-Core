// DATA MEMORY : RAM

`timescale 1ns / 1ps

module data_memory (
    input  wire        clk,
    input  wire        mem_read,      // Control signal to enable reading
    input  wire        mem_write,     // Control signal to enable writing
    input  wire [31:0] address,       // ALU output
    input  wire [31:0] write_data,    // Read data 2 from Register File
    output wire [31:0] read_data      // Read data sent to Writeback Mux
);

    // 1024-word memory array (4KB)
    reg [31:0] dmem [0:1023];

    // Combinational Read (word-aligned using address[11:2])
    assign read_data = (mem_read) ? dmem[address[11:2]] : 32'b0;

    // Synchronous Write on clock edge
    always @(posedge clk) begin
        if (mem_write) begin
            dmem[address[11:2]] <= write_data;
        end
    end

endmodule
