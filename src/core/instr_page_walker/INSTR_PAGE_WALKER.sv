`include "../interface/INTERFACE.sv"
`include "../var/VARIABLE.sv"



//$INSTR_PAGE_WALKER_PRE

//@INSTR_PAGE_WALKER_PRE




module (
     ST_BLK_G  st,  //provide state of the block
     CMD_BLK_G cmd,  //command block
     TF_PC_TP1 inf_req_pc,  //for transfer program counter from core control flow
     TF_PC_TP1 inf_iss_pc  //for transfer program counter to INSTR_LOADER core control flow
);



//$INSTR_PAGE_WALKER

//@INSTR_PAGE_WALKER



endmodule



//$INSTR_PAGE_WALKER_POST

//@INSTR_PAGE_WALKER_POST




