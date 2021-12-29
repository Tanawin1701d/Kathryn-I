`include"../../TEMPLATE/Finder/Extream_val.v"
`include"Scb.v"
module Scb
#(
/////////////////// address parameter ///////    
    parameter W_PA_REG       = 5,
    parameter W_AA_INSTR     = 32,
/////////////////// data parameter//////////
    parameter W_PD_UOPS      = 6,
/////////////////// selector
    parameter W_PC_SEL_RSV   = 2,
    parameter W_PC_SEL_WB    = 2,
    parameter W_PC_SEL_ODR   = 2,
/////////////////// default value
    parameter unused_op      = {W_PD_UOPS {1'b1}}, // unused op
    parameter unused_cd      = {W_ident{1'b1}},
    parameter unused_sel_rsv = {W_PC_SEL_RSV{1'b0}},
    parameter unused_sel_wb  = {W_PC_SEL_WB{1'b0}},
    parameter V_unpip        = 2'b00,
    parameter V_pip0         = 2'b01, 
    parameter V_pip1         = 2'b10,
/////////////////// default cell para
    parameter S_amt_cell     = 8,
    parameter W_ident        = 4,// there are 8 cells in each scoreboard but we use 4 bit, remain 1 bit for dump bit 
    parameter W_inused       = 1,
    parameter W_pip          = 2,
    parameter W_state        = 7,
/////////////////// excute pip length
    parameter S_amt_mul      = 4,
    parameter S_amt_ex       = 1
/////////////////// pip val
)
(
    ///////output cdo
        ///////// address
        output reg[W_PA_REG    -1:0] CDO_PC_rd,      // act as wire
        ///////// select
        output reg[W_PC_SEL_WB -1:0] CDO_PC_selwb,   //act as wire
        output reg[W_PC_SEL_RSV-1:0] CDO_PC_selrsv,  //act as wire
        /////////
    ////////input cdi
        /////////uops & data
        input  wire[W_PD_UOPS   -1:0] CDI_PD_uops0,
        input  wire[W_PD_UOPS   -1:0] CDI_PD_uops1,
        /////////address
        input  wire[W_PA_REG    -1:0] CDI_PD_rd0,
        input  wire[W_PA_REG    -1:0] CDI_PD_rd1,
        ///////// order
        input  wire[W_PC_SEL_ODR-1:0] CDI_PC_odr,
    //////// input cfi
        input  wire                   CFI_PC_clear,// mul pip is allowed;
        input  wire                   clk
);

        //wire for score board cell /////////////////////////////////////////////////////////////////////////////////////////
            wire[S_amt_cell * (W_inused + W_pip + W_PA_REG) -1:0] candit_wb;
            wire[S_amt_cell * (W_ident                    ) -1:0] candit_insert;
            wire[S_amt_cell                                 -1:0] ck_wbs_0; // check write back structural hazard
            wire[S_amt_cell                                 -1:0] ck_wbs_1; // check write back structural hazard
            // global input
            reg [W_pip                                      -1:0] i_pip;       //act as wire 
            reg [W_PA_REG                                   -1:0] i_rd_a;      //act as wire  
            reg [W_state                                    -1:0] i_state;     //act as wire
            reg [W_ident                                    -1:0] addr_insert; //act as wire
            // selected wire
            wire[W_ident                                    -1:0] selected_insert; // available cell address to store
            wire[W_inused + W_pip + W_PA_REG                -1:0] selected_wb;     // available set to write back
            

            // slice selected_wb
            wire[W_inused-1:0] selected_wb_inused;
            wire[W_pip   -1:0] selected_wb_pip;
            wire[W_PA_REG-1:0] selected_wb_address;
            assign {selected_wb_inused,selected_wb_pip,selected_wb_address} = selected_wb;
        // behaviour ////////////////////////////////////////////////////////////////////////////////////////////////////////
        // accept & insert data from reservation station
        always @(*) begin
            if ((CDI_PD_uops0 != unused_op) && (CDI_PD_uops1 != unused_op))begin
                case(CDI_PC_odr) 
                    2'b10   : begin // mul pip is allowed;
                                i_pip         <= V_pip1;
                                i_rd_a        <= CDI_PD_rd1;
                                i_state       <= S_amt_mul-1;
                                addr_insert   <= selected_insert;
                                CDO_PC_selrsv <= V_pip1;
                              end
                    default : begin // ex pip is allowed;
                                i_pip         <= V_pip0;
                                i_rd_a        <= CDI_PD_rd0;
                                i_state       <= S_amt_ex-1;
                                addr_insert   <= selected_insert;
                                CDO_PC_selrsv <= V_pip0;
                              end
                endcase
            end else if (CDI_PD_uops0 != unused_op)begin // mul pip is allowed;
                i_pip         <= V_pip0;
                i_rd_a        <= CDI_PD_rd0;
                i_state       <= S_amt_ex-1;
                addr_insert   <= selected_insert;
                CDO_PC_selrsv <= V_pip0;
            end else if (CDI_PD_uops1 != unused_op)begin // ex pip is allowed;
                i_pip        <= V_pip1;
                i_rd_a       <= CDI_PD_rd1;
                i_state      <= S_amt_mul-1;
                addr_insert  <= selected_insert;
                CDO_PC_selrsv <= V_pip1;
            end else begin // no pip is allowed
                i_pip         <= V_unpip;
                i_rd_a        <= CDI_PD_rd0;
                i_state       <= S_amt_mul-1;
                addr_insert   <= unused_cd;
                CDO_PC_selrsv <= V_unpip;
            end
        end
        // give neccessary information to wb(reorder buffer)
        always @(*) begin
            if (selected_wb_inused)begin
                CDO_PC_rd    <=  selected_wb_address;
                CDO_PC_selwb <=  selected_wb_pip;
            end else begin
                CDO_PC_rd    <=  0;
                CDO_PC_selwb <=  V_unpip;
            end
        end
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //selected address to insert
        Extream_val #(.level(4),.data_sz(W_ident),.comparator(0)) 
            find_min_addr(
                            selected_insert,
                            candit_insert // number of data set must have 2^(level-1
                         );
            //selected data set to retrive
        Extream_val #(.level(4),.data_sz(W_inused + W_pip + W_PA_REG),.comparator(1)) 
            find_max_wb_dataset(
                            selected_wb,
                            candit_wb // number of data set must have 2^(level-1
                         );
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //generate scb_cell
        genvar i;
        generate
            
            for (i = 0; i < S_amt_cell; i = i + 1)begin
                Scb_cell #(.cell_ident(i)) cell(candit_wb[(i+1)*(W_inused + W_pip + W_PA_rx)-1
                                                         :(i  )*(W_inused + W_pip + W_PA_rx)
                                                         ],
                                                candit_insert[(i+1)*W_ident-1:
                                                              (i  )*W_ident
                                                             ],
                                                ck_wbs_0[i],
                                                ck_wbs_1[i],
                                                i_pip,
                                                i_rd_a,
                                                i_state,
                                                addr_insert,
                                                CFI_PC_clear,
                                                clk
                                               );
            end

        endgenerate

endmodule