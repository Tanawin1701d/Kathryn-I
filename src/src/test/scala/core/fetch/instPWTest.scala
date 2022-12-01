package core_module

import chisel3._
import core_variable._
import core_bundle._

import chisel3.iotesters.PeekPokeTester

class INSTRUCTION_PAGE_WALKER_test(c: INSTRUCTION_PAGE_WALKER) extends PeekPokeTester(c){

    poke(c.io.cmd.c_pause , true)
    poke(c.io.cmd.c_reset , true)
    poke(c.io.cmd.c_enable, true)
    poke(c.io.inf_req_pc.i_pc , 0)
    poke(c.io.inf_req_pc.i_pvl, 0)
    expect(c.io.st.s_output, 0)
    expect(c.io.yy, 0)
    step(1)


}