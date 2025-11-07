`timescale 1ns / 1ps

module tb_const_high;
  wire y;

  const_high uut (
    .y(y)
  );

  initial begin
    $dumpfile("sim/waveforms/const_high_test.vcd");
    $dumpvars(0, tb_const_high);

    $display("=== const_high test ===");
    $display("出力Yは常に1であるべき");
    $display("");

    // 10nsごとに出力確認（変化しないはず）
    #0  $display("t=%0t ns | Y=%b", $time, y);
    #10 $display("t=%0t ns | Y=%b", $time, y);
    #20 $display("t=%0t ns | Y=%b", $time, y);
    #30 $display("t=%0t ns | Y=%b", $time, y);

    $finish;
  end
endmodule
