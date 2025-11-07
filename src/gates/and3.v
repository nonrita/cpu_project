`timescale 1ns / 1ps

module and3_gate (
  input wire a, // 入力A
  input wire b, // 入力B
  input wire c, // 入力C
  output wire y // 出力Y = A AND B AND C
);
wire t;

and_gate and1 (a, b, t);
and_gate and2 (t, c, y);
endmodule