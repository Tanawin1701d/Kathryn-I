


//$RSV_2_PRE

//@RSV_2_PRE




module RSV_2 (
     ST_BLK_G           st,  //provide state of the block
     CMD_BLK_G          cmd,  //
     ST_BLK_G           st_div,  //div block status reciever
     CMD_BLK_G          cmd_div,  //
     CMD_ROB_FILL_CMF   fill,  //interface to communicate with rob for request to fill calculated data from execution units.
     TF_MARC_INSTR_TMI1 decoded_instr,  //decoded instruction derived from decoder.
     TF_MARC_INSTR_TMI1 execute_instr  //This port is used to broadcast to own execution unit
);



//$RSV_2

//@RSV_2



endmodule



//$RSV_2_POST

//@RSV_2_POST




