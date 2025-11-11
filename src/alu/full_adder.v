`timescale 1ns / 1ps

module full_adder (
  input wire a,      // 入力 A
  input wire b,      // 入力 B
  input wire cin,    // 入力 Cin
  output wire sum,   // 出力 Sum
  output wire cout   // 出力 Cout
);
  wire sum1, carry1, carry2;

  half_adder ha1 (a, b, sum1, carry1);
  half_adder ha2 (sum1, cin, sum, carry2);
  or_gate or1 (carry1, carry2, cout);
endmodule