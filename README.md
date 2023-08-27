# Verilog-16-bit-calculator
A calculator based on 8 bit ALU, supporting operator precedence.
一个16位计算器，带有优先级运算
## Introduction

This is a 16-bit calculator and it is based on a 8-bit alu module. Support add(+), subtract(-), and(&), or, compare.
这是一个16位计算器，它基于一个8位的alu模块，支持加、减、与、或以及比较运算。
## Modules

### Mat.v
This module implements function of reading input from a 4 by 4 matrix keyboard based on states machine.
这个模块利用状态机实现了从矩阵键盘读取数据的功能。
### onload.v
This module stores inputs and outputs operators and data in order based on states machine.
这个模块存储输入数据并且按序输出。
### alu.v
It is a simple arithmetic logical unit.
### rom.v
It is not a rom,but is just a store module used to connect the 8 bit high result and 8 bit low result( as we only have one 8 bit alu, we need to calculate twice).
存储高八位和低八位的运算结果并拼接。
### mux.v, bcd and selDig
They are display modules to display results and inputs on a 7-segment-display.
驱动数码管显示结果
