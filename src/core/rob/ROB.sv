`include "../interface/INTERFACE.sv"
`include "../var/VARIABLE.sv"



//$ROB_PRE

//@ROB_PRE




module (
     ST_BLK_G              st,  //provide state of the block
     CMD_BLK_G             cmd,  //command block
     CMD_ROB_FILL_CMF      fill_cmd_1,  //command to control fill to reorder buffer from resv1
     TF_ROB_FILL_ERF1      fill_data_x,  //fill data to rob1 (x)
     TF_ROB_FILL_ERF1      fill__data_mul3,  //fill data to rob (mul3)
     CMD_ROB_FILL_CMF      fill_cmd_2,  //command to control fill to reorder buffer from resv2
     TF_ROB_FILL_ERF1      fill_data_div,  //fill data to rob1 (div)
     CMD_ROB_FILL_CMF      fill_cmd_3,  //command to control fill to reorder buffer from resv3
     TF_ROB_FILL_ERF1      fill_data_cs,  //fill data to rob1 (cs)
     CMD_ROB_FILL_CMF      fill_cmd_4,  //command to control fill to reorder buffer from resv1
     TF_ROB_FILL_ERF1      fill_data_loader,  //fill data to rob1 (loader)
     TF_ROB_FILL_ERF1      fill__data_store,  //fill data to rob (store)
     BC_COMMIT_G           st_commit,  //tell commit status to control flow
     BC_PREG_G             bc_preg,  //broadcast preg which associate to arcch register
     COM_ROB_INIT_RRR1     instr_init,  //for communicating with register manager to init instruction
     CMD_COMMIT_DIRECTOR_G instr_drt  //for recv guild of how to commit instruction
);



//$ROB
drrgrfgfg
sdgdrffgfdg
//@ROB



endmodule



//$ROB_POST
erdtgrfgr
//@ROB_POST




