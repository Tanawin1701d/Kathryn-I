`include"Resv_cell.v"
`include"../../TEMPLATE/Finder/Extream_val.v"
`include"../../TEMPLATE/MUX/Mux.v"
module Resv 
#(
/////////////////// address parameter///////
    parameter W_PA_REG = 5,
    parameter W_AA_INSTR = 32,
    parameter W_PA_CSR  =  11,
/////////////////// data parameter//////////
    parameter W_PD_req   = 2,
    parameter W_PD_POPS  = 3,
    parameter W_PD_UOPS  = 6,
    parameter W_PD_DATA  = 32,
////////////////////other/////////
    parameter W_PS_rsvc  = 4, // physical spec
    parameter S_PS_rsvc  = 8, 
    parameter W_PC_SEL   = 2,   
////////////////////rsv cell//////////////////
    parameter W_ident     = 4,
    parameter W_pip       = 1,
    parameter W_uops      = 6,
    parameter W_rx_a      = 5,
    parameter W_rx_d      = 32,
    parameter W_imm_d     = 32,
    parameter W_pc_d      = 32,
    parameter unused_op   = {W_uops {1'b1}},
    parameter unused_cd   = {W_ident{1'b1}} // unuse candit
)
(
    // output
        //////// data flow
            //uops
            output wire[W_PD_UOPS -1 : 0] DFO_uops,
            //data
            output wire[W_PD_DATA -1 : 0] DFO_PD_rs,
            output wire[W_PD_DATA -1 : 0] DFO_PD_rt,
            output wire[W_PD_DATA -1 : 0] DFO_PD_imm,
            //address
            output wire[W_AA_INSTR-1 : 0] DFO_AA_pc,
        //////// control data
            //data
            output wire[W_PC_SEL  -1 : 0] CDO_PD_odr,
            output wire[W_PD_UOPS -1 : 0] CDO_PD_uops1,
            output wire[W_PD_UOPS -1 : 0] CDO_PD_uops2,
            //address 
            output wire[W_PA_REG  -1 : 0] CDO_PA_r1,
            output wire[W_PA_REG  -1 : 0] CDO_PA_r2,
        //////// control flow
            output wire                   CFO_PC_full,
    // input
        //////// data flow
            //data
            input wire[W_PD_req  -1:0]   DFI_PD_REQ,
            input wire[W_PD_UOPS -1:0]   DFI_PD_uops,
            input wire[W_PD_DATA -1:0]   DFI_PD_rs,
            input wire[W_PD_DATA -1:0]   DFI_PD_rt,
            input wire[W_PD_DATA -1:0]   DFI_PD_imm,
            //address
            input wire[W_PA_REG  -1:0]   DFI_PA_rd,
            input wire[W_PA_REG  -1:0]   DFI_PA_rs,
            input wire[W_PA_REG  -1:0]   DFI_PA_rt,
            input wire[W_AA_INSTR-1:0]   DFI_AA_pc,
            // validation
            input wire                   DFI_PV_rs,
            input wire                   DFI_PV_rt,
        //////// control data
            input wire[W_PD_DATA -1 :0]   CDI_PD_upt1,
            input wire[W_PA_REG  -1 :0]   CDI_PA_upt1,
            input wire[W_PC_SEL  -1 :0]   CDI_PC_s1,
        //////// control flow
            input wire CFI_PC_stall,
            input wire CFI_PC_clear,
            input wire CFI_PC_ena,
            input wire clk
);

    ///////////////status register////////
    reg                  FLAG_CLEAR;
    reg                  FLAG_STALL;
    reg[W_PS_rsvc-1 : 0] RESV_COUNT;
    reg[W_ident-1   : 0] addr_shift; // act as wire
    reg[W_ident-1   : 0] addr_insert;// act as wire
    
    ////////////// rsv cell connector/////////////////
    // shift cell
    wire [S_PS_rsvc * W_PD_req -1: 0]   shift_req; //input from decode;
    wire [S_PS_rsvc * W_pip    -1: 0]   shift_pip;
    wire [S_PS_rsvc * W_uops   -1: 0]   shift_uops;
    wire [S_PS_rsvc * W_rx_a   -1: 0]   shift_rd_a;
    wire [S_PS_rsvc            -1: 0]   shift_rs_v;
    wire [S_PS_rsvc * W_rx_a   -1: 0]   shift_rs_a;
    wire [S_PS_rsvc * W_rx_d   -1: 0]   shift_rs_d;
    wire [S_PS_rsvc            -1: 0]   shift_rt_v;
    wire [S_PS_rsvc * W_rx_a   -1: 0]   shift_rt_a;
    wire [S_PS_rsvc * W_rx_d   -1: 0]   shift_rt_d;
    wire [S_PS_rsvc * W_imm_d  -1: 0]   shift_imm_d;
    wire [S_PS_rsvc * W_pc_d   -1: 0]   shift_pc_d;
    // input cell
    wire [W_PD_req -1: 0]   input_req   = DFI_PD_REQ; //input from decode;
    wire [W_pip    -1: 0]   input_pip   = (DFI_PD_uops[5:3] == 3'b001) 
                                           && (DFI_PD_uops[2:0] <= 3'd3)
                                           && (DFI_PD_uops[2:0] >= 3'd0); // op-RM
    wire [W_uops   -1: 0]   input_uops  = DFI_PD_uops;
    wire [W_rx_a   -1: 0]   input_rd_a  = DFI_PA_rd;
    wire [1        -1: 0]   input_rs_v  = DFI_PV_rs;
    wire [W_rx_a   -1: 0]   input_rs_a  = DFI_PA_rs;
    wire [W_rx_d   -1: 0]   input_rs_d  = DFI_PD_rs;
    wire [1        -1: 0]   input_rt_v  = DFI_PV_rt;
    wire [W_rx_a   -1: 0]   input_rt_a  = DFI_PA_rt;
    wire [W_rx_d   -1: 0]   input_rt_d  = DFI_PD_rt;
    wire [W_imm_d  -1: 0]   input_imm_d = DFI_PD_imm;
    wire [W_pc_d   -1: 0]   input_pc_d  = DFI_AA_pc;
    // output cell
    wire [S_PS_rsvc * W_PD_req -1: 0]   out_req; //input from decode;
    wire [S_PS_rsvc * W_pip    -1: 0]   out_pip;
    wire [S_PS_rsvc * W_uops   -1: 0]   out_uops;
    wire [S_PS_rsvc * W_rx_a   -1: 0]   out_rd_a;
    wire [S_PS_rsvc            -1: 0]   out_rs_v;
    wire [S_PS_rsvc * W_rx_a   -1: 0]   out_rs_a;
    wire [S_PS_rsvc * W_rx_d   -1: 0]   out_rs_d;
    wire [S_PS_rsvc            -1: 0]   out_rt_v;
    wire [S_PS_rsvc * W_rx_a   -1: 0]   out_rt_a;
    wire [S_PS_rsvc * W_rx_d   -1: 0]   out_rt_d;
    wire [S_PS_rsvc * W_imm_d  -1: 0]   out_imm_d;
    wire [S_PS_rsvc * W_pc_d   -1: 0]   out_pc_d;
    // candit rsv
    wire [W_ident              -1: 0]   candit1_re;
    wire [W_ident              -1: 0]   candit0_re;
    wire [S_PS_rsvc * W_ident  -1: 0]   candit1;
    wire [S_PS_rsvc * W_ident  -1: 0]   candit0;
    /////////////////////////////////////////////////////////////////////////////////////
    /////////////// behaviour
    always @(*) begin
        if (CFI_PC_clear || CFI_PC_stall)begin
            addr_shift  <= unused_cd;
            addr_insert <= unused_cd;
        end else if ( CFI_PC_ena )begin
            addr_shift  <= CDI_PC_s1[0] ? candit0:
                           CDI_PC_s1[1] ? candit1:
                           unused_cd;
            addr_insert <= (CDI_PC_s1)? RESV_COUNT-1:RESV_COUNT;
        end else begin
            addr_shift  <= unused_cd;
            addr_insert <= unused_cd;
        end
    end
    /////////////// behaviour with clock
    always @(posedge clk) begin
        if (CFI_PC_clear)begin
            FLAG_CLEAR <= 1;
            FLAG_STALL <= 0;
            RESV_COUNT <= 0;
        end if ( CFI_PC_stall )begin 
            FLAG_CLEAR <= 0;
            FLAG_STALL <= 1;
            RESV_COUNT <= CDI_PC_s1 ? RESV_COUNT-1 : RESV_COUNT;
        end else if ( CFI_PC_ena )begin
            FLAG_CLEAR <= 0;
            FLAG_STALL <= 0;
            RESV_COUNT <= CDI_PC_s1 ? RESV_COUNT   : RESV_COUNT+1;
        end else begin
            FLAG_CLEAR <= 0;
            FLAG_STALL <= 0;
            RESV_COUNT <= CDI_PC_s1 ? RESV_COUNT-1 : RESV_COUNT;
        end
    end
    ////////////////////////////////////////////////////////////////////////////////////
    /////////////// output
    assign DFO_uops = CDI_PC_s1[0] ? CDO_PD_uops1:
                      CDI_PC_s1[1] ? CDO_PD_uops2:
                                     unused_op;
    
    Mux #(.level(4),.data_sz(W_PD_DATA),.sel_sz (W_ident-1))
        mux_DFO_PD_rs(DFO_PD_rs,
                      out_rs_d, // number of data set must have 2^(level-1)
                      CDI_PC_s1[1] ? candit1_re[W_ident-1-1:0] :candit0_re[W_ident-1-1:0]
                     );

    Mux #(.level(4),.data_sz(W_PD_DATA),.sel_sz (W_ident-1))
        mux_DFO_PD_rt(DFO_PD_rt,
                      out_rt_d, // number of data set must have 2^(level-1)
                      CDI_PC_s1[1] ? candit1_re[W_ident-1-1:0] :candit0_re[W_ident-1-1:0]
                     );

    Mux #(.level(4),.data_sz(W_PD_DATA),.sel_sz (W_ident-1))
        mux_DFO_PD_imm(DFO_PD_imm,
                      out_imm_d, // number of data set must have 2^(level-1)
                      CDI_PC_s1[1] ? candit1_re[W_ident-1-1:0] :candit0_re[W_ident-1-1:0]
                     );

    Mux #(.level(4),.data_sz(W_AA_INSTR),.sel_sz (W_ident-1))
        mux_out_pc_d(DFO_AA_pc,
                      out_pc_d, // number of data set must have 2^(level-1)
                      CDI_PC_s1[1] ? candit1_re[W_ident-1-1:0] :candit0_re[W_ident-1-1:0]
                    );
    
    assign CFO_PC_full = (RESV_COUNT == S_PS_rsvc) && !CDI_PC_s1;

    wire[W_PD_UOPS-1:0] pre_uops0 ;
    wire[W_PD_UOPS-1:0] pre_uops1 ;

    Mux #(.level(4),.data_sz(W_PD_UOPS),.sel_sz (W_ident-1))
        mux_ops0(pre_uops0,
                 out_uops, // number of data set must have 2^(level-1)
                 candit0_re[W_ident-1-1:0]
                );

    Mux #(.level(4),.data_sz(W_PD_UOPS),.sel_sz (W_ident-1))
        mux_ops1(pre_uops1,
                 out_uops, // number of data set must have 2^(level-1)
                 candit1_re[W_ident-1-1:0]
                );

    assign CDO_PD_uops0 = (candit0_re == unused_cd) ? unused_op : pre_uops0;
    assign CDO_PD_uops1 = (candit1_re == unused_cd) ? unused_op : pre_uops1;

    Mux #(.level(4),.data_sz(W_PA_REG),.sel_sz (W_ident-1))
        mux_CDO_PA_r1(CDO_PA_r1,
                 out_rd_a, // number of data set must have 2^(level-1)
                 candit0_re[W_ident-1-1:0]
                );

    Mux #(.level(4),.data_sz(W_PA_REG),.sel_sz (W_ident-1))
        mux_CDO_PA_r2(CDO_PA_r2,
                 out_rd_a, // number of data set must have 2^(level-1)
                 candit1_re[W_ident-1-1:0]
                );

    assign CDO_PD_odr = candit0_re[W_ident-1-1:0] > candit1_re[W_ident-1-1:0];



    ////////////////////////////////////////////////////////////////////////////////////
    /////////////// generate rsv cell
    genvar i;
    generate
        for (i = 0; i < S_PS_rsvc; i = i + 1)begin
            Resv_cell  x (
            ////////////////////// data //////////////////////////////
            out_req     [(i+1) * W_PD_req  -1:i * W_PD_req ],//global output 
            out_pip     [(i+1) * W_pip     -1:i * W_pip    ],
            out_uops    [(i+1) * W_uops    -1:i * W_uops   ],
            out_rd_a    [(i+1) * W_rx_a    -1:i * W_rx_a   ],
            out_rs_v    [(i+1)             -1:i            ],
            out_rs_a    [(i+1) * W_rx_a    -1:i * W_rx_a   ],
            out_rs_d    [(i+1) * W_rx_d    -1:i * W_rx_d   ],
            out_rt_v    [(i+1)             -1:i            ],
            out_rt_a    [(i+1) * W_rx_a    -1:i * W_rx_a   ],
            out_rt_d    [(i+1) * W_rx_d    -1:i * W_rx_d   ],
            out_imm_d   [(i+1) * W_imm_d   -1:i * W_imm_d  ],
            out_pc_d    [(i+1) * W_pc_d    -1:i * W_pc_d   ],  
            ////////////////////////////////////////////////////////////////
            input_req   [W_PD_req  -1:0],
            input_pip   [W_pip     -1:0],
            input_uops  [W_uops    -1:0],
            input_rd_a  [W_rx_a    -1:0],
            input_rs_v  [1         -1:0],
            input_rs_a  [W_rx_a    -1:0],
            input_rs_d  [W_rx_d    -1:0],
            input_rt_v  [1         -1:0],
            input_rt_a  [W_rx_a    -1:0],
            input_rt_d  [W_rx_d    -1:0],
            input_imm_d [W_imm_d   -1:0],
            input_pc_d  [W_pc_d    -1:0],
            ///////////////////////////////////////////////////////////////////
            //input from shifter
            shift_req   [(i+1) * W_PD_req  -1:i * W_PD_req ],
            shift_pip   [(i+1) * W_pip     -1:i * W_pip    ],
            shift_uops  [(i+1) * W_uops    -1:i * W_uops   ],
            shift_rd_a  [(i+1) * W_rx_a    -1:i * W_rx_a   ],
            shift_rs_v  [(i+1)             -1:i            ],
            shift_rs_a  [(i+1) * W_rx_a    -1:i * W_rx_a   ],
            shift_rs_d  [(i+1) * W_rx_d    -1:i * W_rx_d   ],
            shift_rt_v  [(i+1)             -1:i            ],
            shift_rt_a  [(i+1) * W_rx_a    -1:i * W_rx_a   ],
            shift_rt_d  [(i+1) * W_rx_d    -1:i * W_rx_d   ],
            shift_imm_d [(i+1) * W_imm_d   -1:i * W_imm_d  ],
            shift_pc_d  [(i+1) * W_pc_d    -1:i * W_pc_d   ],
            //////////////////////////////////////////////////////////////////
            //output
            candit1     [(i+1) * W_ident-1:i * W_ident],
            candit0     [(i+1) * W_ident-1:i * W_ident],
            //input
            addr_shift  ,
            addr_insert ,
            CDI_PA_upt1   ,
            CDI_PD_upt1   ,
            //input
            CFI_PC_clear,
            clk
            );
        end
    endgenerate
    /////////////// connect shifter
    for (i = 0; i < S_PS_rsvc; i = i + 1)begin
        assign shift_req  [(i+1) * W_PD_req  -1:i * W_PD_req ] = (i != 0) ?out_req  [i * W_PD_req  -1:(i-1) * W_PD_req ] :{W_PD_req{1'b0}};
        assign shift_pip  [(i+1) * W_pip     -1:i * W_pip    ] = (i != 0) ?out_pip  [i * W_pip     -1:(i-1) * W_pip    ] :{W_pip   {1'b0}};
        assign shift_uops [(i+1) * W_uops    -1:i * W_uops   ] = (i != 0) ?out_uops [i * W_uops    -1:(i-1) * W_uops   ] :unused_op;
        assign shift_rd_a [(i+1) * W_rx_a    -1:i * W_rx_a   ] = (i != 0) ?out_rd_a [i * W_rx_a    -1:(i-1) * W_rx_a   ] :{W_rx_a  {1'b0}};
        assign shift_rs_v [(i+1)             -1:i            ] = (i != 0) ?out_rs_v [i             -1:(i-1)            ] :{        {1'b0}};
        assign shift_rs_a [(i+1) * W_rx_a    -1:i * W_rx_a   ] = (i != 0) ?out_rs_a [i * W_rx_a    -1:(i-1) * W_rx_a   ] :{W_rx_a  {1'b0}};
        assign shift_rs_d [(i+1) * W_rx_d    -1:i * W_rx_d   ] = (i != 0) ?out_rs_d [i * W_rx_d    -1:(i-1) * W_rx_d   ] :{W_rx_d  {1'b0}};
        assign shift_rt_v [(i+1)             -1:i            ] = (i != 0) ?out_rt_v [i             -1:(i-1)            ] :{        {1'b0}};
        assign shift_rt_a [(i+1) * W_rx_a    -1:i * W_rx_a   ] = (i != 0) ?out_rt_a [i * W_rx_a    -1:(i-1) * W_rx_a   ] :{W_rx_a  {1'b0}};
        assign shift_rt_d [(i+1) * W_rx_d    -1:i * W_rx_d   ] = (i != 0) ?out_rt_d [i * W_rx_d    -1:(i-1) * W_rx_d   ] :{W_rx_d  {1'b0}};
        assign shift_imm_d[(i+1) * W_imm_d   -1:i * W_imm_d  ] = (i != 0) ?out_imm_d[i * W_imm_d   -1:(i-1) * W_imm_d  ] :{W_imm_d {1'b0}};
        assign shift_pc_d [(i+1) * W_pc_d    -1:i * W_pc_d   ] = (i != 0) ?out_pc_d [i * W_pc_d    -1:(i-1) * W_pc_d   ] :{W_pc_d  {1'b0}};

    end
    /////////////// connect  
     Extream_val #(4,W_ident,0) cdr1 (candit1_re,candit1);
     Extream_val #(4,W_ident,0) cdr2 (candit0_re,candit0);
    /////////////// 


endmodule