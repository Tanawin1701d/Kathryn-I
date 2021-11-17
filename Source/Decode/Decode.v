module Decode 
    #(
        parameter W_addr_prf = 5, // width address physical arch
        parameter W_data_prf = 32,
        parameter W_addr_arf = 5, 
        parameter W_data_arf = 32,// width  data architectural arch       
        parameter W_uops     = 6,
        parameter W_pops     = 3,
        parameter W_opcode   = 7,
        parameter par_xpip   = 3'b000, // execute    pip
        parameter par_dpip   = 3'b001, // div        pip
        parameter par_lpip   = 3'b010 // load store pip
    )
    (
        //output data flow
                // p
                output wire[W_uops-1:0]      val_pah_uops_odf,
                // data
                output wire[W_data_prf-1:0]  val_prf_r1_odf,
                output wire[W_data_prf-1:0]  val_prf_r2_odf,
                output wire[W_data_prf-1:0]  val_prf_imm_odf,
                // addr
                output wire[W_addr_prf-1:0]  addr_prf_r1_odf,
                output wire[W_addr_prf-1:0]  addr_prf_r2_odf,
                output wire[W_addr_prf-1:0]  addr_prf_r3_odf,
                // validation
                output wire                  valid_prf_r1_odf,
                output wire                  valid_prf_r2_odf,
                // pc cpy
                output wire[W_data_arf-1:0]  val_arh_pc_odf,
        //output control data flow
                // op
                output wire[W_pops-1    :0]  val_pah_pops_ocdf,
                output wire[W_uops-1    :0]  val_pah_uops_ocdf,
                // addr
                output wire[W_addr_arf-1:0]  addr_arf_r1_ocdf,
                output wire[W_addr_arf-1:0]  addr_arf_r2_ocdf,
                output wire[W_addr_arf-1:0]  addr_arf_r3_ocdf,
                // spec
                output wire[W_data_arf-1:0] val_arh_spec_ocdf,
            //output control flow
                output wire                 booking,
        
        ///////////////////////////////////////////////////////////////////////////////
        
        
        // input data flow
            // p
                input wire[W_data_arf-1:0] val_arh_instruct_idf,
                input wire[W_data_arf-1:0] val_arh_pc_idf,
                input wire[W_data_arf-1:0] val_arh_spec_idf,
        // input control data flow
            //data
            input wire[W_data_prf-1:0] val_prf_r1_icdf,
            input wire[W_data_prf-1:0] val_prf_r2_icdf,
            //addr
            input wire[W_addr_prf-1:0] addr_prf_r1_icdf,
            input wire[W_addr_prf-1:0] addr_prf_r2_icdf,
            input wire[W_addr_prf-1:0] addr_prf_r3_icdf,
            //valid
            input wire valid_prf_r1_icdf,
            input wire valid_prf_r2_icdf,
        // input control flow
            input wire stall,
            input wire clear,
            input wire clock
    );

    // status
    reg CLEAR_STATUS;
    reg STALL_STATUS;
    // state reg
    reg[W_data_arf-1:0] INSTRUCT;
    reg[W_data_arf-1:0] PC;
    reg[W_data_arf-1:0] SPEC;
    
    // state controller
    always @( posedge clock) begin
        if (clear)begin
            INSTRUCT     <= {W_data_arf{1'b0}};
            PC           <= {W_data_arf{1'b0}};
            SPEC         <= {W_data_arf{1'b0}};
            CLEAR_STATUS <= 1;
            STALL_STATUS <= 0;
        end else if (stall)begin
            //INSTRUCT     <= val_arh_instruct_idf;   state reg do_nothing
            //PC           <= val_arh_pc_idf;
            //SPEC         <= val_arh_spec_idf;
            CLEAR_STATUS <= 0;
            STALL_STATUS <= 1;
        end else begin
            INSTRUCT     <= val_arh_instruct_idf;
            PC           <= val_arh_pc_idf;
            SPEC         <= val_arh_spec_idf;
            CLEAR_STATUS <= 0;
            STALL_STATUS <= 0;
        end
    end

    // decode instruction type
    localparam par_op       = 7'b0110011;
    localparam par_op_imm   = 7'b0010011;
    localparam par_auipc    = 7'b0010111;
    localparam par_jal      = 7'b1101111;
    localparam par_jalr     = 7'b1100111;
    localparam par_branch   = 7'b1100011;
    localparam par_lui      = 7'b0110111;
    localparam par_load     = 7'b0000000;
    localparam par_store    = 7'b0100011;
    localparam par_misc_mem = 7'b0001100;
    // instrution type
    localparam par_instr_type_w  = 3;
    localparam par_rtype    = 3'b000;
    localparam par_itype    = 3'b001;
    localparam par_stype    = 3'b010;
    localparam par_btype    = 3'b011;
    localparam par_utype    = 3'b100;
    localparam par_jtype    = 3'b101;
    // instruction slicer
    localparam par_w_funct7 = 7;
    localparam par_w_funct3 = 3;
    localparam par_w_imm12  = 12;
    localparam par_w_imm7   = 7;
    localparam par_w_imm20  = 20;
    localparam par_w_imm5   = 5;

    localparam par_stb_funct7 = 25;   //start bit
    localparam par_stb_funct3 = 12;   //start bit
    localparam par_stb_imm12  = 20;  //start bit
    localparam par_stb_imm7   = 25;   //start bit
    localparam par_stb_imm20  = 12;  //start bit
    localparam par_stb_imm5   =  7;   //start bit



    

    wire[W_opcode-1:0]         opcode        = val_arh_instruct_idf[W_opcode-1:0];
    reg [par_instr_type_w-1:0] instruct_type;// use as wire
    reg [W_pops-1:0]           pip;
    reg [W_uops-1:0]           uops;

    always @(opcode) begin
        case (opcode)
           par_op       : instruct_type <= par_rtype; // i type
           par_op_imm, 
           par_jalr,
           par_lui, 
           par_load,
           par_misc_mem : instruct_type <= par_itype; // itype
           par_store    : instruct_type <= par_stype; // stype
           par_auipc    : instruct_type <= par_utype; // utype
           par_branch   : instruct_type <= par_btype; // btype
           par_jal      : instruct_type <= par_jtype; // jtype
            default     : instruct_type <= par_rtype; // rtype default
        endcase
    end

    wire[par_w_funct7-1:0] funct7 = val_arh_instruct_idf[par_w_funct7+ par_stb_funct7 -1:par_stb_funct7];
    wire[par_w_funct3-1:0] funct3 = val_arh_instruct_idf[par_w_funct3+ par_stb_funct3 -1:par_stb_funct3];
    wire[par_w_imm12 -1:0] imm12  = val_arh_instruct_idf[par_w_imm12 + par_stb_imm12  -1:par_stb_imm12 ];
    wire[par_w_imm7  -1:0] imm7   = val_arh_instruct_idf[par_w_imm7  + par_stb_imm7   -1:par_stb_imm7  ];
    wire[par_w_imm20 -1:0] imm20  = val_arh_instruct_idf[par_w_imm20 + par_stb_imm20  -1:par_stb_imm20 ];
    wire[par_w_imm5  -1:0] imm5   = val_arh_instruct_idf[par_w_imm5  + par_stb_imm5   -1:par_stb_imm5  ];

    always @(*) begin
        case(instruct_type)
            par_rtype : begin
                            case (funct7)
                                7'b0100000: uops <= {3'b000,funct3}; // expip
                                7'b0000001: uops <= {3'b000,funct3}; // divpip
                                default: uops <= {W_uops{1'b0}};
                            endcase
                        end
            par_itype : begin
                            
                            if ( opcode == par_load )begin   //st pip
                                uops <= {3'b000,funct3};
                            end else if ( opcode == par_misc_mem )begin // st pip
                                uops <= {3'b001,funct3};
                            end else if ( opcode == par_lui ) begin // st
                                uops <= {3'b010,funct3};
                            end else if ( opcode == par_jalr ) begin //ex
                                uops <= {3'b001,funct3};
                            end else begin // ex   op-imm
                                if (opcode == 7'b0010011 && funct7 == 7'b0100000)begin //srai
                                    uops <= {3'b011,funct3};
                                end else begin
                                    uops <= {3'b010,funct3}; // remain
                                end
                            end

                        end
            par_stype : begin
                                uops <= {3'b011,3'b000}; //st
                        end
            par_btype : begin
                                uops <= {3'b100,funct3}; //ex
                        end
            par_utype : begin
                                uops <= {3'b101,3'b000}; //ex
                        end
            par_jtype : begin
                                uops <= {3'b101,3'b001}; //ex
                        end
            default: uops <= 7'b0000000;
        endcase
    end

    always @(*) begin
        if (opcode == par_lui || opcode == par_load || opcode == par_store || opcode == par_misc_mem)begin
            pip <= par_lpip;
        end else if ( instruct_type == par_op && funct7 == 7'b0000001 && funct3 >= 3'b100 )begin
            pip <= par_dpip;
        end begin
            pip <= par_xpip;
        end
    end

endmodule