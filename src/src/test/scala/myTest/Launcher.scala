// See LICENSE.txt for license details.
package problems

import chisel3._
//import chiseltest._
import chisel3.iotesters.{Driver, TesterOptionsManager}
import utils.TutorialRunner
import tanawinTest._
import core_bundle._
import core_module._

object Launcher {
  val tests = Map(
    "letMetry" -> { (manager: TesterOptionsManager) =>
      Driver.execute(() => new letMetry(), manager) {
        (c) => new letMetryTest(c)
      }
    },
    "INSTRUCTION_PAGE_WALKER_test"  -> { (manager: TesterOptionsManager) =>
      Driver.execute(() => new INSTRUCTION_PAGE_WALKER(), manager) {
        (c) => new INSTRUCTION_PAGE_WALKER_test(c)
      }
    }

  )

  def main(args: Array[String]): Unit = {
    TutorialRunner("problems", tests, args)
  }
}
