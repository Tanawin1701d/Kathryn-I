package intro
import core_module._

import chisel3.stage.ChiselStage




object VerilogMain extends App {

  (new ChiselStage).emitVerilog(new INSTRUCTION_PAGE_WALKER)

}
