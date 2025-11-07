`timescale 1ns / 1ps

module xor_gate (
  input wire a, // 入力A
  input wire b, // 入力B
  output wire y // 出力Y = A XOR B
);
  wire nor_out;
  wire and_out;

  nor_gate nor1 (a, b, nor_out);
  and_gate and1 (a, b, and_out);
  nor_gate nor2 (nor_out, and_out, y);
endmodule