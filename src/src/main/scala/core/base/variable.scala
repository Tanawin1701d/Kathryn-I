package core_variable

import chisel3._

// <I = identifier D = data>_<BL - bitline  N - number>_< name >_<name>

object VAR_CORE {
    // identifier
    val I_BL_ARC_PC    =  32   //architecture program counter                      
    val I_N_ARC_PVL    =  4    //architecture privilege
    val I_BL_ARC_PVL   =  2    //architecture privilege
    val I_BL_ARC_REG   =  5    //size of index/address to identify arch register                        
    val I_BL_MARC_REG  =  6    //size of index/address to identify physical register                         
    val I_BL_MARC_CREG =  5    //size of index/address to identify control status register                          
    val I_BL_MARC_PIP  =  3    //size of index to identify execute pipes                        
    val I_BL_EX_PIP    =  3    //size of index to identify execution pips in connected in each reservation station.                      
    val I_N_EX_PIP     =  8    //Max number of execution pips in connected in each reservation station.                     
    val I_BL_EX_UNIT   =  3    //size of index to identify index of unit in execution pips in connected in each reservation station.                       
    val I_BL_TRAPC     =  8    //size of bit length to specify trap cause                     
    val I_N_PIP        =  4    //amount of reservation pipe                  
    val I_BL_MEM_ADDR  =  32   //size of bit length that represent address of memory                        
    // data
    val D_BL_ARC_INSTR =  32    //architecture instruction bit length
    val D_BL_MARC_REG  =  32    //size of each physical register
    val D_BL_MARC_CREG =  32    //size of each control status register
    val D_BL_MARC_IMM  =  32    //size of immediate value
    val D_BL_MARC_OP   =  6	    //size of microarchitecture op code
    val D_BL_MARC_PRIV =  2	    //size of bit that used for specify privilege

}