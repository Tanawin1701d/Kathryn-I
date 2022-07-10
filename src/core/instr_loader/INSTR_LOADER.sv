`include "../interface/INTERFACE.sv"
`include "../var/VARIABLE.sv"



//$INSTR_LOADER_PRE

//@INSTR_LOADER_PRE




module (
     ST_BLK_G          inf_sb,  //provide state of the block
     CMD_BLK_G         inf_cb,  //command block
     TF_PC_TP1         inf_req_pc,  //for receive program counter(virtual program counter) from core control flow
     TF_ARC_INSTR_TRI1 inf_iss_instr  //for send transfer instruction data to decoder
);



//$INSTR_LOADER

//@INSTR_LOADER



endmodule



//$INSTR_LOADER_POST

//@INSTR_LOADER_POST




