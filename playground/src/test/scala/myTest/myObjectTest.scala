package tanawinTest

import chisel3._


import chisel3.iotesters.PeekPokeTester

class letObjectTryTest(c: md) extends PeekPokeTester(c){

    poke(c.io.reu.data, 1)
    step(1)
    expect(c.io.out, 1)

}