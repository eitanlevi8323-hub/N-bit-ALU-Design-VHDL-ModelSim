========================================================================
ALU (Arithmetic Logic Unit) Implementation in VHDL - Project Readme
========================================================================

Project Overview:
-----------------
This project implements a comprehensive Arithmetic Logic Unit (ALU) in VHDL. The system accepts two data vectors (X and Y) of length n bits (generic and configurable), and performs arithmetic operations, bitwise logical operations, and shift operations on them.
The component yields a single result bus (ALUout) and is accompanied by four status flags: Carry (C), Overflow (V), Negative (N), and Zero (Z).

Architecture and Module Structure:
----------------------------------
The project is modularly structured into a clear hierarchy:

1. top.vhd (Top-Level Component):
   The central module that binds all sub-components together.
   Its role is to decode the 5-bit instruction (ALUFN) and route the information to the specific required module:
   - If the top two bits are "01", data is routed to AdderSub.
   - If the top two bits are "10", data is routed to Shifter.
   - If the top two bits are "11", data is routed to Logic.
   It also multiplexes the results back, manages the calculation of the global Z and N flags, and enforces a zeroed output with the Z flag set to 1 when an undefined instruction is passed.

2. AdderSub.vhd (Arithmetic Unit):
   Responsible for addition, subtraction (using 2's complement), negation (-X), increment (Y+2), and decrement (Y-2).
   The module operates over a continuous chain of Full Adders, calculates Carry-out independently, and identifies sign-bit exceptions to output the Overflow flag.

3. Logic.vhd (Logical Unit):
   Performs well-known bitwise Boolean operations: NOT, OR, AND, XOR, NOR, NAND, XNOR.

4. Shifter.vhd (Shift Unit):
   Performs physical shifting of bits to the left (SHL) and right (SHR) by a distance specified in the X vector.
   The module safely forwards the logically shifted-out bit into the system's Carry flag.

5. FA.vhd (Full Adder):
   The basic building block for establishing the arithmetic chain, allowing the binary addition of 2 bits along with Carry-in and Carry-out propagation.

6. aux_package.vhd:
   The package library that unifies all module component declarations, enabling clean integration within the Top-Level file.

Testbenches & Verification Environment:
---------------------------------------
To ensure the stability and reliability of the codebase, comprehensive testbenches were created for every essential part of the system:
- tb_ref1.vhd / tb_ref2.vhd: Hierarchical testbenches (for top-level components at 8-bit and 32-bit respectively) demonstrating full system integration. The testbench was extended to cover critical edge cases such as intentional Overflow, the execution of undefined commands across all modules, and max/min boundary matching.
- Isolated Testbenches: tb_adder_sub, tb_logic, and tb_shifter were created for module-specific simulation runs to verify that individual components correctly handle edge cases, properly capture "garbage" instructions by clearing the output, and prevent erroneous Carry generations.

ModelSim Compilation Instructions:
----------------------------------
A specific compilation order must be maintained for the project to compile smoothly without dependency errors:
1. aux_package.vhd
2. FA.vhd
3. AdderSub.vhd
4. Logic.vhd
5. Shifter.vhd
6. top.vhd
7. The respective testbenches (e.g. tb_ref1.vhd)

* Note: It is highly recommended to use the included ".do" configuration scripts (sim.do, sim_logic.do, etc.) to evaluate simulations and output list results (.lst) that are properly configured and free of redundant simulation Delta Cycles.
========================================================================
