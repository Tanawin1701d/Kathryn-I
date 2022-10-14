// this file is used to store data of reservation station data
module Resv_cell_pip3
#(
  parameter W_ident     = 4,// there are 8 cells in each reservation station but we use 4 bit, remain 1 bit for dump bit 
  parameter cell_ident  = 4'b0000,
  parameter W_req       = 2,
  parameter W_pip       = 1,
  parameter W_uops      = 6,
  parameter W_rx_a      = 5,
  parameter W_rx_d      = 32,
  parameter W_imm_d     = 32,
  parameter W_pc_d      = 32,
  parameter unused_op   = {W_uops {1'b1}},
  parameter unused_cd   = {W_ident{1'b1}}
)
(
////////////////////// data //////////////////////////////
output wire [W_req  -1: 0]   o0_req,   //global output 
output wire [W_pip  -1: 0]   o0_pip,
output wire [W_uops -1: 0]   o0_uops,
output wire [W_rx_a -1: 0]   o0_rd_a,
output wire                  o0_rs_v,   
output wire [W_rx_a -1: 0]   o0_rs_a,
output wire [W_rx_d -1: 0]   o0_rs_d,
output wire                  o0_rt_v,
output wire [W_rx_a -1: 0]   o0_rt_a,   
output wire [W_rx_d -1: 0]   o0_rt_d,   
output wire [W_imm_d-1: 0]   o0_imm_d,  
output wire [W_pc_d -1: 0]   o0_pc_d,   
////////////////////////////////////////////////////////////////
input  wire [W_req  -1: 0]   i0_req, //input from decoder
input  wire [W_pip  -1: 0]   i0_pip,
input  wire [W_uops -1: 0]   i0_uops,
input  wire [W_rx_a -1: 0]   i0_rd_a,
input  wire                  i0_rs_v,   
input  wire [W_rx_a -1: 0]   i0_rs_a,
input  wire [W_rx_d -1: 0]   i0_rs_d,
input  wire                  i0_rt_v,
input  wire [W_rx_a -1: 0]   i0_rt_a,
input  wire [W_rx_d -1: 0]   i0_rt_d,
input  wire [W_imm_d-1: 0]   i0_imm_d,
input  wire [W_pc_d -1: 0]   i0_pc_d,
 
  
///////////////////////////////////////////////////////////////////
input  wire [W_req  -1: 0]   i1_req, //input from shifter
input  wire [W_pip  -1: 0]   i1_pip,
input  wire [W_uops -1: 0]   i1_uops,
input  wire [W_rx_a -1: 0]   i1_rd_a,
input  wire                  i1_rs_v,   
input  wire [W_rx_a -1: 0]   i1_rs_a,
input  wire [W_rx_d -1: 0]   i1_rs_d,
input  wire                  i1_rt_v,
input  wire [W_rx_a -1: 0]   i1_rt_a,
input  wire [W_rx_d -1: 0]   i1_rt_d,
input  wire [W_imm_d-1: 0]   i1_imm_d,
input  wire [W_pc_d -1: 0]   i1_pc_d,
//////////////////////////////////////////////////////////////////
//output
output wire [W_ident-1:0]    candit1, // pip1 candidate code
output wire [W_ident-1:0]    candit0, // pip0 candidate code
//input
input  wire [W_ident-1:0]    addr_shift, // buss that tell which cell must accept shift  i1
input  wire [W_ident-1:0]    addr_insert,// buss that tell which cell must accept insert i0
input  wire [W_rx_a -1:0]    addr_reg_upt, // buss that tell which cell must be update 
input  wire [W_rx_d -1:0]    data_reg_upt, // -----^
//input
input  wire                  clear,
input  wire                  clk
);



    reg [W_req  -1: 0]   req;
    reg [W_pip  -1: 0]   pip;
    reg [W_uops -1: 0]   uops;
    reg [W_rx_a -1: 0]   rd_a;
    reg                  rs_v;   
    reg [W_rx_a -1: 0]   rs_a;
    reg [W_rx_d -1: 0]   rs_d;
    reg                  rt_v;
    reg [W_rx_a -1: 0]   rt_a;
    reg [W_rx_d -1: 0]   rt_d;
    reg [W_imm_d-1: 0]   imm_d;
    reg [W_pc_d -1: 0]   pc_d;


    always@(posedge clk)begin
        if (clear)begin
            uops   <= unused_op;
        end else if ( addr_insert ==  cell_ident)begin
            req    <= i0_req;
            pip    <= i0_pip;
            uops   <= i0_uops;
            rd_a   <= i0_rd_a;
            ////////////////////////////////////////////////////////////////
            rs_v   <= i0_rs_v;
            rs_a   <= i0_rs_a;
            rs_d   <= i0_rs_d;
            //////////////////////////////////////////////////////////////
            rt_v   <= i0_rt_v;
            rt_a   <= i0_rt_a;
            rt_d   <= i0_rt_d;
            imm_d  <= i0_imm_d;
            pc_d   <= i0_pc_d;
            //////////////////////////////////////////////////////////////
        end else if ( addr_shift <= cell_ident )begin
            req    <= i1_req;
            pip    <= i1_pip;
            uops   <= i1_uops;
            rd_a   <= i1_rd_a;
            ////////////////////////////////////////////////////
            rs_v   <= (addr_reg_upt == i1_rs_a) ? 1'b1        : i1_rs_v; // no knock around
            rs_a   <= i1_rs_a;
            rs_d   <= (addr_reg_upt == i1_rs_a) ? data_reg_upt: i1_rs_d;
            ///////////////////////////////////////////////////
            rt_v   <= (addr_reg_upt == i1_rt_a) ? 1'b1        : i1_rt_v;
            rt_a   <= i1_rt_a;
            rt_d   <= (addr_reg_upt == i1_rt_a) ? data_reg_upt: i1_rt_d;
            imm_d  <= i1_imm_d;
            pc_d   <= i1_pc_d;
        end else begin
            rs_v   <= (addr_reg_upt == rs_a) ? 1'b1        : rs_v;
            rs_a   <= i1_rs_a;
            rs_d   <= (addr_reg_upt == rs_a) ? data_reg_upt: rs_d;
            ////////////////////////////////////////////////////
            rt_v   <= (addr_reg_upt == rt_a) ? 1'b1        : rt_v;
            rt_a   <= i1_rs_a;
            rt_d   <= (addr_reg_upt == rt_a) ? data_reg_upt: rt_d;
        end
    end
    //TODO: this section will be modified for other reservation station
    assign candit1 = ( (uops != unused_op) && (pip == 1'b1) &&  (rs_v == req[0]) && (rt_v == req[1]) )
                     ? cell_ident
                     : unused_cd;
    assign candit0 = ( (uops != unused_op) && (pip == 1'b0) &&  (rs_v == req[0]) && (rt_v == req[1]) )
                     ? cell_ident
                     : unused_cd;
// output wire that tell current internal register
    assign o0_req    =  req;
    assign o0_pip    =  pip;
    assign o0_uops   =  uops;

    assign o0_rd_a   =  rd_a;
    
    assign o0_rs_v   =  rs_v;
    assign o0_rs_a   =  rs_a;
    assign o0_rs_d   =  rs_d;
    
    assign o0_rt_v   =  rt_v;
    assign o0_rt_a   =  rt_a;
    assign o0_rt_d   =  rt_d;
    
    assign o0_imm_d  =  imm_d;
    assign o0_pc_d   =  pc_d;



endmodule