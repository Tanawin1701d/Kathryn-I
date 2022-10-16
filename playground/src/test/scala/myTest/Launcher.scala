// See LICENSE.txt for license details.
package problems

import chisel3._
//import chiseltest._
import chisel3.iotesters.{Driver, TesterOptionsManager}
import utils.TutorialRunner
import tanawinTest._

object Launcher {
  val tests = Map(
    "letMetry" -> { (manager: TesterOptionsManager) =>
      Driver.execute(() => new letMetry(), manager) {
        (c) => new letMetryTest(c)
      }
    }

  )

  def main(args: Array[String]): Unit = {
    TutorialRunner("problems", tests, args)
  }
}
