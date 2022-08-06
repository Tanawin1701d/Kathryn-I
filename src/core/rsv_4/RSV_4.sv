


//$RSV_4_PRE

//@RSV_4_PRE




module RSV_4 (
     ST_BLK_G           st,  //provide state of the block
     CMD_BLK_G          cmd,  //
     CMD_ROB_FILL_CMF   fill,  //interface to communicate with rob for request to fill calculated data from execution units.
     TF_MARC_INSTR_TMI1 decoded_instr,  //decoded instruction derived from decoder.
     TF_MARC_INSTR_TMI1 execute_instr  //This port is used to broadcast to own execution unit
);



//$RSV_4

//@RSV_4



endmodule



//$RSV_4_POST

//@RSV_4_POST




