`timescale 1ns / 1ps

module and_gate (
  input wire a, // 入力A
  input wire b, // 入力B
  output wire y // 出力Y = A AND B
);
  wire nand_out;

  nand_gate nand1 (a, b, nand_out);
  not_gate not1 (nand_out, y);
endmodule