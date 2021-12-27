module Scb
#(
/////////////////// address parameter ///////    
    parameter W_PA_REG       = 5,
    parameter W_AA_INSTR     = 32,
    parameter W_PA_CSR       = 11,
/////////////////// data parameter//////////
    parameter W_PD_UOPS      = 6,
    parameter W_PD_DATA      = 32,
/////////////////// selector
    parameter W_PC_SEL_RSV   = 2,
    parameter W_PC_SEL_WB    = 2,
    parameter W_PC_SEL_ODR   = 2,
/////////////////// default value
    parameter unused_op      = {W_PD_UOPS {1'b1}}, // unused op
    parameter unused_cd      = {W_ident{1'b1}},
    parameter unused_sel_rsv = {W_PC_SEL_RSV{1'b0}},
    parameter unused_sel_wb = {W_PC_SEL_WB{1'b0}},
/////////////////// default cell para
    parameter W_ident        = 4,// there are 8 cells in each scoreboard but we use 4 bit, remain 1 bit for dump bit 
    parameter W_inused       = 1,
    parameter W_pip          = 1,
    parameter W_state        = 7
)
(
    ///////output cdo
        ///////// address
        output wire[W_PA_REG    -1:0] CDO_PC_rd,
        ///////// select
        output wire[W_PC_SEL_WB -1:0] CDO_PC_selwb,
        output wire[W_PC_SEL_ODR-1:0] CDO_PC_selrsv,
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
        input  wire                   CFI_PC_clear,
        input  wire                   clk
);


wire[W_inused + W_pip + W_PA_REG-1:0] candit_wb;
wire[W_inused         + W_ident -1:0] candit_insert;
wire                                  fut_0;
wire                                  fut_1;
/////// data  // * todo *
wire[W_inused                   -1:0] o_inused;
wire[W_pip                      -1:0] o_pip;
wire[W_PA_REG                   -1:0] o_rd_a;
wire[W_state                    -1:0] o_state;

/////// input                                    
wire[W_pip                      -1:0] i_pip;
wire[W_PA_REG                   -1:0] i_rd_a;
wire[W_state                    -1:0] i_state;
wire[W_ident                    -1:0] addr_insert;

endmodule