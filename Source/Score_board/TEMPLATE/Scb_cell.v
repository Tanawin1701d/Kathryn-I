module Scb_cell
#(
  parameter W_ident        = 4,// there are 8 cells in each scoreboard but we use 4 bit, remain 1 bit for dump bit 
  parameter unused_cd      = {W_ident{1'b1}},
  parameter cell_ident     = 4'b0000,
  parameter W_inused       = 1,
  parameter W_pip          = 2,
  parameter W_PA_rx        = 5,
  parameter W_state        = 7,
  parameter V_FUT0         = 1, // อีก 1clock ได้ไหม
  parameter V_FUT1         = 4
)
(
    ////////////////// output
        ////////////// flag
        output wire[W_inused + W_pip + W_PA_rx-1:0] candit_wb,
        output wire[W_ident                   -1:0] candit_insert,
        output wire                                 ck_wbs_0, // check write back structural hazard
        output wire                                 ck_wbs_1, // check write back structural hazard
    ////////////////// input                                     
        input  wire[W_pip                     -1:0] i_pip,
        input  wire[W_PA_rx                   -1:0] i_rd_a,
        input  wire[W_state                   -1:0] i_state,
        input  wire[W_ident                   -1:0] addr_insert,
        ////////////// control flow                                   
        input  wire                                 CFI_PC_clear,
        input  wire                                 clk
);
        /////////////////////variable
        reg[W_inused-1:0] INUSED;
        reg[W_pip   -1:0] PIP;
        reg[W_PA_rx -1:0] RD;
        reg[W_state -1:0] STATE;
        //////////////////// bahaviour
        always@(posedge clk)begin
            if (CFI_PC_clear)begin
                INUSED <= 0;
            end else if (INUSED)begin
                if (STATE) // 
                    STATE  <= STATE - 1;
                else
                    INUSED <= 0;
            end else if ( addr_insert ==  cell_ident)begin
                INUSED <= 1;
                PIP    <= i_pip;
                RD     <= i_rd_a;
                STATE  <= i_state;
            end
        end         
        /////////////////// output
        assign candit_wb      = {INUSED & (STATE == 0),PIP       ,RD}; // max goal
        assign candit_insert  = {(~INUSED) ? cell_ident :  unused_cd  }; // min goal
        assign ck_wbs_0       = INUSED && (STATE != V_FUT0);
        assign ck_wbs_1       = INUSED && (STATE != V_FUT1);
        
endmodule