package core_bundle

import chisel3._
import core_variable._
// host side


//block
class ST_BLK_G extends Bundle{
    val s_input  = Output (UInt(1.W)) //ready to accept(1) Refuse(0)
    val s_output = Output(UInt(1.W)) //output is occur(1) output is in-compute or dropped(0). 

}

//Needed bc data block
class BC_COMMIT_G extends Bundle{
    val s_enable     = Input(UInt(1.W))                   //status that rob is committing the instruction(1) Otherwise (0)
    val s_cur        = Input(UInt(1.W))                   //status that current committing instruction is no fault(1),  Otherwise (0)
    val s_cur_fcode  = Input(UInt(VAR_CORE.I_BL_TRAPC.W)) //fault code tell cause current instruction can’t commit but if enable is not set or current committing instruction isn’t fault this value can be anything. 
    val s_spec       = Input(UInt(1.W))                   //status that tell whether next instruction is speculated for properly address(1). Otherwise is(0). Please not that if current instruction isn’t in committing or got a fault declaration this value can be anything
    val RECOV        = Flipped(new TF_PC_TP1)               //used  for transfer correct program counter when s_spec is mispredict.
    val CUR          = Flipped(new TF_PC_TP1)               //used for transfer current address
}

//data block
class CMD_BLK_G extends Bundle{
    val c_pause      = Input(Bool()) //pause(stall) all state in the queue and hold the outcome for next cycle
    val c_reset      = Input(Bool()) //clear all state and register to initial value at next positive edge.
    //val c_clock      = Input(UInt(1.W)) //clock signal    [unused due to chisel lang]
    val c_enable     = Input(Bool()) //order the block to accept the input; 1 is enable, otherwise is 0;
}

//pc receiver
class TF_PC_TP1 extends Bundle{
    val i_pc         = Input(UInt(VAR_CORE.I_BL_ARC_PC.W )) //program counter
    val i_pvl        = Input(UInt(VAR_CORE.I_BL_ARC_PVL.W)) //i_pc’s privilege machine Mode(0)Hypervision (1)User mode (2) 

}

//sender block
class TF_ARC_INSTR_TRI1 extends Bundle{
    val d_instr      = Output(UInt(VAR_CORE.D_BL_ARC_INSTR.W))
}

//sender block
class TF_MARC_INSTR_TMI1 extends Bundle{
    val i_preg_rd    = Output(UInt(VAR_CORE.I_BL_MARC_REG.W )) //Destination physical register address 
    val i_preg_r1    = Output(UInt(VAR_CORE.I_BL_MARC_REG.W )) //r1 physical register address
    val i_preg_r2    = Output(UInt(VAR_CORE.I_BL_MARC_REG.W )) //r2 physical register address
    val s_preg_r1    = Output(UInt(1.W                      )) //valid index that data for r1 id valid right now.
    val s_preg_r2    = Output(UInt(1.W                      )) //valid index that data for r2 id valid right now.
    val d_preg_r1    = Output(UInt(VAR_CORE.D_BL_MARC_REG.W )) //data of physical reg r1
    val d_preg_r2    = Output(UInt(VAR_CORE.D_BL_MARC_REG.W )) //data of physical reg r2
    val d_imm        = Output(UInt(VAR_CORE.D_BL_MARC_IMM.W )) //immediate value that was specified from instruction.
    val i_creg_r1    = Output(UInt(VAR_CORE.I_BL_MARC_CREG.W)) //control status register address
    val i_pip        = Output(UInt(VAR_CORE.I_BL_MARC_PIP.W )) //index of reservation station
    val c_op         = Output(UInt(VAR_CORE.D_BL_MARC_OP.W  )) //Micro-opcode
    val PC           = Flipped(new TF_PC_TP1)                  //for transfer program counter and privilege.
}


//needed bc data block    broadcast physical register
class BC_PREG_G extends Bundle{
    val i_preg_rb1   = Input(UInt(VAR_CORE.I_BL_MARC_REG.W)) //address/index of physical register that wish to broadcast. [address 0 is implicit rule when did not want to broadcast data ] 
    val i_areg_rb1   = Input(UInt(VAR_CORE.I_BL_ARC_REG.W )) //address/index of architecture register that preg refer to.
    val d_preg_rb1   = Input(UInt(VAR_CORE.D_BL_MARC_REG.W)) //data of physical register that wish to broadcast.

}

//Needed bc data block
class BC_CREG_G extends Bundle{
    val i_preg_rb1  = Input(UInt(VAR_CORE.I_BL_MARC_CREG.W)) //address/index of control status register that wish to broadcast. [address 0 is implicit rule when did not want to broadcast data ]
    val d_preg_rb1  = Input(UInt(VAR_CORE.D_BL_MARC_CREG.W)) //data of control status register that wish to broadcast.
}

