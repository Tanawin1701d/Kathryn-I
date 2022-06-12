
module Execute 
#(
/////////////////// address parameter///////
    parameter W_AA_INSTR = 32,
/////////////////// data parameter//////////
    parameter W_PD_req   = 2,
    parameter W_PD_POPS  = 3,
    parameter W_PD_UOPS  = 6,
    parameter W_PD_DATA  = 32

)

(
///////////////////////////////////////////
//// output
    output reg[W_PD_DATA -1:0] DFO_PD_RD1, // act as wire 
    output reg[W_AA_INSTR-1:0] DFO_AA_BR,  // act as wire
//// input
    input  wire[W_PD_UOPS -1:0] DFI_PD_uops,
    input  wire[W_PD_DATA -1:0] DFI_PD_rs,
    input  wire[W_PD_DATA -1:0] DFI_PD_rt,
    input  wire[W_PD_DATA -1:0] DFI_PD_imm,
    input  wire[W_AA_INSTR-1:0] DFI_AA_pc,
    //////
    input  wire clk
);

    //////////////////// variable ////////////////////////////
    reg  [W_PD_DATA -1:0] RS;
    reg  [W_PD_DATA -1:0] RT;
    reg  [W_PD_DATA -1:0] PC;
    reg  [W_PD_DATA -1:0] IMM;
    reg  [W_PD_UOPS -1:0] OP;


    wire [W_PD_DATA -1:0] sign_imm12ext;  // sign ext
    wire [W_PD_DATA -1:0] sign_imm20ext_jal;  // sign ext
    wire [W_PD_DATA -1:0] usign_imm20ext_auipc = {  IMM[20-1:0]            , {(W_PD_DATA-20){1'b0}} };
    wire [W_PD_DATA -1:0] sign_branch_ext;


    /////// jump address
    wire [W_AA_INSTR -1:0] branch_target   = PC + sign_branch_ext;
    wire [W_AA_INSTR -1:0] branch_contin   = PC + 4;
    wire [W_AA_INSTR -1:0] jal_target      = PC + sign_imm20ext_jal;
    wire [W_AA_INSTR -1:0] jalr_pre_target = PC + sign_imm12ext;
    wire [W_AA_INSTR -1:0] auipc_target    = PC + usign_imm20ext_auipc;
    ///////// behaviour
    always @(posedge clk) begin
        RS  <= DFI_PD_rs;
        RT  <= DFI_PD_rt;
        OP  <= DFI_PD_uops;
        PC  <= DFI_AA_pc;
        IMM <= DFI_PD_imm;
    end
    ///////// extension
    Sign_ext #(W_PD_DATA,12) m_imm12 (sign_imm12ext    ,  IMM[12-1:0]                                );
    Sign_ext #(W_PD_DATA,21) m_jal20 (sign_imm20ext_jal, {IMM[19],IMM[7:0],IMM[   8],IMM[18:9], 1'b0});
    Sign_ext #(W_PD_DATA,13) m_br    (sign_branch_ext  , {IMM[12],IMM[ 11],IMM[10:5],IMM[4 :1], 1'b0});
    /////// parameter////////////////////////////////////////////////
    //
    localparam V_PD_one      = { {(W_PD_DATA -1){1'b0}}, 1'b1 };
    localparam V_PD_zero     = { {(W_PD_DATA -1){1'b0}}, 1'b0 };
    localparam V_AA_zero     = { {(W_AA_INSTR-1){1'b0}}, 1'b0 };
    
    // op_r
    localparam OP_ADD    = 6'b000_000;
    localparam OP_SLL    = 6'b000_001;
    localparam OP_SLT    = 6'b000_010;
    localparam OP_SLTU   = 6'b000_011;
    localparam OP_XOR    = 6'b000_100;
    localparam OP_SRL    = 6'b000_101;
    localparam OP_OR     = 6'b000_110;
    localparam OP_AND    = 6'b000_111;
                                                                                      
    localparam OP_SUB    = 6'b001_100;
    localparam OP_SRA    = 6'b001_101;
    // op_imm                                   
    localparam OP_ADDI   = 6'b010_000;
    localparam OP_SLLI   = 6'b010_001;
    localparam OP_SLTI   = 6'b010_010;
    localparam OP_SLTIU  = 6'b010_011;
    localparam OP_XORI   = 6'b010_100;
    localparam OP_SRLI   = 6'b010_101;
    localparam OP_ORI    = 6'b010_110;
    localparam OP_ANDI   = 6'b010_111;
    localparam OP_SRAI   = 6'b011_010;
    // branch                           
    localparam OP_BEQ    = 6'b011_000;
    localparam OP_BNE    = 6'b011_001;
    localparam OP_BLT    = 6'b011_100;
    localparam OP_BGE    = 6'b011_101;
    localparam OP_BLTU   = 6'b011_110;
    localparam OP_BGEU   = 6'b011_111;
    // jui                                            
    localparam OP_AUIPC  = 6'b100_000;
    localparam OP_JAL    = 6'b100_001;
    localparam OP_JALR   = 6'b100_010;
    ///////////////////////////////////////////////////////////////
    always @(*) begin
        case (OP)
            OP_ADD    : begin 
                            DFO_PD_RD1 <= RS + RT;
                            
                        end
            OP_SLL    : begin 
                            DFO_PD_RD1 <= RS << RT[4:0];
                            
                        end
            OP_SLT    : begin 
                            DFO_PD_RD1 <= ($signed(RS) < $signed(RT)) ? V_PD_one : V_PD_zero;
                            
                        end
            OP_SLTU   : begin 
                            DFO_PD_RD1 <= (RS < RT) ? V_PD_one : V_PD_zero;
                            
                        end
            OP_XOR    : begin 
                            DFO_PD_RD1 <= RS ^ RT;
                            
                        end
            OP_SRL    : begin 
                            DFO_PD_RD1 <= RS >> RT[4:0];
                            
                        end
            OP_OR     : begin 
                            DFO_PD_RD1 <= RS | RT;
                            
                        end
            OP_AND    : begin 
                            DFO_PD_RD1 <= RS & RT;
                            
                        end                       
            OP_SUB    : begin 
                            DFO_PD_RD1 <= RS - RT;
                            
                        end
            OP_SRA    : begin 
                            DFO_PD_RD1 <= ( $signed(RS) >>> RT[4:0])  ;
                            
                        end
                        ///////////////////////////////////////////////////////////////////////
            OP_ADDI   : begin 
                            DFO_PD_RD1 <=  RS + sign_imm12ext ;
                            
                        end
            OP_SLLI   : begin 
                            DFO_PD_RD1 <= RS << IMM[4:0];
                            
                        end
            OP_SLTI   : begin 
                            DFO_PD_RD1 <= ($signed(RS) < $signed(sign_imm12ext)) ? V_PD_one : V_PD_zero;;
                            
                        end
            OP_SLTIU  : begin 
                            DFO_PD_RD1 <= ( RS < sign_imm12ext ) ? V_PD_one : V_PD_zero;;
                            
                        end
            OP_XORI   : begin 
                            DFO_PD_RD1 <= RS ^ sign_imm12ext ;
                            
                        end
            OP_SRLI   : begin 
                            DFO_PD_RD1 <= RS >> IMM[4:0];
                            
                        end
            OP_ORI    : begin 
                            DFO_PD_RD1 <= RS | sign_imm12ext ;
                            
                        end
            OP_ANDI   : begin 
                            DFO_PD_RD1 <= RS & sign_imm12ext ;
                            
                        end
            OP_SRAI   : begin 
                            DFO_PD_RD1 <= $signed(RS) >>> IMM[4:0];
                            
                        end
            OP_AUIPC  : begin 
                            DFO_PD_RD1 <= auipc_target;
                            
                        end
            OP_JAL    : begin 
                            DFO_PD_RD1 <= branch_contin;
                            
                        end
            OP_JALR   : begin 
                            DFO_PD_RD1 <= branch_contin;
                            
                        end
            
            default: DFO_PD_RD1 <= V_PD_zero;
        endcase
        
    end

    always @(*) begin
        case(OP)
            OP_BEQ    : begin 
                            DFO_AA_BR <= (RS == RT)                   ? branch_target: branch_contin;
                                              
                        end                  
            OP_BNE    : begin                   
                            DFO_AA_BR <= (RS != RT)                   ? branch_target: branch_contin;
                            
                        end
            OP_BLT    : begin 
                            DFO_AA_BR <= ($signed(RS) <  $signed(RT)) ? branch_target: branch_contin;
                            
                        end
            OP_BGE    : begin 
                            DFO_AA_BR <= ($signed(RS) >= $signed(RT)) ? branch_target: branch_contin;
                            
                        end
            OP_BLTU   : begin 
                            DFO_AA_BR <= (RS <  RT)                   ? branch_target: branch_contin;
                            
                        end
            OP_BGEU   : begin 
                            DFO_AA_BR <= (RS >= RT)                   ? branch_target: branch_contin;
                            
                        end
            OP_AUIPC  : begin 
                            DFO_AA_BR <= auipc_target;
                            
                        end
            OP_JAL    : begin 
                            DFO_AA_BR <=  jal_target;
                            
                        end
            OP_JALR   : begin 
                            DFO_AA_BR <=   { jalr_pre_target[W_AA_INSTR-1-1:1], 1'b0 };
                            
                        end
            default   :     DFO_AA_BR <= V_AA_zero;
        endcase
    end
    
endmodule