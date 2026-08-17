# Single-Cycle-RISC-V-RV32I-Processor-Core
Designed and verified a 32-bit RISC-V CPU in Verilog, integrating PC, Register File, ALU, Control Unit, and Memory modules. Validated R, I, S, and B-type instruction execution using modular testbenches and full-system simulation in Vivado.

# 1. Fetch Stage
- mux2x1
- pc_reg
- pc_adder
- instruction_memory

# 2. Decode Stage
- registers
- imm_gen
- control_unit

# 3. Execute Stage
- pc_adder
- mux2x1
- alu_control
- alu

# 4. Memory
- data_memory

# 5. Write Back
- mux2x1

  

<img width="1044" height="785" alt="image" src="https://github.com/user-attachments/assets/fae82c58-17cf-4a2f-b50d-6d46559b5822" />
Fig. RISCv Single Cycle Processor


# REFERENCES
1. David Patterson and Hennesy, "Computer Organization and Design: RISCv Edition"
2. RISCV Green Card
3. Gemini AI (for better understanding the concepts)
