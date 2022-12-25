package core_module

import chisel3._
import chisel3.experimental.ChiselEnum
import core_variable._ 
import core_bundle._ 



class DECODER_IO extends Bundle{
    val st            = new ST_BLK_G //provide state of the block
    val cmd           = new CMD_BLK_G //command block
    val arch_instr    = Flipped(new TF_ARC_INSTR_TRI1) //for receive instruction data from instruction loader
    val bc_preg       = new BC_PREG_G //this is used for update physical register data
    val res_call      = Flipped(new COM_REGMNG_CALL_RDR1) //this represent a protocol that decoder used to book for rob and provide some architecture register 
    val decoded_instr = new TF_MARC_INSTR_TMI1 //port used to broadcast data from decoder to reservation station.
    val commit_direct = new CMD_COMMIT_DIRECTOR_G //use to pass current booking instruction commiting guild to rob
    val arch_pc       = new TF_PC_TP1 //receive pc from instr loader
    val arch_spec_pc  = new TF_PC_TP1 //receive pc from instr loader
}

object DECODER_REG_REQ_STATUS extends ChiselEnum{
    val IDLE, REQ, READY, READY_IDX = Value
}

class DECODER extends Module{

    val io = IO(new DECODER_IO)
    // main wire
    val pipId         = Wire(UInt(VAR_CORE.I_BL_ARC_RPIP.W))
    var mop           = Wire(UInt(VAR_CORE.D_BL_MARC_OP.W))
    // main register

    // arch register
    var archInstr   = Reg(UInt(VAR_CORE.D_BL_ARC_INSTR.W))
    var archPc      = Reg(UInt(VAR_CORE.I_BL_ARC_PC.W))
    var archPvl     = Reg(UInt(VAR_CORE.I_BL_ARC_PVL.W))
    var archPcSpec  = Reg(UInt(VAR_CORE.I_BL_ARC_PC).W) 
    var archPvlSpec = Reg(UInt(VAR_CORE.I_BL_ARC_PVL.W))
    // register 1
    var reg1Data    = Reg(UInt(VAR_CORE.D_BL_MARC_REG.W))
    val reg1_state  = RegInit(DECODER_REG_REQ_STATUS.IDLE)
    var preg1Idx     = Reg(UInt(VAR_CORE.I_BL_MARC_REG.W))
    // register 2
    var reg2Data    = Reg(UInt(VAR_CORE.D_BL_MARC_REG.W))
    var reg2Idx     = Reg(UInt(VAR_CORE.I_BL_MARC_REG.W))
    val reg2_state  = RegInit(DECODER_REG_REQ_STATUS.IDLE)
    //state ready
    var subStateReadySync = ((reg1_state === DECODER_REG_REQ_STATUS.READY) || (reg1_state === DECODER_REG_REQ_STATUS.READY_IDX) && (io.bc_preg.i_preg_rb1 !== preg1Idx) ) &&
                            ((reg2_state === DECODER_REG_REQ_STATUS.READY) || (reg2_state === DECODER_REG_REQ_STATUS.READY_IDX) && (io.bc_preg.i_preg_rb2 !== reg2Idx) )
    //TODO assign wire default
    //TODO
    //decodedMeta

    
    // For now we use command line driven
    when (io.cmd.c_pause.asBool){
        //do nothing
    }.elsewhen(io.cmd.c_reset){
        //input
        arch_instr := 0.U;
        archPc     := 0.U;
        archPvl     = 0.U;
        archPcSpec := 0.U;
        archPvlSpec = 0.U;
        //register 1
        reg1Data   := 0.U;
        preg1Idx    := 0.U;
        reg1_state := DECODER_REG_REQ_STATUS.IDLE;
        //register 2
        reg2Data   := 0.U;
        reg2Idx    := 0.U;
        reg2_state := DECODER_REG_REQ_STATUS.IDLE;

    }.elsewhen(io.cmd.c_enable.asBool){
        //start to receive input from prior block.
        //input
        arch_instr := io.arch_instr.d_instr;
        archPc     := io.arch_pc.i_pc;
        archPcSpec := io.arch_spec_pc.i_pc;
        archPcSpec := io.arch_pc.i_pc.i_pvl;
        archPvlSpec = io.arch_spec_pc.i_pc.i_pvl;
        //register 1
        reg1Data   := 0.U;
        preg1Idx    := 0.U;
        reg1_state := DECODER_REG_REQ_STATUS.REQ;
        //register 2
        reg2Data   := 0.U;
        reg2Idx    := 0.U;
        reg2_state := DECODER_REG_REQ_STATUS.REQ;
        
    }.otherwise{
        //this mean this block is processing.

        // register 1 management
        when(reg1_state === DECODER_REG_REQ_STATUS.REQ){
            // send index to register 1
            io.res_call.i_areg_r1 := decodedMeta.i_areg_r1
            
            // assume that we have 1cycle register src

            // get idx of preg immediately back immediately
            preg1Idx    := io.res_call.i_preg_r1
            when (io.res_call.s_preg_r1.asBool ){
                // case we receive data together immediately
                reg1Data   := io.res_call.d_preg_r1
                reg1_state := DECODER_REG_REQ_STATUS.READY
            }.otherwise{
                // case we only receive only indx of physical register
                reg1Data   := 0.U
                reg1_state := DECODER_REG_REQ_STATUS.READY_IDX
            }
        }.elsewhen(reg1_state === DECODER_REG_REQ_STATUS.READY){
                // can be go to next state
                when(subStateReadySync){
                    when (!io.cmd.c_pause.asBool){
                        reg1_state := DECODER_REG_REQ_STATUS.REQ    
                    }.otherwise{
                        // case
                        reg1_state := DECODER_REG_REQ_STATUS.IDLE
                    }
                }
        }.elsewhen(reg1_state === DECODER_REG_REQ_STATUS.READY_IDX){
                when(io.bc_preg.i_preg_rb1 === preg1Idx ){
                    reg1Data   := io.bc_preg.d_preg_rb1
                    reg1_state := DECODER_REG_REQ_STATUS.READY
                    //we ensure that block will wait
                }.elsewhen(subStateReadySync){
                    when(!io.cmd.c_pause.asBool){
                        reg1_state := DECODER_REG_REQ_STATUS.REQ
                    }.otherwise{
                        reg1_state := DECODER_REG_REQ_STATUS.IDLE
                    }
                }

        //TODO do for r2 management 

        }.otherwise{
            printf("fatal: no register1 state")
        }

    }
    // output to io

    ////////////////////////////////////////////////////////////////////   

}