package core_module

import chisel3._ 
import core_variable._ 
import core_bundle._ 

class INSTR_LOADER_IO extends Bundle{
    val st            = new ST_BLK_G //provide state of the block
    val cmd           = new CMD_BLK_G //command block
    val inf_req_pc    = new TF_PC_TP1 //for receive program counter(virtual program counter) from core control flow
    val inf_iss_instr = new TF_ARC_INSTR_TRI1 //for send transfer instruction data to decoder
    val iss_pc        = Flipped(new TF_PC_TP1) //send pc to decoder
    val iss_spec_pc   = Flipped(new TF_PC_TP1) //send spec pc to decoder
}


class INSTR_LOADER extends Module{
    val io = IO(new INSTR_LOADER_IO)

    // provide status
    io.st.s_input               := 1.U
    io.st.s_output              := 1.U
    // provide the loaded instruction
    io.inf_iss_instr.d_instr    := 0.U
    // provide this instruction's program counter and privilege
    io.iss_pc.i_pc              := 0.U
    io.iss_pc.i_pvl             := 0.U
    // provide speculated instr's program counter and privilege
    io.iss_spec_pc.i_pc         := 0.U
    io.iss_spec_pc.i_pvl        := 0.U

}