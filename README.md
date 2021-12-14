![](https://img.shields.io/badge/Status-In_development-orange.svg) ![](https://img.shields.io/badge/Author-Tanawin_devaveja-green.svg)
# Kathryn-I
## My first Risc-V (RV32-I) based processor.

Purpose of Kathryn-I is
- challenge my HDL implementation skills.
- enlighten & clarify my system on chip(soc) knowledges.
- may use for collaborate with other term project.

## Expected specification (phrase-I)

- The processor can execute unprivileged RV32-I instructions.
- Order of the processor must be IO2I (inorder decode, out of order issue and execute, inorder committed).
- The processor must commit the instruction at least 1 instr/cycle
- The processor has capable of sharing data between data and instruction memory.
- The processor be able to implement on artix-7(basys-3)

## Expected specification (phrase-II) // Draft

- The processor can execute privileged RV32-I instructions.
- Order of the processor must be IO2I (inorder decode, out of order issue and execute, inorder committed).
- The processor must commit the instruction at least 2 instr/cycle.
- The processor has capable of sharing data between data and instruction memory.
- The processor has capable of communicating with inter-communication.
- The processor be able to implement on artix-7(basys-3)

## Block diagram
![](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/block_diagram.png?raw=true)


## Work log
- 14/10/2021 drafted block specification have been uploaded. [SPEC_DRAFT_1](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/Block_Description.ods)
- 3/11/2021 register manager(decoder and rob communication) of block specification file have been uploaded. [SPEC_DRAFT_1](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/Block_Description.ods)
- 3/11/2021 block diagram have been uploaded. [BLOCK_DIAGRAM](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/block_diagram.png)
- 17/11/2021 draft of decoder block have been uploaded. [decoder](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Decode/Decode.v)
- 14/12/2021 rewrite decoder specification have been uploaded. [decoder](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/Block_Description.ods)
