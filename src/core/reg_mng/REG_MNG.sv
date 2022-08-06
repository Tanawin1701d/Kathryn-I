


//$REG_MNG_PRE

//@REG_MNG_PRE




module REG_MNG (
     ST_BLK_G              st,  //provide state of the block
     CMD_BLK_G             cmd,  //
     COM_REGMNG_CALL_RDR1  dec,  //protocol to communicate with decoder for support decoder to booking reorder buffer.
     COM_ROB_INIT_RRR1     rob,  //protocol to allocate resource in rob.
     BC_PREG_G             brod_preg,  //use to update architecture register
     CMD_COMMIT_DIRECTOR_G rob_direc,  //use to guild rob whether how current booking instruction  should be commit
     CMD_COMMIT_DIRECTOR_G dec_direc  //use to pass current booking instruction commiting guild to rob
);



//$REG_MNG

//@REG_MNG



endmodule



//$REG_MNG_POST

//@REG_MNG_POST




