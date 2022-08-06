/////////////////////////////////////


/////////////////////////////////////
typedef struct packed {
      logic[I_BL_MARC_CREG -1: 0] i_preg_rb1;//address/index of control status register that wish to broadcast. [address 0 is implicit rule when did not want to broadcast data ]
      logic[D_BL_MARC_CREG -1: 0] d_preg_rb1;//data of control status register that wish to broadcast.

} BC_CREG_G;
/////////////////////////////////////


/////////////////////////////////////
/////////////////////////////////////


/////////////////////////////////////
typedef struct packed {
      logic[I_BL_MARC_REG -1: 0] i_preg_rb1;//address/index of physical register that wish to broadcast. [address 0 is implicit rule when did not want to broadcast data ]
      logic[I_BL_ARC_REG  -1: 0] i_areg_rb1;//address/index of architecture register that preg refer to.
      logic[D_BL_MARC_REG -1: 0] d_preg_rb1;//data of physical register that wish to broadcast.

} BC_PREG_G;
/////////////////////////////////////


/////////////////////////////////////
/////////////////////////////////////


/////////////////////////////////////
typedef struct packed {
      logic[D_BL_MARC_REG  -1: 0] d_preg_rd;//hold data which represent the register value
      logic[I_BL_MARC_CREG -1: 0] i_creg_rc;//address of control status register
      logic[I_BL_ARC_PC    -1: 0] i_arch_nextPc;//hold correct next program counter
      logic[I_BL_MEM_ADDR  -1: 0] i_mem_addr;//how memory address which will be sent to load store unit
      logic[I_BL_TRAPC     -1: 0] s_trapC;//hold trap cause for current instruction

} TF_ROB_FILL_ERF1;
/////////////////////////////////////


/////////////////////////////////////
/////////////////////////////////////


/////////////////////////////////////
typedef struct packed {
      logic[I_BL_MARC_REG  -1: 0] i_preg_rd;//Destination physical register address 
      logic[I_BL_MARC_REG  -1: 0] i_preg_r1;//r1 physical register address
      logic[I_BL_MARC_REG  -1: 0] i_preg_r2;//r2 physical register address
      logic[1              -1: 0] s_preg_r1;//valid index that data for r1 id valid right now.
      logic[1              -1: 0] s_preg_r2;//valid index that data for r2 id valid right now.
      logic[D_BL_MARC_REG  -1: 0] d_preg_r1;//data of physical reg r1
      logic[D_BL_MARC_REG  -1: 0] d_preg_r2;//data of physical reg r2
      logic[D_BL_MARC_IMM  -1: 0] d_imm;//immediate value that was specified from instruction.
      logic[I_BL_MARC_CREG -1: 0] i_creg_r1;//control status register address
      logic[I_BL_MARC_PIP  -1: 0] i_pip;//index of reservation station
      logic[D_BL_MARC_OP   -1: 0] c_op;//Micro-opcode
      TF_PC_TP1                   PC;//for transfer program counter and privilege.

} TF_MARC_INSTR_TMI1;
/////////////////////////////////////


/////////////////////////////////////
/////////////////////////////////////


/////////////////////////////////////
typedef struct packed {
      logic[1 -1: 0] c_store;//Guild committer to store data in physical register to memory
      logic[1 -1: 0] c_load;//Guild committer to load data from memory to architectural register
      logic[1 -1: 0] c_ptoa_reg;//guild committer to store data from physical register to architectural register
      logic[1 -1: 0] c_ctoa_reg;//guild committer to load data from control status register to architectural register
      logic[1 -1: 0] c_atoc_reg;//guild committer to load data from architectural register to control status register

} CMD_COMMIT_DIRECTOR_G;
/////////////////////////////////////


/////////////////////////////////////
/////////////////////////////////////


/////////////////////////////////////
typedef struct packed {
      logic[D_BL_ARC_INSTR -1: 0] d_instr;//architecture instruction

} TF_ARC_INSTR_TRI1;
/////////////////////////////////////


/////////////////////////////////////
/////////////////////////////////////


