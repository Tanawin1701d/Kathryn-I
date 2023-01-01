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


## Work log


---

- 27/10/2022 chisel3 code generator has been draft. [util](https://github.com/https://github.com/Tanawin1701d/Kathryn-I/tree/util_chisel3/utils/generator)


## log below is retired due to language change and refactoring so, links be not be able to use.


- 14/10/2021 drafted block specification have been uploaded. [SPEC_DRAFT_1](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/old/Block_Description.ods)
- 03/11/2021 register manager(decoder and rob communication) of block specification file have been uploaded. [SPEC_DRAFT_1](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/old/Block_Description.ods)
- 03/11/2021 block diagram have been uploaded. [BLOCK_DIAGRAM](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/old/block_diagram.png)
- 17/11/2021 draft of decoder block have been uploaded. [decoder](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Decode/Decode.v)
- 14/12/2021 rewrite decoder specification have been uploaded. [decoder](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/old/Block_Description.ods)
- 15/12/2021 new decoder.v block have been uploaded. [decoder](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Decode/Decode.v)
- 16/12/2021 Extream Val finder block have been uploaded. [extV](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/TEMPLATE/Finder/Extream_val.v)
- 16/12/2021 storage cell template of resv station block have been uploaded. [Rsv_cell](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Reservation_station/TEMPLATE/Resv_cell.v)
- 21/12/2021 reservation station, tree mux, resv cell have been uploaded.
[rsv](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Reservation_station/TEMPLATE/Resv_cell.v) - [tr_mux](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/TEMPLATE/MUX/Mux.v) - [cell](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Reservation_station/TEMPLATE/Resv_cell.v)

- 23/12/2021 sign extend,execution, multiplication (pip0 alu)  have been uploaded.
[sextd](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/TEMPLATE/Int/Sign_ext.v) - [execution](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Alu/pip0/Execute.v) - [mul32](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Alu/pip0/Mul.v)

- 27/12/2021 div logic,scoreboard storage cell(template), scoreboard logic(incomplete)  have been uploaded.
[div](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Alu/pip1/DIV.v) - [cell](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Score_board/TEMPLATE/Scb_cell.v) - [scb](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Score_board/TEMPLATE/Scb.v)

- 29/12/2021 scoreboard storage cell(fixed pip specifier), scoreboard logic(finished draft), have been uploaded. reservation station bug(incorrect shifter distination) have been fixed.
[cell](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Score_board/TEMPLATE/Scb_cell.v) - [scb](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Score_board/TEMPLATE/Scb.v)
-[rsv](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Reservation_station/TEMPLATE/Resv_cell.v)
- 02/01/2022 control flow logic, fixed block_diagram3 have been uploaded [BLOCK_DIAGRAM](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/old/block_diagram3.jpg)-
[FLOW_LOGIC_DRAFT_1](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/Flow_Logic.ods)
- 05/01/2022 reservation for pip0-2 & pip3(only template copy) have been uploaded and fix decoder to support imm csr instruction . [pip](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Reservation_station)-[decoder](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Decode/Decode.v)
- 09/01/2022 reservation station for pip2(for load store operation) have been upload. [pip](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Reservation_station)
- 15/01/2022 Score board for pip0,1,3 have been upload , Decoder have been upgraded because fence instruction must be used. [scb](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Score_board) - [decoder](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/old/Decode/Decode.v) (reservation station 2 must be fixed.)
- 28/03/2022 block diagram have been fixed(deleted fence). [BLOCK_DESC_FIXED](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/old/Block_Description.ods)
- 12/06/2022 DUE TO SYSTEM COMPLEXITY, SO I REDESIGNED BY USING STRUCT AND NEW STATE DIAGRAMS TO ENCAPSULATE AND CLARIFY THE KATHRYN. [CORE_SPEC](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/core_spec.ods)
- 17/06/2022 add request interface from decoder to reg management specification [CORE_SPEC](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/core_spec.ods)
- 23/06/2022 add commit director interface specifications and refactor core spec files [CORE_SPEC](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/core_spec.ods)
- 25/06/2022 add control flow and reorder buffer interface specifications and refactor core spec files [CORE_SPEC](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/core_spec.ods)
- 10/07/2022 test generator to generate system verilog file finished [GENERATOR](https://github.com/Tanawin1701d/Kathryn-I/tree/master/utils/generator)
- 17/07/2022 draft new decoder [DECODER](https://github.com/Tanawin1701d/Kathryn-I/tree/master/src/core/decoder)

- 24/07/22 design decoder,rsv and rob specification [CORE_SPEC](https://1drv.ms/u/s!AkU-NTsj4vkJwz0SSvnzZAP8YSQY?e=W1C6hY)
- 07/08/22 design one hot free list + scoreboard rom + fix decoder bug [FREE_LIST](https://github.com/Tanawin1701d/Kathryn-I/blob/master/src/lib/freeList/)-[SCB_ROM](https://github.com/Tanawin1701d/Kathryn-I/blob/master/src/lib/scb_stable/)

- 08/08/22 drafing scoreboard cell and scoreboard communication [SCB_CELL](https://github.com/Tanawin1701d/Kathryn-I/blob/master/src/lib/scb_stable/)

- 11/08/22 drafing stable scoerboard [SCB]
(https://github.com/Tanawin1701d/Kathryn-I/blob/master/src/lib/scb_stable/)