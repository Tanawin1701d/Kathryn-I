typedef struct packed{
    logic                    used;
    logic                    stable;
    logic[I_BL_EX_PIP -1:0]  pipId;
    logic[I_BL_EX_UNIT-1:0]  IndexAmt; // amount of block in related excecuted pipe -1
} PIPEINFO;


module ScbRom
#(
    parameter RSVID = 3'b0
)

(
    PIPEINFO io
);

    PIPEINFO[I_N_EX_PIP-1:0] rom;

    localparam RSV_NULL = 3'd0;// useless
    localparam RSV_1    = 3'd1;//ex and mul
    localparam RSV_2    = 3'd2;//div pipe
    localparam RSV_3    = 3'd3;//csr
    localparam RSV_4    = 3'd4;//load store


//init rom
    genvar i;
    always_comb begin
        case ( RSVID )
            RSV_NULL : begin 
                for (i = 0; i <I_N_EX_PIP; i++) begin rom[i].used <= 1'b0;  end
            end
            RSV_1 : begin 
                //execute unit              //multiple
                rom[0].used     <= 1'b1; /* */rom[1].used     <= 1'b1;
                rom[0].stable   <= 1'b1; /* */rom[1].stable   <= 1'b1;
                rom[0].pipId    <= 3'd1; /* */rom[1].pipId    <= 3'd2;
                rom[0].IndexAmt <= 3'd0; /* */rom[1].IndexAmt <= 3'd3;
                for (i = 2; i <I_N_EX_PIP; i++) begin rom[i].used <= 1'b0;  end
            end
            RSV_2 : begin 
                //div
                rom[0].used     <= 1'b1;
                rom[0].stable   <= 1'b0;
                rom[0].pipId    <= 3'd1;
                rom[0].IndexAmt <= 3'd0;
                for (i = 1; i <I_N_EX_PIP; i++) begin rom[i].used <= 1'b0;  end

            end
            RSV_3 : begin 
                rom[0].used     <= 1'b1;
                rom[0].stable   <= 1'b1;
                rom[0].pipId    <= 3'd1;
                rom[0].IndexAmt <= 3'd0;
                for (i = 1; i <I_N_EX_PIP; i++) begin rom[i].used <= 1'b0;  end

            end
            RSV_4 : begin 
                //load unit              //store
                rom[0].used     <= 1'b1; /* */rom[1].used     <= 1'b1;
                rom[0].stable   <= 1'b1; /* */rom[1].stable   <= 1'b1;
                rom[0].pipId    <= 3'd1; /* */rom[1].pipId    <= 3'd2;
                rom[0].IndexAmt <= 3'd0; /* */rom[1].IndexAmt <= 3'd0;
                for (i = 2; i <I_N_EX_PIP; i++) begin rom[i].used <= 1'b0;  end
            end
            default : begin 
                for (i = 0; i <I_N_EX_PIP; i++) begin rom[i].used <= 1'b0;  end
            end
        endcase
    end

//request rom data
    genvar i;
    
    for (i = 0; i < I_N_EX_PIP; i++)begin
        
        if ( rom[i].used && (rom[i].pipId == io.pipId) )begin
            assign io.used     = rom[i].used;
            assign io.stable   = rom[i].stable;
            assign io.IndexAmt = rom[i].IndexAmt;
        end
    
    end
    
///////

endmodule