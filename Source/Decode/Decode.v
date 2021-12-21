module Decode 
    #(
        parameter W_AA_REG = 5,
        parameter W_PA_REG = 5,
        parameter W_AA_INSTR = 32,
        parameter W_PA_CSR  =  11,

        parameter W_PD_req   = 2,
        parameter W_AD_INSTR = 32,
        parameter W_AD_OP    = 7,
        parameter W_PD_POPS  = 3,
        parameter W_PD_UOPS  = 6,
        parameter W_PD_DATA  = 32
     )
    (
        //output
            // dfo dataflow output
                // uops
                output wire[W_PD_req  -1:0] DFI_PD_REQ,
                output wire[W_PD_UOPS -1:0] DFO_PD_uops,
                //data
                output wire[W_PD_DATA -1:0] DFO_PD_rs,
                output wire[W_PD_DATA -1:0] DFO_PD_rt,
                output wire[W_PD_DATA -1:0] DFO_PD_imm,
                //address
                output wire[W_PA_REG  -1:0] DFO_PA_rd,
                output wire[W_PA_REG  -1:0] DFO_PA_rs,
                output wire[W_PA_REG  -1:0] DFO_PA_rt,
                output wire[W_PA_CSR  -1:0] DFO_PA_cs,
                output wire[W_AA_INSTR-1:0] DFO_AA_pc,
                // validation
                output wire DFO_PV_rs,
                output wire DFO_PV_rt,
            // CDO ControlData Output
                // ops
                output wire[W_PD_POPS -1:0] CDO_PD_piops,
                output wire[W_PD_UOPS -1:0] CDO_PD_uops,
                // addr
                output wire[W_AA_REG  -1:0] CDO_AA_rd,
                output wire[W_AA_REG  -1:0] CDO_AA_rs,
                output wire[W_AA_REG  -1:0] CDO_AA_rt,
                output wire[W_AA_INSTR-1:0] CDO_AA_spec,
            // CFO ControlFlow Output
                output wire                 CFO_PC_book,
        //input
            // dfi
                // data
                input wire[W_AD_INSTR-1:0] DFI_AD_instr,
                    
                // address
                input wire[W_AA_INSTR-1:0] DFI_AA_pc,
                input wire[W_AA_INSTR-1:0] DFI_AA_spec,
            // cdi
                // data
                input wire[W_PD_DATA -1:0] CDI_PD_rs,
                input wire[W_PD_DATA -1:0] CDI_PD_rt,
                // address
                input wire[W_PA_REG  -1:0] CDI_PA_rd,
                input wire[W_PA_REG  -1:0] CDI_PA_rs,
                input wire[W_PA_REG  -1:0] CDI_PA_rt,
                // validation
                input wire                 CDI_PV_rs,
                input wire                 CDI_PV_rt, 
            // cfi
                input wire                 CFI_PC_stall,
                input wire                 CFI_PC_clear,
                input wire                 clk
    );

    // status
    reg FLAG_CLEAR;
    reg FLAG_STALL;
    // state reg
    reg[W_AD_INSTR-1:0] INSTRUCT;
    reg[W_AA_INSTR-1:0] PC;
    reg[W_AA_INSTR-1:0] SPEC;
    
    // state controller
    always @( posedge clk) begin
        if (CFI_PC_clear)begin
            INSTRUCT     <= {W_AD_INSTR{1'b0}};
            PC           <= {W_AA_INSTR{1'b0}};
            SPEC         <= {W_AA_INSTR{1'b0}};
            FLAG_CLEAR <= 1;
            FLAG_STALL <= 0;
        end else if (CFI_PC_stall)begin
            FLAG_CLEAR <= 0;
            FLAG_STALL <= 1;
        end else begin
            INSTRUCT     <= DFI_AD_instr;
            PC           <= DFI_AA_pc;
            SPEC         <= DFI_AA_spec;
            FLAG_CLEAR   <= 0;
            FLAG_STALL   <= 0;
        end
    end
    // parameter
    // decode opcode_type type
    localparam PAR_op         = 7'b01_100_11;
    localparam PAR_op_imm     = 7'b00_100_11;
    localparam PAR_auipc      = 7'b00_101_11;
    localparam PAR_jal        = 7'b11_011_11;
    localparam PAR_jalr       = 7'b11_001_11;
    localparam PAR_branch     = 7'b11_000_11;
    localparam PAR_lui        = 7'b01_101_11;
    localparam PAR_load       = 7'b00_000_11;
    localparam PAR_store      = 7'b01_000_11;
    localparam PAR_misc_mem   = 7'b00_011_11;
    localparam PAR_system     = 7'b11_100_11;
    // extend op
    localparam PAR_op_r1      = 7'b0000000;
    localparam PAR_op_r2      = 7'b0100000;
    localparam PAR_op_rmd     = 7'b0000001;
    localparam PAR_op_rd      = 3'd4;
    // instrution type
    localparam PAR_W_INSTR_T  = 3; 
    localparam PAR_rtype      = 3'b000;
    localparam PAR_itype      = 3'b001;
    localparam PAR_stype      = 3'b010;
    localparam PAR_btype      = 3'b011;
    localparam PAR_utype      = 3'b100;
    localparam PAR_jtype      = 3'b101;
    // instruction slicer
    localparam PAR_W_funct7   = 7;
    localparam PAR_W_funct3   = 3;
    localparam PAR_W_imm12    = 12;
    localparam PAR_W_imm7     = 7;
    localparam PAR_W_imm20    = 20;
    localparam PAR_W_imm5     = 5;

    localparam PAR_STB_funct7 = 25;   //start bit
    localparam PAR_STB_funct3 = 12;   //start bit
    localparam PAR_STB_imm12  = 20;  //start bit
    localparam PAR_STB_imm7   = 25;   //start bit
    localparam PAR_STB_imm20  = 12;  //start bit
    localparam PAR_STB_imm5   =  7;   //start bit
    localparam PAR_STB_rd     =  7;
    localparam PAR_STB_rs     =  15;
    localparam PAR_STB_rt     =  20;
    // pi ops
    localparam PAR_XPIP       = 3'd0;
    localparam PAR_DPIP       = 3'd1;
    localparam PAR_LPIP       = 3'd2;
    localparam PAR_CPIP       = 3'd3;
    // req
    localparam PAR_REQ_NU     = 2'b00;
    localparam PAR_REQ_RS     = 2'b01;
    localparam PAR_REQ_RT     = 2'b10;

    // slice instruction
    wire[W_AD_OP -1:0]      op     = INSTRUCT[                 W_AD_OP     -1:0              ];
    wire[W_AA_REG-1:0]      rd     = INSTRUCT[PAR_STB_rd     + W_AA_REG    -1:PAR_STB_rd     ];
    wire[W_AA_REG-1:0]      rs     = INSTRUCT[PAR_STB_rs     + W_AA_REG    -1:PAR_STB_rs     ];
    wire[W_AA_REG-1:0]      rt     = INSTRUCT[PAR_STB_rt     + W_AA_REG    -1:PAR_STB_rt     ];

    wire[PAR_W_funct7-1:0]  funct7 = INSTRUCT[PAR_STB_funct7 + PAR_W_funct7-1:PAR_STB_funct7 ];
    wire[PAR_W_funct3-1:0]  funct3 = INSTRUCT[PAR_STB_funct3 + PAR_W_funct3-1:PAR_STB_funct3 ];
    wire[PAR_W_imm12 -1:0]  imm12  = INSTRUCT[PAR_STB_imm12  + PAR_W_imm12 -1:PAR_STB_imm12  ];
    wire[PAR_W_imm7  -1:0]  imm7   = INSTRUCT[PAR_STB_imm7   + PAR_W_imm7  -1:PAR_STB_imm7   ];
    wire[PAR_W_imm20 -1:0]  imm20  = INSTRUCT[PAR_STB_imm20  + PAR_W_imm20 -1:PAR_STB_imm20  ];
    wire[PAR_W_imm5  -1:0]  imm5   = INSTRUCT[PAR_STB_imm5   + PAR_W_imm5  -1:PAR_STB_imm5   ];

    wire FLAG_TYPE_op_R      = (op == PAR_op)        && ( (funct7 == PAR_op_r1 ) || (funct7 ==  PAR_op_r2));
    wire FLAG_TYPE_op_RM     = (op == PAR_op)        &&   (funct7 == PAR_op_rmd) && (funct3 <   3'd4     );
    wire FLAG_TYPE_op_RD     = (op == PAR_op)        &&   (funct7 == PAR_op_rmd) && (funct3 >=  3'd4     );
    wire FLAG_TYPE_op_imm    = (op == PAR_op_imm   );
    wire FLAG_TYPE_auipc     = (op == PAR_auipc    );
    wire FLAG_TYPE_jal       = (op == PAR_jal      );
    wire FLAG_TYPE_jalr      = (op == PAR_jalr     );
    wire FLAG_TYPE_branch    = (op == PAR_branch   );
    wire FLAG_TYPE_lui       = (op == PAR_lui      );
    wire FLAG_TYPE_load      = (op == PAR_load     );
    wire FLAG_TYPE_store     = (op == PAR_store    );
    wire FLAG_TYPE_misc_mem  = (op == PAR_misc_mem );
    wire FLAG_TYPE_system    = (op == PAR_system   );
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // opcode translation to physical ops
    wire[W_PD_POPS-1:0]   piops;
    reg [5          :3]   uops1;
    reg [2          :0]   uops0;
    wire[W_PD_UOPS-1:0]   uops  = {uops1,uops0}; // act as wire
    assign piops =   (
                         FLAG_TYPE_op_R 
                      || FLAG_TYPE_op_RM
                      || FLAG_TYPE_op_imm
                      || FLAG_TYPE_auipc
                      || FLAG_TYPE_jal
                      || FLAG_TYPE_jalr
                      || FLAG_TYPE_branch
                     )                    ? PAR_XPIP: 
                     (
                         FLAG_TYPE_op_RD   
                     )                     ? PAR_DPIP:
                     (
                         FLAG_TYPE_lui
                      || FLAG_TYPE_load
                      || FLAG_TYPE_store
                      || FLAG_TYPE_misc_mem   
                     )                     ? PAR_LPIP:
                     (
                         FLAG_TYPE_system
                     )                     ? PAR_CPIP: PAR_XPIP;

    always @(*) begin
        case (piops)
        PAR_XPIP : begin 

                        if ( FLAG_TYPE_op_R && (funct7 == PAR_op_r1) )                     begin uops1 <= 3'b000; uops0 <= funct3;                         end else
                        if ( FLAG_TYPE_op_R && (funct7 == PAR_op_r2) )                     begin uops1 <= 3'b001; uops0 <= (funct3 == 3'd0) ? 3'd4 : 3'd5; end else
                        if ( FLAG_TYPE_op_RM                       )                       begin uops1 <= 3'b001; uops0 <= funct3;                         end else
                        if ( FLAG_TYPE_op_imm && !(funct3 == 3'd5 && imm7 == 7'b0100000) ) begin uops1 <= 3'b010; uops0 <= funct3;                         end else
                        if ( FLAG_TYPE_op_imm &&  (funct3 == 3'd5 && imm7 == 7'b0100000) ) begin uops1 <= 3'b011; uops0 <= 3'd2;                           end else
                        if ( FLAG_TYPE_branch)                                             begin uops1 <= 3'b011; uops0 <= funct3;                         end else
                        if ( FLAG_TYPE_auipc)                                              begin uops1 <= 3'b100; uops0 <= 3'd0;                           end else
                        if ( FLAG_TYPE_jal  )                                              begin uops1 <= 3'b100; uops0 <= 3'd1;                           end else
                        if ( FLAG_TYPE_jalr )                                              begin uops1 <= 3'b100; uops0 <= 3'd2;                           end else
                                                                                           begin uops1 <= 3'b111; uops0 <= 3'd7;                           end
                   end
        PAR_DPIP : begin 
                        uops1 <= 3'b000; 
                        uops0 <= funct3;
                   end
        PAR_LPIP : begin 
                        if ( FLAG_TYPE_load  )    begin  uops1 <= 3'b000; uops0 <= funct3; end else
                        if ( FLAG_TYPE_lui   )    begin  uops1 <= 3'b000; uops0 <= 3'd3;   end else
                        if ( FLAG_TYPE_store )    begin  uops1 <= 3'b001; uops0 <= funct3; end else
                        if ( FLAG_TYPE_misc_mem ) begin  uops1 <= 3'b010; uops0 <= funct3; end else
                                                  begin  uops1 <= 3'b111; uops0 <= 3'd7;   end
        end
        PAR_CPIP : begin 
                        if (funct3 == 3'd0 )      begin  uops1 <= 3'b000; uops0 <= (imm12 == 12'b000000000001) ? 3'd1 : 3'd0; end else
                                                  begin  uops1 <= 3'b001; uops0 <= funct3;                                    end
        end
        default  : begin uops1 <= 3'b111; uops0 <= 3'd7; end
        endcase
    end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// identify instruction type
    wire[PAR_W_INSTR_T-1:0]   instr_type =     (   FLAG_TYPE_op_R
                                                 ||FLAG_TYPE_op_RM
                                                 ||FLAG_TYPE_op_RD
                                               )                      ?PAR_rtype :
                                               (
                                                   FLAG_TYPE_op_imm
                                                 ||FLAG_TYPE_jalr
                                                 ||FLAG_TYPE_lui
                                                 ||FLAG_TYPE_load
                                                 ||FLAG_TYPE_misc_mem
                                                 ||FLAG_TYPE_system
                                               )                      ?PAR_itype :
                                               (
                                                   FLAG_TYPE_store
                                               )                      ?PAR_stype :
                                               (
                                                   FLAG_TYPE_branch
                                               )                      ?PAR_btype :
                                               (
                                                   FLAG_TYPE_auipc
                                               )                      ?PAR_utype :
                                               (
                                                   FLAG_TYPE_jal
                                               )                      ?PAR_jtype :PAR_rtype ;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////output
    //output Data Flow
    //op & req
    assign DFI_PD_REQ         = (  
                                    ( (instr_type == PAR_rtype) || (instr_type == PAR_itype) ||
                                      (instr_type == PAR_stype) || (instr_type == PAR_btype)   
                                    )  ? PAR_REQ_RS : PAR_REQ_NU
                                )    
                                |  
                                (    
                                    ( (instr_type == PAR_rtype) || (instr_type == PAR_stype) ||
                                      (instr_type == PAR_btype)
                                    )  ? PAR_REQ_RT : PAR_REQ_NU
                                );
    assign DFO_PD_uops = uops;
    //data
    assign DFO_PD_rs   = CDI_PD_rs;
    assign DFO_PD_rt   = CDI_PD_rt;
    assign DFO_PD_IMM  =  
                               instr_type == PAR_itype ? imm12:
                               instr_type == PAR_stype ? {imm7,imm5}:
                               instr_type == PAR_btype ? {imm7,imm5}:
                               instr_type == PAR_utype ? {imm20}: 
                               instr_type == PAR_jtype ? {imm20}: 0;
    assign DFO_PA_pc   = DFI_AA_pc;
                        
    //address
    assign DFO_PA_rd   = CDI_PA_rd;
    assign DFO_PA_rs   = CDI_PA_rs;
    assign DFO_PA_rt   = CDI_PA_rt;
    assign DFO_PA_cs   = imm12;
    assign DFO_PV_rs   = CDI_PV_rs;
    assign DFO_PV_rt   = CDI_PV_rt;


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // output Control Dataflow

    // ops
        assign CDO_PD_piops = piops;
        assign CDO_PD_uops  = uops;
    // request register addressing
        assign CDO_AA_rd = (   instr_type == PAR_rtype
                            || instr_type == PAR_itype
                            || instr_type == PAR_utype
                            || instr_type == PAR_jtype
                           )                              ? rd : {W_AA_REG{1'b0}};

        assign CDO_AA_rs = (   instr_type == PAR_rtype
                            || instr_type == PAR_itype
                            || instr_type == PAR_stype
                            || instr_type == PAR_btype
                           )                              ? rs : {W_AA_REG{1'b0}};

        assign CDO_AA_rt = (   instr_type == PAR_rtype
                            || instr_type == PAR_stype
                            || instr_type == PAR_btype
                           )                              ? rt : {W_AA_REG{1'b0}};
        assign CDO_AA_spec = DFI_AA_spec;
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // output Control Flow
        assign CFI_PC_book = ~FLAG_CLEAR;
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    


endmodule