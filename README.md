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
~~- The processor be able to implement on artix-7(basys-3)~~

## Expected specification (phrase-II) // Draft

- The processor can execute privileged RV32-I instructions.
- Order of the processor must be IO2I (inorder decode, out of order issue and execute, inorder committed).
- The processor must commit the instruction at least 2 instr/cycle.
- The processor has capable of sharing data between data and instruction memory.
- The processor has capable of communicating with inter-communication.
~~- The processor be able to implement on artix-7(basys-3)~~

## Block diagram
![](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/block_diagram3.jpg?raw=true)


## Work log
- 14/10/2021 drafted block specification have been uploaded. [SPEC_DRAFT_1](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/Block_Description.ods)
- 03/11/2021 register manager(decoder and rob communication) of block specification file have been uploaded. [SPEC_DRAFT_1](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/Block_Description.ods)
- 03/11/2021 block diagram have been uploaded. [BLOCK_DIAGRAM](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/block_diagram.png)
- 17/11/2021 draft of decoder block have been uploaded. [decoder](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Decode/Decode.v)
- 14/12/2021 rewrite decoder specification have been uploaded. [decoder](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/Block_Description.ods)
- 15/12/2021 new decoder.v block have been uploaded. [decoder](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Decode/Decode.v)
- 16/12/2021 Extream Val finder block have been uploaded. [extV](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/TEMPLATE/Finder/Extream_val.v)
- 16/12/2021 storage cell template of resv station block have been uploaded. [Rsv_cell](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Reservation_station/TEMPLATE/Resv_cell.v)
- 21/12/2021 reservation station, tree mux, resv cell have been uploaded.
[rsv](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Reservation_station/TEMPLATE/Resv_cell.v) - [tr_mux](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/TEMPLATE/MUX/Mux.v) - [cell](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Reservation_station/TEMPLATE/Resv_cell.v)

- 23/12/2021 sign extend,execution, multiplication (pip0 alu)  have been uploaded.
[sextd](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/TEMPLATE/Int/Sign_ext.v) - [execution](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Alu/pip0/Execute.v) - [mul32](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Alu/pip0/Mul.v)

- 27/12/2021 div logic,scoreboard storage cell(template), scoreboard logic(incomplete)  have been uploaded.
[div](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Alu/pip1/DIV.v) - [cell](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Score_board/TEMPLATE/Scb_cell.v) - [scb](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Score_board/TEMPLATE/Scb.v)

- 29/12/2021 scoreboard storage cell(fixed pip specifier), scoreboard logic(finished draft), have been uploaded. reservation station bug(incorrect shifter distination) have been fixed.
[cell](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Score_board/TEMPLATE/Scb_cell.v) - [scb](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Score_board/TEMPLATE/Scb.v)
-[rsv](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Reservation_station/TEMPLATE/Resv_cell.v)
- 02/01/2022 control flow logic, fixed block_diagram3 have been uploaded [BLOCK_DIAGRAM](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/block_diagram3.jpg)-
[FLOW_LOGIC_DRAFT_1](https://github.com/Tanawin1701d/Kathryn-I/blob/master/SPECIFICATION/Flow_Logic.ods)
- 05/01/2022 reservation for pip0-2 & pip3(only template copy) have been uploaded and fix decoder to support imm csr instruction . [pip](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Reservation_station)-[decoder](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Decode/Decode.v)
- 09/01/2022 reservation station for pip2(for load store operation) have been upload. [pip](https://github.com/Tanawin1701d/Kathryn-I/blob/master/Source/Reservation_station)
