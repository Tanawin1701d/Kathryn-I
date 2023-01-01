![](https://img.shields.io/badge/Status-In_development-orange.svg) ![](https://img.shields.io/badge/Author-Tanawin_devaveja-green.svg)
# Kathryn-I
## Upgradable Risc-V (RV32-I) based processor.

Purpose of Kathryn-I is
- build upgradable/understandable out-of-order superscalar to let other people who interests in computer architecture learns,contributes and upgrade to more sophisticated level cpu.

## Expected specification (phrase-I)

- The processor can execute unprivileged RV32-I instructions.
- Order of the processor must be IO2I (inorder decode, out of order issue and execute, inorder committed).
- The processor must commit the instruction at least 1 instr/cycle
- The processor has capable of sharing data between data and instruction memory.
- c++ generator must generate systemverilog template file for all major block.

## Expected specification (phrase-II) // Draft

- The processor can execute privileged RV32-I instructions.
- Order of the processor must be IO2I (inorder decode, out of order issue and execute, inorder committed).
- The processor must commit the instruction at least 2 instr/cycle.
- The processor has capable of sharing data between data and instruction memory.
- The processor has capable of communicating with inter-communication.
- ~~- The processor be able to implement on artix-7(basys-3)~~

## Block diagram
---
![](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/block_diagram.jpg?raw=true)


## Work log & Todo list


---
- - 31/12/2022 I design to refractor this project to be more component base design. So, earlier design to work log can be here [README_OLD](https://github.com/Tanawin1701d/Kathryn-I/tree/util_chisel3/utils/generator)
---

- 31/12/2022 component template for block building have been added to make chisel writing more group connectable. these component will be applied to new port design  [CORE_SPEC](https://github.com/Tanawin1701d/Kathryn-I/tree/compBase/SPECIFICATION/core_spec.ods)

- 31/12/2022 next I will finish my component based design and refractor port connect at chisel code.

- 1/1/2023 update core block link corresponds to [CORE_SPEC](https://github.com/Tanawin1701d/Kathryn-I/tree/compBase/SPECIFICATION/core_spec.ods).