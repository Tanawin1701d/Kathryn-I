`include "../interface/INTERFACE.sv"
`include "../var/VARIABLE.sv"



//$DECODER_PRE

//@DECODER_PRE




module (
     ST_BLK_G              st,  //provide state of the block
     CMD_BLK_G             cmd,  //command block
     TF_ARC_INSTR_TRI1     arch_instr,  //for receive instruction data from instruction loader
     BC_PREG_G             ud_preg,  //this is used for update physical register data
     COM_REGMNG_CALL_RDR1  res_call,  //this represent a protocol that decoder used to book for rob and provide some architecture register 
     TF_MARC_INSTR_TMI1    decoded_instr,  //port used to broadcast data from decoder to reservation station.
     CMD_COMMIT_DIRECTOR_G commit_direct  //use to pass current booking instruction commiting guild to rob
);



//$DECODER

//@DECODER



endmodule



//$DECODER_POST

//@DECODER_POST




