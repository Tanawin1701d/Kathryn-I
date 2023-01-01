package intro
import tanawinTest._

import chisel3.stage.ChiselStage




object VerilogMain extends App {

  (new ChiselStage).emitVerilog(new md)

}
