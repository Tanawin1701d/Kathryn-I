package tanawinTest


import chisel3._

object cv{
    val convar = 1.U
}

class myBundle2 extends Bundle{
    val y = Output(UInt(1.W))
}

class myBundle extends Bundle{
    val x = Input(UInt(1.W))
    val f = Input(UInt(1.W))
    val y = Output(UInt(1.W))
    val z = new myBundle2
    val cn = Output(UInt(1.W))
}

class connectedBundle extends Bundle{
    val cc = Input (UInt(1.W))
    val co = Output(UInt(1.W))
    val re = new myBundle2()
}

class internalB extends Bundle{
    val x = Input((UInt(1.W)))
}

class int1 extends Module{
    val io = IO(new internalB)

}
class int2 extends Module{
    val io = IO(Flipped(new internalB))
    val gf = 1.U
    io.x := cv.convar
    //val gg = IO(new internalB)
    
}

class letMetry extends Module{

    val io = IO(new myBundle)
    io.z.y := io.x
    //if you can see if output not fully initialized 
    //program will error
    //but if input is not initialized, it's ok
    io.y   := io.x
    ///////////////////////////////////////////////////////
    //// test between io
    val f1 = Module(new letMetryConnect)
    val f1_io = Wire(Flipped(new connectedBundle))
    
    f1_io.cc := io.x
    io.cn    := f1_io.re.y

    f1_io <> f1.io

    // f1.io.cc <> f1_io.cc
    // f1.io.co <> f1_io.co
    // f1.io.re <> f1_io.re
    /////////////////////////////////////////////////////////
    //// test between module
    val f2 = Module(new int1)
    val f3 = Module(new int2)
    f2.io <> f3.io

}

class letMetryConnect extends Module{
    val io = IO(new connectedBundle)
    io.co := io.cc;
    io.re.y := io.cc;

}