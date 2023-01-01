package tanawinTest


import chisel3._

class test extends Bundle{
    val data = Input(UInt(8.W))
    val out  = Output(UInt(8.W))
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
object tet{
val regType = Output(new test)
}

class md extends Module {
    val io = IO(new test)

    //val reg1 = new regg()
    val wireer  = Wire(new test)

    wireer <> io
    wireer.data := io.data+1.U
    wireer.data := io.data+2.U


    val inputBd = Reg(tet.regType)
    val inputSm = Reg(tet.regType)
    inputSm.data := wireer.data
    inputSm.out  := inputSm.data

    println(s"values like $tet.regType ")

    inputBd.data := wireer.data
    when(wireer.data === 3.U){
        inputBd.data := 7.U
    }

    wireer.out := inputBd.data
    // when (inputBd.out === 7.U){
    //     wireer.out := inputBd.out
    // }.elsewhen(inputBd.out === 4.U){
    //     wireer.out := inputSm.out
    // }
    //reg1.initializer(inputBd)
    inputBd.out := inputBd.data

}