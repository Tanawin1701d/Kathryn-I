;buildInfoPackage: chisel3, version: 3.3.1, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit INSTRUCTION_PAGE_WALKER : 
  module INSTRUCTION_PAGE_WALKER : 
    input clock : Clock
    input reset : UInt<1>
    output io : {st : {s_input : UInt<1>, s_output : UInt<1>}, cmd : {flip c_pause : UInt<1>, flip c_reset : UInt<1>, flip c_enable : UInt<1>}, inf_req_pc : {flip i_pc : UInt<32>, flip i_pvl : UInt<2>}, flip inf_iss_pc : {flip i_pc : UInt<32>, flip i_pvl : UInt<2>}, yy : UInt<1>}
    
    reg y : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[instPW.scala 29:20]
    io.yy <= y @[instPW.scala 30:12]
    io.st.s_input <= UInt<1>("h01") @[instPW.scala 31:19]
    io.st.s_output <= UInt<1>("h01") @[instPW.scala 32:19]
    io.inf_iss_pc.i_pc <= UInt<1>("h00") @[instPW.scala 33:25]
    io.inf_iss_pc.i_pvl <= UInt<1>("h00") @[instPW.scala 34:25]
    node _T = eq(io.cmd.c_pause, io.cmd.c_reset) @[instPW.scala 36:26]
    when _T : @[instPW.scala 36:45]
      io.st.s_output <= UInt<1>("h00") @[instPW.scala 37:23]
      y <= UInt<1>("h00") @[instPW.scala 38:11]
      skip @[instPW.scala 36:45]
    
