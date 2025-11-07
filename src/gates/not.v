`timescale 1ns / 1ps

module not_gate (
  input wire a, // 入力A
  output wire y // 出力y = NOT A
);
  nand_gate nand1 (a, a, y);
endmodule