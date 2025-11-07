`timescale 1ns / 1ps

module tb_nand;
  reg a, b;
  wire y;

  nand_gate uut (
    .a(a),
    .b(b),
    .y(y)
  );

  initial begin
    $dumpfile("sim/waveforms/nand_test.vcd");  // 波形出力ファイル
    $dumpvars(0, tb_nand);

    $display("A B | Y");
    $display("---------");

    // すべての入力パターンをテスト
    a = 0; b = 0; #10; $display("%b %b | %b", a, b, y);
    a = 0; b = 1; #10; $display("%b %b | %b", a, b, y);
    a = 1; b = 0; #10; $display("%b %b | %b", a, b, y);
    a = 1; b = 1; #10; $display("%b %b | %b", a, b, y);

    $finish;
  end
endmodule