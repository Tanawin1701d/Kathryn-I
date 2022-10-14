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
    logic[I_BL_EX_PIP-1: 0]  search_pip;   // indicate execution pipe that request instruction need to be issued out 
    logic                    available;    // scoreboard respond back wheather the instruction can issue
    logic[I_BL_MARC_REG-1:0] i_preg_rd;
    logic                    req;          // reservation station controller request back that this instruction is issued and need to track (incase available)
    
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
    COM_SCBREQ_STABLE con_req, // to request scb entry and rsv will issue/broadcast instruction to execute unit directly
    CMD_ROB_FILL      con_cmd_fill,// scoreboard tell reorder buffer that which pipe should store to
    CMD_BLK_G         con_cmd  //

)

localparam AMT_CELL     = I_N_EX_PIP*I_BL_EX_UNIT + 2; // for dummy and for next that have not issue yet
localparam dummy_pip    =  {I_BL_EX_PIP{ 1'b0 }};
localparam min_unit_idx = {I_BL_EX_UNIT{1'b0}};

SCBCELL_STABLE [AMT_CELL-1:0] scbTable;





// check instruction can be track check can instruction issue to execute unit now. 
//for now we can assume that there are enough space to track instr
  //declare scoreboard rom
  PIPEINFO pip_info; 
  assign pip_info.pipId = con_req.search_pip;
  ScbRom scb_rom(pip_info);


for (i = 0; i < AMT_CELL; i = i + 1)begin
    if ( scbTable[i].valid && 
         (scbTable[i].index != min_unit_idx) && // prevent substractor from usual behaviour
         ((scbTable[i].index -1) == pip_info.IndexAmt)
    )begin
        assign con_req.available = 0;
    end else if (i == AMT_CELL)begin
        assign con_req.available = 1;
    end
end

// check wheather there is tracked instruction which must commit in next concecutive posedge and detrack it

    genvar i;

    for (i = 0; i < AMT_CELL; i = i + 1)begin
        if (scbTable[i].valid && ( scbTable[i].index == min_unit_idx ) )begin
            assign con_cmd_fill.insert_pip = scbTable[i].pipe_id;
            assign con_cmd_fill.i_preg_rd  = scbTable[i].i_preg_rd;
        end else if (i == (AMT_CELL1-1)) begin
            assign con_cmd_fill.insert_pip = dummy_pip; //for there are no instruction to commit    
        end
    end

// update scoreboard cell

    //generate selector select the free
    logic[AMT_CELL-1:0] inputFreeList;
    logic[AMT_CELL-1:0] outputFreeList;
    selFl #(AMT_CELL) fr(inputFreeList, outputFreeList);
    for (i = 0; i < AMT_CELL; i = i + 1)begin
        assign inputFreeList[i] = ~scbTable[i].valid; // valid is not free
    end
    //select to tracked and //  detrack is implement in check instruction section above
    always @(posedge con_cmd.clk) begin

        for ( i = 0; i < AMT_CELL; i = i + 1)begin
            if (con_cmd.clear)begin
                    scbTable[i].valid <= 0;
            end if (con_req.available && con_req.req && outputFreeList[i])begin
                // output free list is director to direct which cell should be saved
                scbTable[i].valid     <= 1;
                scbTable[i].index     <= pip_info.IndexAmt;
                scbTable[i].i_preg_rd <= con_req.i_preg_rd; 
            end else if(scbTable[i].valid && ( scbTable[i].index == min_unit_idx )) begin
                // case this instruction is finish and auto commit to reorder buffer 
                // and the cell will be detach itself from the score board table
                scbTable[i].valid <= 0; 
            end else if (scbTable[i].valid) begin
                scbTable[i].index <= scbTable[i].index-1;
            end
            
        end
    end

    

endmodule