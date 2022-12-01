package core_module

import chisel3._
import core_variable._
import core_bundle._

class INSTRUCTION_PAGE_WALKER_IO extends Bundle{
    val st          = new ST_BLK_G //provide state of the block
    val cmd         = new CMD_BLK_G //command block
    val inf_req_pc  = new TF_PC_TP1 //for transfer program counter from core control flow
    val inf_iss_pc  = Flipped(new TF_PC_TP1) //for transfer program counter to INSTR_LOADER core control flow
}

class INSTRUCTION_PAGE_WALKER extends Module{
    //DUMMY INSTRUCTION_PAGE_WALKER. now return ready and pc is 0
    val io = IO(new INSTRUCTION_PAGE_WALKER_IO)

    // things we must update
    // st
    // inf_req_pc

    // things we must comply
    // cmd
    // inf_req_pc

    io.st.s_input       := 1.U
    io.st.s_output      := 1.U
    io.inf_iss_pc.i_pc  := 0.U
    io.inf_iss_pc.i_pvl := 0.U
    

}