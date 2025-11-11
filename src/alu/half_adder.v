`timescale 1ns / 1ps

module half_adder (
  input wire a,      // 入力 A
  input wire b,      // 入力 B
  output wire sum,   // 出力 SUM = A XOR B
  output wire carry  // 出力 CARRY = A AND B
);
  xor_gate xor1 (a, b, sum);
  and_gate and1 (a, b, carry);
endmodule