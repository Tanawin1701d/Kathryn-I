


//$DECODER_PRE

//@DECODER_PRE




module DECODER (
     ST_BLK_G              con_st,  //provide state of the block
     CMD_BLK_G             con_cmd,  //
     TF_ARC_INSTR_TRI1     con_arch_instr,  //for receive instruction data from instruction loader
     BC_PREG_G             con_ud_preg,  //this is used for update physical register data
     COM_REGMNG_CALL_RDR1  con_res_call,  //this represent a protocol that decoder used to book for rob and provide some architecture register 
     TF_MARC_INSTR_TMI1    con_decoded_instr,  //port used to broadcast data from decoder to reservation station.
     CMD_COMMIT_DIRECTOR_G con_commit_direct,  //use to pass current booking instruction commiting guild to rob
     TF_PC_TP1             con_arch_pc,  //receive pc from instr loader
     TF_PC_TP1             con_arch_spec_pc  //receive pc from instr loader
);



//$DECODER
//constant_var
    // decode opcode_type type
    localparam PAR_op_r          = 7'b01_100_11; // same op hazard
    localparam PAR_op_rm         = 7'b01_100_11; // same-^
    localparam PAR_op_imm        = 7'b00_100_11;
    localparam PAR_op_branch     = 7'b11_000_11;
    localparam PAR_op_auipc      = 7'b00_101_11;
    localparam PAR_op_jal        = 7'b11_011_11;
    localparam PAR_op_jalr       = 7'b11_001_11;
    localparam PAR_op_rd         = 7'b01_100_11; // same-^
    localparam PAR_op_load       = 7'b00_000_11;
    localparam PAR_op_lui        = 7'b01_101_11;
    localparam PAR_op_store      = 7'b01_000_11;
    localparam PAR_op_misc_mem   = 7'b00_011_11;
    localparam PAR_op_system     = 7'b11_100_11;
    // special case of decoder
    localparam PAR_op_r_exc      =  7'b01_000_00;
    localparam PAR_op_rm_exc     =  7'b00_000_01; // rd so
    localparam PAR_op_imm_exc    =  7'b01_000_00; // SRAI instruction
    localparam PAR_op_rd_exc     =  7'b00_000_01; // divider
    localparam PAR_op_system_exc = 12'b0000_0000_0001; // ebreak so ecall use 0
    // micro op
    localparam PAR_W_mops        =  D_BL_MARC_OP; // micro opcode length -----v
    localparam PAR_W_mops_pref   =  3; // micro opcode prefix 3 upper bit
    localparam PAR_W_mops_suf    =  3; // micro opcode suffix 3 lower bit
    // // extend op
    // localparam PAR_op_r1      = 7'b0000000;
    // localparam PAR_op_r2      = 7'b0100000;
    // localparam PAR_op_rmd     = 7'b0000001;
    //localparam PAR_op_rd      = 3'd4;
    // instrution type
    localparam PAR_W_INSTR_T  = 3; 
    localparam PAR_rtype      = 3'b000;
    localparam PAR_itype      = 3'b001;
    localparam PAR_stype      = 3'b010;
    localparam PAR_btype      = 3'b011;
    localparam PAR_utype      = 3'b100;
    localparam PAR_jtype      = 3'b101;
    localparam PAR_NONTYPE    = 3'b111;
    // instruction slicer
     
    localparam PAR_W_opcode   = 7;
    localparam PAR_W_rx       = I_BL_ARC_REG;
    localparam PAR_W_funct7   = 7;
    localparam PAR_W_funct3   = 3;
    localparam PAR_W_imm12    = 12;
    localparam PAR_W_imm7     = 7;
    localparam PAR_W_imm20    = 20;
    localparam PAR_W_imm5     = 5;


    localparam PAR_STB_opcode    =  0;
    localparam PAR_STB_rd        =  7;
    localparam PAR_STB_r1        = 15;
    localparam PAR_STB_r2        = 20;
    localparam PAR_STB_funct7    = 25;   //start bit
    localparam PAR_STB_funct3    = 12;   //start bit
    localparam PAR_STB_imm_11_0  = 20;  
    localparam PAR_STB_imm_11_5  = 25;  
    localparam PAR_STB_imm_10_5  = 25; 
    localparam PAR_STB_imm_31_12 = 12;   
    localparam PAR_STB_imm_19_12 = 12;   
    localparam PAR_STB_imm_4_0   =  7;
    localparam PAR_STB_imm_4_1   =  7;
    
    // pi ops
    localparam PAR_NONPIP     = 4'd0; // execute pipe
    localparam PAR_XPIP       = 4'd1; // execute pipe
    localparam PAR_DPIP       = 4'd2; // divider pipe
    localparam PAR_CPIP       = 4'd3; // control status register pipe
    localparam PAR_LSPIP      = 4'd4; // load store pipe
    // source register req state
    localparam PAR_AMT_SPREG_STATE = 4;
    localparam PAR_W_SPREG_STATE   = 2;
    localparam PAR_STATE_SPREG_IDLE      = 2'b00;
    localparam PAR_STATE_SPREG_REQ       = 2'b01;
    localparam PAR_STATE_SPREG_READY     = 2'b10;
    localparam PAR_STATE_SPREG_READY_IDX = 2'b11;
    // des register  req state
    localparam PAR_AMT_DPREG_STATE       = 3;
    localparam PAR_W_DPREG_STATE         = 2;
    localparam PAR_STATE_DPREG_IDLE      = 2'b00;
    localparam PAR_STATE_DPREG_REQ       = 2'b01;
    localparam PAR_STATE_DPREG_READY     = 2'b10;

    ////////////////////////////////////////////////////////////////////////////////////
