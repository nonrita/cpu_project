`timescale 1ns / 1ps

module nand_gate (
  input wire a, // 入力A
  input wire b, // 入力B
  output wire y // 出力Y = NOT (A AND B)
);
  assign y = ~(a & b);
endmodule