/////////////////////////////////////
typedef struct packed {
      logic[I_BL_ARC_REG  -1: 0] i_areg_rd;//destination architecture register[0 is implicit address when don’t want this register ]
      logic[I_BL_ARC_REG  -1: 0] i_areg_r1;//first architecture register address [0 is implicit address when don’t want this register ]
      logic[I_BL_ARC_REG  -1: 0] i_areg_r2;//second architecture register address [0 is implicit address when don’t want this register ]
      logic[1             -1: 0] c_req;//1 request reorder buffer and physical register
      logic[I_BL_ARC_PC   -1: 0] i_spec_pc;//address of later consecutive instruction that has been speculate.
      logic[I_BL_ARC_PVL  -1: 0] i_spec_pvl;//previlege of later consecutive instruction that has been speculate.
      logic[I_BL_MARC_PIP -1: 0] i_pip;//index of reservation station to tell rob
      logic[D_BL_MARC_OP  -1: 0] c_op;//Micro-opcode to store to rob
      logic[I_BL_MARC_REG -1: 0] i_preg_rd;//destination architecture register[0 is implicit address when don’t want this register ]
      logic[I_BL_MARC_REG -1: 0] i_preg_r1;//first architecture register address [0 is implicit address when don’t want this register ]
      logic[I_BL_MARC_REG -1: 0] i_preg_r2;//second architecture register address [0 is implicit address when don’t want this register ]
      logic[1             -1: 0] s_preg_r1;//specify that preg r1 data that give to decoder is valid; 1 is correct
      logic[1             -1: 0] s_preg_r2;//specify that preg r2 data that give to decoder is valid; 1 is correct. If the requestor did no intend to use r2 so the status use be set to 1
      logic[1             -1: 0] s_req_status;//status that book for rob is complete and assume that physical address can deliver in one cycle if not register manager should not book for rob(assume that every instruction need to book rob)
      logic[D_BL_MARC_REG -1: 0] d_preg_r1;//first architecture register address [0 is implicit address when don’t want this register ]
      logic[D_BL_MARC_REG -1: 0] d_preg_r2;//second architecture register address [0 is implicit address when don’t want this register ]

} COM_REGMNG_CALL_RDR1;
/////////////////////////////////////


/////////////////////////////////////
/////////////////////////////////////


/////////////////////////////////////
typedef struct packed {
      logic[I_BL_ARC_PC  -1: 0] i_pc;//program counter
      logic[I_BL_ARC_PVL -1: 0] i_pvl;//i_pc’s privilege machine Mode(0)Hypervision (1)User mode (2) 

} TF_PC_TP1;
/////////////////////////////////////


/////////////////////////////////////
/////////////////////////////////////


/////////////////////////////////////
typedef struct packed {
      logic[I_BL_ARC_PC   -1: 0] i_spec_pc;//address of later consecutive instruction that has been speculate.
      logic[I_BL_ARC_PVL  -1: 0] i_spec_pvl;//previlege of later consecutive instruction that has been speculate.
      logic[I_BL_ARC_REG  -1: 0] i_areg_rd;//sent to rob to tell what architecture that they should update when this called instruction has been committed.
      logic[I_BL_MARC_PIP -1: 0] i_pip;//index of reservation station to tell rob
      logic[D_BL_MARC_OP  -1: 0] c_op;//Micro-opcode to store to rob
      logic[1             -1: 0] c_req;//output wire to request area from rob which i_pip is used to specify the rob lane.
      logic[1             -1: 0] s_book;//book status from rob book complete(1) otherwise(0)
      logic[I_BL_MARC_REG -1: 0] i_preg_rd;//address/index of reorder buffer that correspond with booking if no booking or booking incomplete, the value can be anything.

} COM_ROB_INIT_RRR1;
/////////////////////////////////////


/////////////////////////////////////
/////////////////////////////////////


/////////////////////////////////////
typedef struct packed {
      logic[1 -1: 0] c_pause;//pause(stall) all state in the queue and hold the outcome for next cycle
      logic[1 -1: 0] c_reset;//clear all state and register to initial value at next positive edge.
      logic[1 -1: 0] c_clock;//clock signal
      logic[1 -1: 0] c_enable;//order the block to accept the input; 1 is enable, otherwise is 0;

} CMD_BLK_G;
/////////////////////////////////////


/////////////////////////////////////
/////////////////////////////////////


/////////////////////////////////////
typedef struct packed {
      logic[I_BL_MARC_REG -1: 0] i_preg_rd;//address/index of physical register that wish to store to reorder buffer. [implicit rule address 0 for don’t want to store to reorder ]
      logic[I_BL_EX_PIP   -1: 0] i_epip;//index of execution pipe in connected rsv which want to store data to[NO IMPLICCIT RULE FOR DUMMY PIPE HERE] rob

} CMD_ROB_FILL_CMF;
/////////////////////////////////////


/////////////////////////////////////
/////////////////////////////////////


/////////////////////////////////////
typedef struct packed {
      logic[1          -1: 0] s_enable;//status that rob is committing the instruction(1) Otherwise (0)
      logic[1          -1: 0] s_cur;//status that current committing instruction is no fault(1),  Otherwise (0)
      logic[I_BL_TRAPC -1: 0] s_cur_fcode;//fault code tell cause current instruction can’t commit but if enable is not set or current committing instruction isn’t fault this value can be anything. 
      logic[1          -1: 0] s_spec;//status that tell whether next instruction is speculated for properly address(1). Otherwise is(0). Please not that if current instruction isn’t in committing or got a fault declaration this value can be anything
      TF_PC_TP1               RECOV;//used  for transfer correct program counter when s_spec is mispredict.
      TF_PC_TP1               CUR;//used for transfer current address

} BC_COMMIT_G;
/////////////////////////////////////


/////////////////////////////////////
/////////////////////////////////////


/////////////////////////////////////
typedef struct packed {
      logic[1 -1: 0] s_input;//ready to accept(1) Refuse(0)
      logic[1 -1: 0] s_output;//output is occur(1) output is in-compute or dropped(0). 

} ST_BLK_G;
/////////////////////////////////////


/////////////////////////////////////