// slice the raw architecture instruction
    reg[D_BL_ARC_INSTR   -1:0] d_ainstr; // raw architecture dayta in this cycle
    TF_PC_TP1                  i_apc;
    TF_PC_TP1                  i_apc_spec;
    logic[PAR_W_INSTR_T  -1: 0] instr_type;
    logic[I_BL_MARC_PIP  -1: 0] i_pip;
    wire [D_BL_MARC_OP   -1: 0] c_op;
    logic[PAR_W_mops_pref-1: 0] uops_up;
    logic[PAR_W_mops_suf -1: 0] uops_dw;
    assign c_op = { uops_up, uops_dw};
    
    logic[PAR_W_opcode -1:0] ainstr_opcode;
    logic[PAR_W_rx     -1:0] ainstr_rd;
    logic[PAR_W_rx     -1:0] ainstr_r1;
    logic[PAR_W_rx     -1:0] ainstr_r2;
    logic[PAR_W_funct7 -1:0] ainstr_funct7;
    logic[PAR_W_funct3 -1:0] ainstr_funct3;
    logic[PAR_W_imm12  -1:0] ainstr_imm_11_0;
    logic[PAR_W_imm7   -1:0] ainstr_imm_11_5;
    logic[PAR_W_imm7   -1:0] ainstr_imm_10_5;
    logic[PAR_W_imm20  -1:0] ainstr_imm_31_12;
    logic[PAR_W_imm20  -1:0] ainstr_imm_19_12;
    logic[PAR_W_imm5   -1:0] ainstr_imm_4_0;
    logic[PAR_W_imm5   -1:0] ainstr_imm_4_1;

    assign ainstr_opcode    = d_ainstr[ PAR_STB_opcode    + PAR_W_opcode -1:PAR_STB_opcode   ];
    assign ainstr_rd        = d_ainstr[ PAR_STB_rd        + PAR_W_rx     -1:PAR_STB_rd       ];
    assign ainstr_r1        = d_ainstr[ PAR_STB_r1        + PAR_W_rx     -1:PAR_STB_r1       ];
    assign ainstr_r2        = d_ainstr[ PAR_STB_r2        + PAR_W_rx     -1:PAR_STB_r2       ];
    assign ainstr_funct7    = d_ainstr[ PAR_STB_funct7    + PAR_W_funct7 -1:PAR_STB_funct7   ];
    assign ainstr_funct3    = d_ainstr[ PAR_STB_funct3    + PAR_W_funct3 -1:PAR_STB_funct3   ];
    assign ainstr_imm_11_0  = d_ainstr[ PAR_STB_imm_11_0  + PAR_W_imm12  -1:PAR_STB_imm_11_0 ];
    assign ainstr_imm_11_5  = d_ainstr[ PAR_STB_imm_11_5  + PAR_W_imm7   -1:PAR_STB_imm_11_5 ];
    assign ainstr_imm_10_5  = d_ainstr[ PAR_STB_imm_10_5  + PAR_W_imm7   -1:PAR_STB_imm_10_5 ];
    assign ainstr_imm_31_12 = d_ainstr[ PAR_STB_imm_31_12 + PAR_W_imm20  -1:PAR_STB_imm_31_12];
    assign ainstr_imm_19_12 = d_ainstr[ PAR_STB_imm_19_12 + PAR_W_imm20  -1:PAR_STB_imm_19_12];
    assign ainstr_imm_4_0   = d_ainstr[ PAR_STB_imm_4_0   + PAR_W_imm5   -1:PAR_STB_imm_4_0  ];
    assign ainstr_imm_4_1   = d_ainstr[ PAR_STB_imm_4_1   + PAR_W_imm5   -1:PAR_STB_imm_4_1  ];
