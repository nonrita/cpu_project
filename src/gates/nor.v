`timescale 1ns / 1ps

module nor_gate (
  input wire a, // 入力A
  input wire b, // 入力B
  output wire y // 出力Y = A NOR B
);
  wire or_out;

  or_gate or_ab (a, b, or_out);
  not_gate not1 (or_out, y);
endmodule