module INSTRUCTION_PAGE_WALKER(
  input         clock,
  input         reset,
  output        io_st_s_input,
  output        io_st_s_output,
  input         io_cmd_c_pause,
  input         io_cmd_c_reset,
  input         io_cmd_c_enable,
  input  [31:0] io_inf_req_pc_i_pc,
  input  [1:0]  io_inf_req_pc_i_pvl,
  output [31:0] io_inf_iss_pc_i_pc,
  output [1:0]  io_inf_iss_pc_i_pvl,
  output        io_yy
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg  y; // @[instPW.scala 29:20]
  wire  _T = io_cmd_c_pause == io_cmd_c_reset; // @[instPW.scala 36:26]
  wire  _GEN_1 = _T ? 1'h0 : y; // @[instPW.scala 36:45]
  assign io_st_s_input = 1'h1; // @[instPW.scala 31:19]
  assign io_st_s_output = _T ? 1'h0 : 1'h1; // @[instPW.scala 32:19 instPW.scala 37:23]
  assign io_inf_iss_pc_i_pc = 32'h0; // @[instPW.scala 33:25]
  assign io_inf_iss_pc_i_pvl = 2'h0; // @[instPW.scala 34:25]
  assign io_yy = y; // @[instPW.scala 30:12]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  y = _RAND_0[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    y <= reset | _GEN_1;
  end
endmodule
