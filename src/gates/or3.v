`timescale  1ns / 1ps

module or3_gate (
  input wire a, // 入力A
  input wire b, // 入力B
  input wire c, // 入力C
  output wire y // 出力Y = A OR B OR C
);
wire t;

or_gate or1 (a, b, t);
or_gate or2 (t, c, y);
endmodule