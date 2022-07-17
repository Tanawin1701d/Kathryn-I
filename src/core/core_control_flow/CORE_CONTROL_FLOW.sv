`include "../interface/INTERFACE.sv"
`include "../var/VARIABLE.sv"



//$CORE_CONTROL_FLOW_PRE

//@CORE_CONTROL_FLOW_PRE




module CORE_CONTROL_FLOW (
     ST_BLK_G    st,  //provide state of the block
     CMD_BLK_G   cmd,  //
     ST_BLK_G    st_INSTR_PAGE_WALKER,  //provide state of the block
     CMD_BLK_G   cmd_INSTR_PAGE_WALKER,  //
     TF_PC_TP1   selected_pc,  //
     ST_BLK_G    st_INSTR_LOADER,  //
     CMD_BLK_G   cmd_INSTR_LOADER,  //
     ST_BLK_G    st_DECODER,  //
     CMD_BLK_G   cmd_DECODER,  //
     ST_BLK_G    st_RSV_1,  //
     CMD_BLK_G   cmd_RSV_1,  //
     ST_BLK_G    st_RSV_2,  //
     CMD_BLK_G   cmd_RSV_2,  //
     ST_BLK_G    st_RSV_3,  //
     CMD_BLK_G   cmd_RSV_3,  //
     ST_BLK_G    st_RSV_4,  //
     CMD_BLK_G   cmd_RSV_4,  //
     ST_BLK_G    st_REG_MNG,  //
     CMD_BLK_G   cmd_REG_MNG,  //
     ST_BLK_G    st_ROB,  //
     CMD_BLK_G   cmd_ROB,  //
     BC_COMMIT_G commit_stat  //
);



//$CORE_CONTROL_FLOW

//@CORE_CONTROL_FLOW



endmodule



//$CORE_CONTROL_FLOW_POST

//@CORE_CONTROL_FLOW_POST




