package tanawinTest


import chisel3.iotesters.PeekPokeTester

class letMetryTest(c: letMetry) extends PeekPokeTester(c){

    poke(c.io.x, 1)
    step(1)
    expect(c.io.z.y, 1)
    expect(c.io.cn , 1)

}