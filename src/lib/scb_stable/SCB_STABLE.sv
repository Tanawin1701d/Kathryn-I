typedef struct packed{

    reg valid;
    reg[I_BL_EX_PIP -1 :0] pipe_id;
    reg[I_BL_EX_UNIT -1:0] index;
    reg[I_BL_MARC_REG-1:0] i_preg_rd;

    //please denoted that for now if there are unstable pipe connected to the
    //resesrvation station, we must check that all pipe that connected to that
    // reservation station must be unstable pipe too.
    //So, score board and score board cell won't be integrated to that reservation
    //station
} SCBCELL_STABLE;


typedef struct packed{
    logic[I_BL_EX_PIP-1: 0] search_pip;   // indicate execution pipe that request instruction need to be issued out 
    logic                   available;    // scoreboard respond back wheather the instruction can issue
    logic                   req;          // reservation station controller request back that this instruction is issued and need to track (incase availiable)
    
}COM_SCBREQ_STABLE;




module SCB #
(
    parameter RSV_ID =  3'b0// I_BL_MARC_PIP 3
)
(
    // TODO for now we not sure that what we will connect to
)

localparam AMT_CELL = I_N_EX_PIP*I_BL_EX_UNIT;

SCBCELL_STABLE [AMT_CELL-1:0] scbTable;




    

endmodule