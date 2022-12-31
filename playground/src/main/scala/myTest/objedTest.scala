package tanawinTest


import chisel3._

class test extends Bundle{
    val data = UInt(8.W)
}


// class regg{
//     val aws = Reg(UInt(8.W))

//     def initializer(i: test) = {
//         aws := i
//     }

//     def getREGG() = {
//         aws
//     }

// }


class md extends Module {
    val io = IO(new Bundle{
        val reu = Input(new test)
        val out = Output(UInt(8.W))
    })

    //val reg1 = new regg()
    val inputBd = Wire(new test())
    inputBd := io.reu
    //reg1.initializer(inputBd)
    io.out <> inputBd.data

}