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


typedef struct packed{
    logic[I_BL_EX_PIP-1:   0]   insert_pip; //insert pip is implicit 0 for unwanted pipe
    logic[I_BL_MARC_REG-1: 0]   i_preg_rd;
} CMD_ROB_FILL;




module SCB #
(
    parameter RSV_ID =  3'b0// I_BL_MARC_PIP 3
)
(
    COM_SCBREQ_STABLE con_req; // to request scb entry and rsv will issue/broadcast instruction to execute unit directly
    CMD_ROB_FILL      con_cmd_fill;// scoreboard tell reorder buffer that which pipe should store to

)

localparam AMT_CELL = I_N_EX_PIP*I_BL_EX_UNIT + 1;

SCBCELL_STABLE [AMT_CELL-1:0] scbTable;



// check wheather there is tracked instruction which must commit in next concecutive posedge
genvar i;
for (i = 0; i < AMT_CELL; i++)begin
    if (scbTable[i].valid && ( scbTable[i].index == {I_BL_EX_UNIT{1'b0}}) )begin
        assign con_cmd_fill.insert_pip = scbTable[i].pipe_id;
        assign con_cmd_fill.i_preg_rd  = scbTable[i].i_preg_rd;
    end
end

// check can instruction issue now. for now we can assume that there are enough space to track instr
  //declare scoreboard rom
  PIPEINFO pip_info; 
  assign pip_info.pipId = con_req.search_pip;
  ScbRom(pip_info);


logic[I_BL_EX_UNIT-1] i_preNew_index;





// save new instruction of we need

    

endmodule