//REGMGM
class COM_REGMNG_CALL_RDR1 extends Bundle{
    val i_areg_rd       = Input (UInt(VAR_CORE.I_BL_ARC_REG.W )) //destination architecture register[0 is implicit address when don’t want this register ]             
    val i_areg_r1       = Input (UInt(VAR_CORE.I_BL_ARC_REG.W )) //first architecture register address [0 is implicit address when don’t want this register ]             
    val i_areg_r2       = Input (UInt(VAR_CORE.I_BL_ARC_REG.W )) //second architecture register address [0 is implicit address when don’t want this register ]             
    val c_req           = Input (UInt(1.W                     )) //1 request reorder buffer and physical register
    val i_spec_pc       = Input (UInt(VAR_CORE.I_BL_ARC_PC.W  )) //address of later consecutive instruction that has been speculate.             
    val i_spec_pvl      = Input (UInt(VAR_CORE.I_BL_ARC_PVL.W )) //previlege of later consecutive instruction that has been speculate.              
    val i_pip           = Input (UInt(VAR_CORE.I_BL_MARC_PIP.W)) //index of reservation station to tell rob         
    val c_op            = Input (UInt(VAR_CORE.D_BL_MARC_OP.W )) //Micro-opcode to store to rob        
    val i_preg_rd       = Output(UInt(VAR_CORE.I_BL_MARC_REG.W)) //destination architecture register[0 is implicit address when don’t want this register ]             
    val i_preg_r1       = Output(UInt(VAR_CORE.I_BL_MARC_REG.W)) //first architecture register address [0 is implicit address when don’t want this register ]             
    val i_preg_r2       = Output(UInt(VAR_CORE.I_BL_MARC_REG.W)) //second architecture register address [0 is implicit address when don’t want this register ]             
    val s_preg_r1       = Output(UInt(1.W                     )) //specify that preg r1 data that give to decoder is valid; 1 is correct             
    val s_preg_r2       = Output(UInt(1.W                     )) //specify that preg r2 data that give to decoder is valid; 1 is correct. If the requestor did no intend to use r2 so the status use be set to 1             
    val s_req_status    = Output(UInt(1.W                     )) //status that book for rob is complete and assume that physical address can deliver in one cycle if not register manager should not book for rob(assume that every instruction need to book rob)                    
    val d_preg_r1       = Output(UInt(VAR_CORE.D_BL_MARC_REG.W)) //first architecture register address [0 is implicit address when don’t want this register ]             
    val d_preg_r2       = Output(UInt(VAR_CORE.D_BL_MARC_REG.W)) //second architecture register address [0 is implicit address when don’t want this register ]             
}

//REGMGM
class COM_ROB_INIT_RRR1 extends Bundle{
    val i_spec_pc       = Output(UInt(VAR_CORE.I_BL_ARC_PC.W   )) //address of later consecutive instruction that has been speculate.
    val i_spec_pvl      = Output(UInt(VAR_CORE.I_BL_ARC_PVL.W  )) //previlege of later consecutive instruction that has been speculate.
    val i_areg_rd       = Output(UInt(VAR_CORE.I_BL_ARC_REG.W  )) //sent to rob to tell what architecture that they should update when this called instruction has been committed.
    val i_pip           = Output(UInt(VAR_CORE.I_BL_MARC_PIP.W )) //index of reservation station to tell rob
    val c_op            = Output(UInt(VAR_CORE.D_BL_MARC_OP.W  )) //Micro-opcode to store to rob
    val c_req           = Output(UInt(1.W                      )) //output wire to request area from rob which i_pip is used to specify the rob lane.
    val s_book          = Input (UInt(1.W                      )) //book status from rob book complete(1) otherwise(0)
    val i_preg_rd       = Input (UInt(VAR_CORE.I_BL_MARC_REG.W )) //address/index of reorder buffer that correspond with booking if no booking or booking incomplete, the value can be anything.
}

//REGMGM
class CMD_COMMIT_DIRECTOR_G extends Bundle{
    val c_store         = Output(UInt(1.W)) //Guild committer to store data in physical register to memory
    val c_load          = Output(UInt(1.W)) //Guild committer to load data from memory to architectural register
    val c_ptoa_reg      = Output(UInt(1.W)) //guild committer to store data from physical register to architectural register
    val c_ctoa_reg      = Output(UInt(1.W)) //guild committer to load data from control status register to architectural register
    val c_atoc_reg      = Output(UInt(1.W)) //guild committer to load data from architectural register to control status register
}

//RSV
class CMD_ROB_FILL_CMF extends Bundle{
    val i_preg_rd       = Output(UInt(VAR_CORE.I_BL_MARC_REG.W)) //address/index of physical register that wish to store to reorder buffer. [implicit rule address 0 for don’t want to store to reorder ]
    val i_epip          = Output(UInt(VAR_CORE.I_BL_EX_PIP.W  ))   //index of execution pipe in connected rsv which want to store data to[NO IMPLICCIT RULE FOR DUMMY PIPE HERE] rob
}

//EX

class TF_ROB_FILL_ERF1 extends Bundle{
    val d_preg_rd      = Output(UInt(VAR_CORE.D_BL_MARC_REG.W )) //hold data which represent the register value 
    val i_creg_rc      = Output(UInt(VAR_CORE.I_BL_MARC_CREG.W)) //address of control status register 
    val i_arch_nextPc  = Output(UInt(VAR_CORE.I_BL_ARC_PC.W   )) //hold correct next program counter 
    val i_mem_addr     = Output(UInt(VAR_CORE.I_BL_MEM_ADDR.W )) //how memory address which will be sent to load store unit 
    val s_trapC        = Output(UInt(VAR_CORE.I_BL_TRAPC.W    )) //hold trap cause for current instruction 

}