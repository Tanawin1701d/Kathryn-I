


//$RSV_1_PRE

//@RSV_1_PRE




module RSV_1 (
     ST_BLK_G           con_st,  //provide state of the block
     CMD_BLK_G          con_cmd,  //
     CMD_ROB_FILL_CMF   con_fill,  //interface to communicate with rob for request to fill calculated data from execution units.
     TF_MARC_INSTR_TMI1 con_decoded_instr,  //decoded instruction derived from decoder.
     TF_MARC_INSTR_TMI1 con_execute_instr  //This port is used to broadcast to own execution unit
);



//$RSV_1









//@RSV_1



endmodule



//$RSV_1_POST

//@RSV_1_POST




