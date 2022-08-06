


//$RSV_3_PRE

//@RSV_3_PRE




module RSV_3 (
     ST_BLK_G           st,  //provide state of the block
     CMD_BLK_G          cmd,  //
     CMD_ROB_FILL_CMF   fill,  //interface to communicate with rob for request to fill calculated data from execution units.
     TF_MARC_INSTR_TMI1 decoded_instr,  //decoded instruction derived from decoder.
     TF_MARC_INSTR_TMI1 execute_instr  //This port is used to broadcast to own execution unit
);



//$RSV_3

//@RSV_3



endmodule



//$RSV_3_POST

//@RSV_3_POST




