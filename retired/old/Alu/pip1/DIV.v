module DIV
#(
    /////////////////// data parameter//////////
    parameter W_PD_UOPS   = 6,
    parameter W_PD_DATA   = 32
)
(
    // output data flow
    output wire[W_PD_DATA-1:0] DFO_PD_rs,
    output wire                DFO_PD_ofw,
    // input dataflow
    input  wire[W_PD_UOPS-1:0] DFI_PD_uops,
    input  wire[W_PD_DATA-1:0] DFI_PD_rs,
    input  wire[W_PD_DATA-1:0] DFI_PD_rt,
    // input control flow
    input wire                 CFI_PC_clear,
    input wire                 CFI_PC_ena,
    input wire                 clk
);

    // control flow
    reg[1:0] STATE;
    // variable
    reg[W_PD_UOPS-1:0] OP;
    reg[W_PD_DATA-1:0] P,Q,R,X; // devidend  devisor result remainder
    reg                OF,SGN; // overflow
    reg[5-1        :0] i;
    localparam STATE_INIT  = 2'b00;
    localparam STATE_CLEAN = 2'b01;
    localparam STATE_DIV   = 2'b10;
    localparam STATE_FIN   = 2'b11;

    localparam OP_DIV    = 000_100;
    localparam OP_DIVU   = 000_101;
    localparam OP_REM    = 000_110;
    localparam OP_REMU   = 000_111;

    wire[W_PD_DATA-1:0] P_pminus = P[W_PD_DATA-1] ? (~P) + 1 : P; //pre_minus
    wire[W_PD_DATA-1:0] Q_pminus = Q[W_PD_DATA-1] ? (~Q) + 1 : Q; //pre_minus
    wire[W_PD_DATA-1:0] X_wp     = {X[W_PD_DATA-1-1:0] , P[W_PD_DATA-1]}; // x with pull the most front of p
    wire[W_PD_DATA-1:0] X_new    = (X_wp >= Q) ? (X_wp - Q): X_wp;
    wire[W_PD_DATA-1:0] R_new    = (X_wp >= Q) ? {R[W_PD_DATA-1-1:0],1'b1}: {R[W_PD_DATA-1-1:0],1'b0};

    //behaviour

    always @(posedge clk) begin

        if (CFI_PC_clear)begin
            STATE <= STATE_INIT;
        end else begin
            case (STATE)
                STATE_INIT  : begin 
                                STATE <= CFI_PC_ena ? STATE_CLEAN : STATE_INIT;
                                P     <= DFI_PD_rs;
                                Q     <= DFI_PD_rt;
                                OP    <= DFI_PD_uops;
                              end 
                STATE_CLEAN : begin
                                STATE <= STATE_DIV;
                                if (OP == OP_DIV || OP == OP_REM) begin
                                    P     <= P_pminus;
                                    Q     <= Q_pminus;
                                    SGN   <= P[W_PD_DATA-1] ^ Q[W_PD_DATA-1];
                                    OF    <= (P_pminus[W_PD_DATA-1] == 1) && (P_pminus[W_PD_DATA-1-1:0] == 0)
                                             && ((~P_pminus[W_PD_DATA-1:0]) == 0);  // 2^(n-1) / -1
                                end else begin
                                    SGN   <= 0;
                                    OF    <= 0;
                                end
                                R     <= {(W_PD_DATA){1'b0}};
                                X     <= {(W_PD_DATA){1'b0}};
                                i     <= 0;
                              end
                STATE_DIV   : begin 
                                if (i == (W_PD_DATA-1))begin
                                    STATE <= STATE_FIN;
                                end
                                P <= P << 1;
                                X <= X_new;
                                R <= R_new;
                                i <= i + 1;
                              end
                STATE_FIN   : begin
                                STATE <= STATE_INIT;
                                case (OP)
                                    OP_DIV  : R <= SGN ? ~R + 1: R;
                                    OP_REM  : R <= SGN ? ~X + 1: X;
                                    OP_DIVU : R <= R;
                                    OP_REMU : R <= X;
                                    default : R <= 0;
                                endcase

                              end
                default: begin 
                            STATE <= STATE_INIT; 
                         end
            endcase
        end
        
    end
//////////////////// output
    assign DFO_PD_rs  = R;
    assign DFO_PD_ofw = OF;

endmodule