//indicate raw instruction type
    always_comb begin
        case ( ainstr_opcode ) 
        PAR_op_r,
        PAR_op_rm,           // It won't violate due to same rtype
        PAR_op_rd           : begin instr_type <= PAR_rtype; end // rtype
        PAR_op_imm,
        PAR_op_jalr,
        PAR_op_load,
        PAR_op_lui,
        PAR_op_misc_mem,
        PAR_op_system       : begin instr_type <= PAR_itype;   end // itype
        PAR_op_store        : begin instr_type <= PAR_stype;   end // stype
        PAR_op_branch       : begin instr_type <= PAR_btype;   end // btype
        PAR_op_auipc        : begin instr_type <= PAR_utype;   end // utype
        PAR_op_jal          : begin instr_type <= PAR_jtype;   end // jtype
        default             : begin instr_type <= PAR_NONTYPE; end // non type
        endcase
    end
// indicate pipe
    always_comb begin
        case ( ainstr_opcode )
            PAR_op_r,
            //PAR_op_rm,
            PAR_op_imm,
            PAR_op_branch,
            PAR_op_auipc,
            PAR_op_jal,
            PAR_op_jalr         : begin  
                                        // seperate div type                                    // v-----------multiplier use same imm11:5 with div
                                        if ( (ainstr_opcode == PAR_op_r) && (ainstr_imm_11_5 == PAR_op_rm_exc) && (ainstr_funct3 >= 3'd4) )
                                        begin
                                            i_pip <= PAR_DPIP;
                                        end else begin
                                            i_pip <= PAR_XPIP; 
                                        end
                                    
                                    end
            //PAR_op_rd           : begin i_pip <= PAR_DPIP; end
            PAR_op_load,
            PAR_op_lui,
            PAR_op_store,        
            PAR_op_misc_mem     : begin  i_pip <= PAR_LSPIP; end
            PAR_op_system       : begin  i_pip <= PAR_CPIP;  end
            default             : begin  i_pip <= PAR_NONPIP;end
        endcase
    end
// indicate micro ops
    always_comb begin
        case ( ainstr_opcode )
            PAR_op_r               :begin   
                                            if (ainstr_imm_11_5 == PAR_op_r_exc)begin
                                                uops_up <= 3'b001;
                                                uops_dw <= (ainstr_funct3 == 3'b000) ? 3'd4: 3'd5; // 3'b000 for sub
                                            end else if ( ainstr_imm_11_5 == PAR_op_rm_exc ) begin // for multiple and div
                                                uops_up <= 3'b001;
                                                uops_dw <= ainstr_funct3;
                                            end else begin
                                                uops_up <= 3'b000;
                                                uops_dw <= ainstr_funct3;
                                            end
                                    end 
            // PAR_op_rm              :begin   
            //                                 uops_up <= 3'b001;
            //                                 uops_dw <= ainstr_funct3;
            //                         end
            PAR_op_imm             :begin   
                                            if (ainstr_funct7 == PAR_op_imm_exc)begin
                                                uops_up <= 3'b011;
                                                uops_dw <= 3'd2;
                                            end else begin
                                                uops_up <= 3'b010;
                                                uops_dw <= ainstr_funct3;
                                            end
                                    end
            PAR_op_branch          :begin   
                                            uops_up <= 3'b011;
                                            uops_dw <= ainstr_funct3;
                                    end
            PAR_op_auipc           :begin   
                                            uops_up <= 3'b100;
                                            uops_dw <= 3'd0;
                                    end
            PAR_op_jal             :begin   
                                            uops_up <= 3'b100;
                                            uops_dw <= 3'd1;
                                    end
            PAR_op_jalr            :begin   
                                            uops_up <= 3'b100;
                                            uops_dw <= 3'd2;
                                    end
            // PAR_op_rd              :begin   
            //                                 uops_up <= 3'b100;
            //                                 uops_dw <= ainstr_funct3;
            //                        end
            PAR_op_load            :begin   
                                            uops_up <= 3'b000;
                                            uops_dw <= ainstr_funct3;
                                    end
            PAR_op_lui             :begin   
                                            uops_up <= 3'b000;
                                            uops_dw <= 3'd3;
                                    end
            PAR_op_store           :begin   
                                            uops_up <= 3'b001;
                                            uops_dw <= ainstr_funct3;
                                    end
            PAR_op_misc_mem        :begin   
                                            uops_up <= 3'b010;
                                            uops_dw <= ainstr_funct3;
                                    end
            PAR_op_system          :begin   
                                            if (ainstr_funct3 == 3'd0)begin
                                                uops_up <= 3'b000;
                                                uops_dw <= {2'b0, ainstr_imm_11_0[0]};
                                            end else begin
                                                uops_up <= 3'b001;
                                                uops_dw <= ainstr_funct3;
                                            end
                                            
                                    end
            default                :begin
                                        // no-op   
                                         uops_up <= 3'b000;
                                         uops_dw <= 3'b000;   
                                    end
        endcase
    end
//declare register that used in this block

    //src register
    //r1
    reg[PAR_W_SPREG_STATE-1:0] state_preg_r1;
    reg[D_BL_MARC_REG    -1:0] d_preg_r1;
    reg[I_BL_MARC_REG    -1:0] i_preg_r1;
    reg                        s_preg_r1;
    wire                       need_preg_r1;
    wire                       ready_preg_r1;
    //r2
    reg[PAR_W_SPREG_STATE-1:0] state_preg_r2;
    reg[D_BL_MARC_REG    -1:0] d_preg_r2;
    reg[I_BL_MARC_REG    -1:0] i_preg_r2;
    reg                        s_preg_r2;
    wire                       need_preg_r2;
    wire                       ready_preg_r2;
    // des register    
    reg[PAR_W_SPREG_STATE-1:0] state_preg_rd;
    reg[I_BL_MARC_REG    -1:0] i_preg_rd;
    wire                       need_preg_rd;
    wire                       ready_preg_rd;
// for now r1 and r2 is the same but they will differ in the future
//r1_controller
    assign need_preg_r1 = (instr_type == PAR_rtype) ||
                          (instr_type == PAR_itype) ||
                          (instr_type == PAR_stype) ||
                          (instr_type == PAR_btype);
    assign ready_preg_r1= (state_preg_r1 == PAR_STATE_SPREG_READY) || ((state_preg_r1 == PAR_STATE_SPREG_READY_IDX) && (i_preg_r1 != con_ud_preg.i_preg_rb1));

    always @(posedge con_cmd.c_clock) begin
        if (con_cmd.c_reset)begin
            // case reset 
            state_preg_r1 <= PAR_STATE_SPREG_IDLE;
        end else begin
            // case not reset 
            case (state_preg_r1)
                PAR_STATE_SPREG_IDLE        :begin 
                                                if ( con_cmd.c_enable )begin
                                                    // receive instruction form instruction page walker
                                                    state_preg_r1 <= PAR_STATE_SPREG_REQ;
                                                end
                                            end
                PAR_STATE_SPREG_REQ         :begin 
                                                if (need_preg_r1 && con_res_call.s_preg_r1)begin
                                                    state_preg_r1 <= PAR_STATE_SPREG_READY;
                                                    s_preg_r1     <= con_res_call.s_preg_r1;
                                                    i_preg_r1     <= con_res_call.i_preg_r1;
                                                    d_preg_r1     <= con_res_call.d_preg_r1;
                                                end else if ( need_preg_r1 && !con_res_call.s_preg_r1 )begin
                                                    state_preg_r1 <= PAR_STATE_SPREG_READY_IDX;
                                                    s_preg_r1     <= con_res_call.s_preg_r1;
                                                    i_preg_r1     <= con_res_call.i_preg_r1;
                                                end else if ( !need_preg_r1 )begin
                                                    state_preg_r1 <= PAR_STATE_SPREG_READY;
                                                    s_preg_r1     <= 1'b1;
                                                end
                                            end
                PAR_STATE_SPREG_READY       :begin 
                                                if ( (!con_cmd.c_pause) && con_st.s_input )begin // didn't pause and all subsystem is ready otherwise this section will be freeze
                                                    //let it go but what is next state should be
                                                    if ( con_cmd.c_enable )
                                                        state_preg_r1 <= PAR_STATE_SPREG_REQ;
                                                    else
                                                        state_preg_r1 <= PAR_STATE_SPREG_IDLE;
                                                end
                                            end
                PAR_STATE_SPREG_READY_IDX   :begin 
                                                if ( i_preg_r1 ==  con_ud_preg.i_preg_rb1)begin
                                                    //receive data from broad cast
                                                    state_preg_r1 <= PAR_STATE_SPREG_READY;
                                                    s_preg_r1     <= 1'b1;
                                                    d_preg_r1     <= con_ud_preg.d_preg_rb1;
                                                end else if ( (!con_cmd.c_pause) && con_st.s_input)begin
                                                    //let it go but what is next state should be
                                                    if ( con_cmd.c_enable )
                                                        state_preg_r1 <= PAR_STATE_SPREG_REQ;
                                                    else
                                                        state_preg_r1 <= PAR_STATE_SPREG_IDLE;
                                                end   
                                            end
            endcase            
            

        end
    end
//r2_controller
    assign need_preg_r2 = (instr_type == PAR_rtype) ||
                          (instr_type == PAR_stype) ||
                          (instr_type == PAR_btype);
    assign ready_preg_r2= (state_preg_r2 == PAR_STATE_SPREG_READY) || ( (state_preg_r2 == PAR_STATE_SPREG_READY_IDX) && (i_preg_r2 != con_ud_preg.i_preg_rb1)  );

    always @(posedge con_cmd.c_clock) begin
        if (con_cmd.c_reset)begin
            // case reset 
            state_preg_r2 <= PAR_STATE_SPREG_IDLE;
        end else begin
            // case not reset 
            case (state_preg_r2)
                PAR_STATE_SPREG_IDLE        :begin 
                                                if ( con_cmd.c_enable )begin
                                                    // receive instruction form instruction page walker
                                                    state_preg_r2 <= PAR_STATE_SPREG_REQ;
                                                end
                                            end
                PAR_STATE_SPREG_REQ         :begin 
                                                if (need_preg_r2 && con_res_call.s_preg_r2)begin
                                                    state_preg_r2 <= PAR_STATE_SPREG_READY;
                                                    s_preg_r2     <= con_res_call.s_preg_r2;
                                                    i_preg_r2     <= con_res_call.i_preg_r2;
                                                    d_preg_r2     <= con_res_call.d_preg_r2;
                                                end else if ( need_preg_r2 && !con_res_call.s_preg_r2 )begin
                                                    state_preg_r2 <= PAR_STATE_SPREG_READY_IDX;
                                                    s_preg_r2     <= con_res_call.s_preg_r2;
                                                    i_preg_r2     <= con_res_call.i_preg_r2;
                                                end else if ( !need_preg_r2 )begin
                                                    state_preg_r2 <= PAR_STATE_SPREG_READY;
                                                    s_preg_r2     <= 1'b1;

                                                end
                                            end
                PAR_STATE_SPREG_READY       :begin 
                                                if ( (!con_cmd.c_pause) && con_st.s_input  )begin
                                                    //let it go but what is next state should be
                                                    if ( con_cmd.c_enable )
                                                        state_preg_r2 <= PAR_STATE_SPREG_REQ;
                                                    else
                                                        state_preg_r2 <= PAR_STATE_SPREG_IDLE;
                                                end
                                            end
                PAR_STATE_SPREG_READY_IDX   :begin 
                                                if ( i_preg_r2 ==  con_ud_preg.i_preg_rb1)begin
                                                    //receive data from broad cast
                                                    state_preg_r2 <= PAR_STATE_SPREG_READY;
                                                    s_preg_r2     <= 1;
                                                    d_preg_r2     <= con_ud_preg.d_preg_rb1;
                                                end else if ( (!con_cmd.c_pause) && con_st.s_input  )begin
                                                    //let it go but what is next state should be
                                                    if ( con_cmd.c_enable )
                                                        state_preg_r2 <= PAR_STATE_SPREG_REQ;
                                                    else
                                                        state_preg_r2 <= PAR_STATE_SPREG_IDLE;
                                                end   
                                            end
            endcase            
        end
    end
//rd_controller
    assign need_preg_rd =     (instr_type == PAR_rtype) ||
                              (instr_type == PAR_itype) ||
                              (instr_type == PAR_utype) ||
                              (instr_type == PAR_jtype);
    assign ready_preg_rd= (state_preg_rd == PAR_STATE_DPREG_READY);

    always @(posedge con_cmd.c_clock)begin
        if (con_cmd.c_reset)begin
            state_preg_rd <= PAR_STATE_DPREG_IDLE;
        end else begin
            case(state_preg_rd)
            PAR_STATE_DPREG_IDLE:begin
                                        if (con_cmd.c_enable)begin
                                            state_preg_rd <= PAR_STATE_DPREG_REQ;
                                        end
                                end
            PAR_STATE_DPREG_REQ:begin
                                        if (con_res_call.s_req_status)begin
                                            i_preg_rd <= i_preg_rd;
                                            state_preg_rd <= PAR_STATE_DPREG_READY;
                                        end
                                end
            PAR_STATE_DPREG_READY:begin
                                        if ((!con_cmd.c_pause) && con_st.s_input)begin  // not pause and all subsystem is ready
                                            if (con_cmd.c_enable) begin
                                                state_preg_rd <= PAR_STATE_DPREG_REQ;
                                            end else begin
                                                state_preg_rd <= PAR_STATE_DPREG_IDLE;
                                            end
                                        end
                                end
            endcase
        end
    end
// io connect
    //st_blk
    assign con_st.s_input = (con_st.s_output   && (!con_cmd.c_pause)) ||(   ( state_preg_r1 == PAR_STATE_SPREG_IDLE )
                                                             && ( state_preg_r2 == PAR_STATE_SPREG_IDLE )
                                                             && ( state_preg_rd == PAR_STATE_DPREG_IDLE ));
    assign con_st.s_output= ready_preg_r1 && ready_preg_r2  && ready_preg_rd;
    // con_arch_instr
    always @((posedge con_cmd.c_clock) && con_cmd.c_enable) begin 
        d_ainstr    <= con_arch_instr.d_instr; 
        
        i_apc.i_pc  <= con_arch_pc.i_pc;
        i_apc.i_pvl <= con_arch_pc.i_pvl;

        i_apc_spec.pc  <= con_arch_spec_pc.i_pc;
        i_apc_spec.pvl <= con_arch_spec_pc.i_pvl;
        
    end
    // res call
    assign con_res_call.i_areg_rd = ainstr_rd;
    assign con_res_call.i_areg_r1 = ainstr_r1;
    assign con_res_call.i_areg_r2 = ainstr_r2;
    assign con_res_call.c_req     = (state_preg_rd == PAR_STATE_DPREG_REQ);
    assign con_res_call.i_spec_pc = i_apc_spec.pc ; // upgrade this to remem state
    assign con_res_call.i_spec_pvl= i_apc_spec.pvl;  // upgrade this to remem state
    assign con_res_call.i_pip     = i_pip;
    assign con_res_call.c_op      = c_op;
    // con_decoded_instr
    assign con_decoded_instr.i_preg_rd          = i_preg_rd;
    assign con_decoded_instr.i_preg_r1          = i_preg_r1;
    assign con_decoded_instr.i_preg_r2          = i_preg_r2;
    assign con_decoded_instr.s_preg_r1          = s_preg_r1;
    assign con_decoded_instr.s_preg_r2          = s_preg_r2;
    assign con_decoded_instr.d_preg_r1          = d_preg_r1;
    assign con_decoded_instr.d_preg_r2          = d_preg_r2;
    assign con_decoded_instr.d_imm              = d_ainstr ;
    assign con_decoded_instr.i_creg_r1          = 0        ;
    assign con_decoded_instr.i_pip              = i_pip    ;
    assign con_decoded_instr.c_op               = c_op     ;
    assign con_decoded_instr.PC.i_pc            = i_apc.i_pc;
    assign con_decoded_instr.PC.i_pvl           = i_apc.i_pvl;
    // commit director
    assign con_commit_direct.c_store                   = (instr_type == PAR_op_store);
    assign con_commit_direct.c_load                    = (instr_type == PAR_op_load) ||
                                                         (instr_type == PAR_op_lui);
    assign con_commit_direct.c_ptoa_reg                = (ainstr_opcode == PAR_op_r) ||
                                                         (ainstr_opcode == PAR_op_imm) ||
                                                         (ainstr_opcode == PAR_op_auipc) ||
                                                         (ainstr_opcode == PAR_op_jal) ||
                                                         (ainstr_opcode == PAR_op_jalr);

    // TODO for now privilege is not set and branch is not assign to commit director

    
//@DECODER



endmodule



//$DECODER_POST

//@DECODER_POST




