;buildInfoPackage: chisel3, version: 3.3.1, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit md : 
  module md : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip data : UInt<8>, out : UInt<8>}
    
    wire wireer : {flip data : UInt<8>, out : UInt<8>} @[objedTest.scala 32:23]
    io.out <= wireer.out @[objedTest.scala 34:12]
    wireer.data <= io.data @[objedTest.scala 34:12]
    node _T = add(io.data, UInt<1>("h01")) @[objedTest.scala 35:27]
    node _T_1 = tail(_T, 1) @[objedTest.scala 35:27]
    wireer.data <= _T_1 @[objedTest.scala 35:17]
    node _T_2 = add(io.data, UInt<2>("h02")) @[objedTest.scala 36:27]
    node _T_3 = tail(_T_2, 1) @[objedTest.scala 36:27]
    wireer.data <= _T_3 @[objedTest.scala 36:17]
    reg inputBd : {data : UInt<8>, out : UInt<8>}, clock @[objedTest.scala 39:22]
    reg inputSm : {data : UInt<8>, out : UInt<8>}, clock @[objedTest.scala 40:22]
    inputSm.data <= wireer.data @[objedTest.scala 41:18]
    inputSm.out <= inputSm.data @[objedTest.scala 42:18]
    inputBd.data <= wireer.data @[objedTest.scala 46:18]
    node _T_4 = eq(wireer.data, UInt<2>("h03")) @[objedTest.scala 47:22]
    when _T_4 : @[objedTest.scala 47:30]
      inputBd.data <= UInt<3>("h07") @[objedTest.scala 48:22]
      skip @[objedTest.scala 47:30]
    wireer.out <= inputBd.data @[objedTest.scala 51:16]
    inputBd.out <= inputBd.data @[objedTest.scala 58:17]
    
