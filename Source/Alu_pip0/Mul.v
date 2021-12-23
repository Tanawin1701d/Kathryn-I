`include"../TEMPLATE/Int/Sign_ext.v"
module Execute 
#(
/////////////////// address parameter///////
    parameter S_ID  = 0,
    parameter S_STG = 4,
/////////////////// data parameter//////////
    parameter W_PD_UOPS   = 6,
    parameter W_PD_DATA   = 32,
    parameter W_PD_PDATA  = W_PD_DATA * 2,
    parameter S_AMT_LV    = W_PD_PDATA / S_STG, // amount level
    parameter S_ST_PT     = S_AMT_LV * S_ID // start point
)

(
///////////////////////////////////////////
//// output
    output  wire[W_PD_UOPS  -1:0] DFO_PD_uops,
    output  wire[W_PD_PDATA -1:0] DFO_PD_rp, // act as wire 
    output  wire[W_PD_PDATA -1:0] DFO_PD_rs,
    output  wire[W_PD_PDATA -1:0] DFO_PD_rt,
//// input
    input   wire[W_PD_UOPS  -1:0] DFI_PD_uops,
    input   wire[W_PD_PDATA -1:0] DFI_PD_rp, // temporary
    input   wire[W_PD_PDATA -1:0] DFI_PD_rs,
    input   wire[W_PD_PDATA -1:0] DFI_PD_rt,

    //////
    input  wire clk
);

/////////////////////
    reg [W_PD_UOPS                 -1:0] OP;
    reg [W_PD_PDATA                -1:0] RP;
    reg [W_PD_PDATA                -1:0] RS;
    reg [W_PD_PDATA                -1:0] RT;
    wire[W_PD_PDATA * (S_AMT_LV+1) -1:0] link;
    wire[W_PD_PDATA                -1:0] DFI_PD_rs_ext;
    wire[W_PD_PDATA                -1:0] DFI_PD_rt_ext;

    Sign_ext #(W_PD_PDATA,W_PD_DATA) m_rs_ext (DFI_PD_rs_ext,  DFI_PD_rs[W_PD_DATA-1:0] );
    Sign_ext #(W_PD_PDATA,W_PD_DATA) m_rt_ext (DFI_PD_rt_ext,  DFI_PD_rt[W_PD_DATA-1:0] );

    localparam MUL     = 6'b001_000;
    localparam MULH    = 6'b001_001;
    localparam MULHSU  = 6'b001_010;
    localparam MULHU   = 6'b001_011;    
    
    always @(posedge clk) begin
        OP <= DFI_PD_uops;
        if (S_ID == 0)begin
            RP <= {W_PD_PDATA{1'b0}};
            case ( DFI_PD_uops )
                MULH   : begin
                            RS <= DFI_PD_rs_ext;
                            RT <= DFI_PD_rt_ext;
                        end
                MULHSU : begin
                            RS <= DFI_PD_rs_ext;
                            RT <= {  {(W_PD_PDATA-W_PD_DATA){1'b0}}  , DFI_PD_rt[W_PD_DATA-1:0] };
                         end
                default :begin
                            RS <= {  {(W_PD_PDATA-W_PD_DATA){1'b0}}  , DFI_PD_rs[W_PD_DATA-1:0]};
                            RT <= {  {(W_PD_PDATA-W_PD_DATA){1'b0}}  , DFI_PD_rt[W_PD_DATA-1:0]};
                         end
            endcase

        end else begin
            RP <= DFI_PD_rp;
            RS <= DFI_PD_rs;
            RT <= DFI_PD_rt;
        end

    end
    
    
    // multiple matrix
    genvar i;
        for (i = 0; i < S_AMT_LV; i = i + 1)begin
            assign link[W_PD_PDATA * (i+2) -1: W_PD_PDATA * (i+1)] = { RS[W_PD_PDATA - (S_ST_PT+i) -1: 0] & 
                                                                       { (W_PD_PDATA - (S_ST_PT+i)) {RT[S_ST_PT+i]}   }
                                                                       ,{(S_ST_PT+i){1'b0}} 
                                                                     }
                                                                     +
                                                                     link[W_PD_PDATA * (i+1) - 1: W_PD_PDATA * i];
        end 

    // input
    assign link[W_PD_PDATA -1: 0] = RP;
    // output 
    assign DFO_PD_uops = OP;
    assign DFO_PD_rp   = (S_ID != (S_STG-1) )? link[W_PD_PDATA * (S_AMT_LV+1) -1: W_PD_PDATA * (S_AMT_LV)] :
                          OP   == MUL        ? {{W_PD_DATA{1'b0}}, link[W_PD_PDATA * (S_AMT_LV     ) + W_PD_DATA -1: W_PD_PDATA * (S_AMT_LV)            ]}
                                             : {{W_PD_DATA{1'b0}}, link[W_PD_PDATA * (S_AMT_LV + 1 )             -1: W_PD_PDATA * (S_AMT_LV) + W_PD_DATA]};
    assign DFO_PD_rs   = RS;
    assign DFO_PD_rt   = RT;


endmodule