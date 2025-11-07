`timescale 1ns / 1ps

module or_gate (
  input wire a, // 入力A
  input wire b, // 入力B
  output wire y // 出力Y = A OR B
);
  wire not_a_out;
  wire not_b_out;

  not_gate not_a (a, not_a_out);
  not_gate not_b (b, not_b_out);

  nand_gate nand1 (not_a_out, not_b_out, y);
endmodule