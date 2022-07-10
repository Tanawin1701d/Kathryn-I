`include "../interface/INTERFACE.sv"
`include "../var/VARIABLE.sv"



//$CORE_CONTROL_FLOW_PRE

//@CORE_CONTROL_FLOW_PRE




module (
     ST_BLK_G    st,  //provide state of the block
     CMD_BLK_G   cmd,  //command block
     ST_BLK_G    st_INSTR_PAGE_WALKER,  //provide state of the block
     CMD_BLK_G   cmd_INSTR_PAGE_WALKER,  //command block
     TF_PC_TP1   selected_pc,  //command pc to instruction loader
     ST_BLK_G    st_INSTR_LOADER,  //provide state of the block
     CMD_BLK_G   cmd_INSTR_LOADER,  //command block
     ST_BLK_G    st_DECODER,  //provide state of the block
     CMD_BLK_G   cmd_DECODER,  //command block
     ST_BLK_G    st_RSV_1,  //provide state of the block
     CMD_BLK_G   cmd_RSV_1,  //command block
     ST_BLK_G    st_RSV_2,  //provide state of the block
     CMD_BLK_G   cmd_RSV_2,  //command block
     ST_BLK_G    st_RSV_3,  //provide state of the block
     CMD_BLK_G   cmd_RSV_3,  //command block
     ST_BLK_G    st_RSV_4,  //provide state of the block
     CMD_BLK_G   cmd_RSV_4,  //command block
     ST_BLK_G    st_REG_MNG,  //provide state of the block
     CMD_BLK_G   cmd_REG_MNG,  //command block
     ST_BLK_G    st_ROB,  //provide state of the block
     CMD_BLK_G   cmd_ROB,  //command block
     BC_COMMIT_G commit_stat  //receive in committing status
);



//$CORE_CONTROL_FLOW

//@CORE_CONTROL_FLOW



endmodule



//$CORE_CONTROL_FLOW_POST

//@CORE_CONTROL_FLOW_POST




