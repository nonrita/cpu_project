`timescale 1ns / 1ps

module tb_const_low;
  wire y;

  const_low uut (
    .y(y)
  );

  initial begin
    $dumpfile("sim/waveforms/const_low_test.vcd");
    $dumpvars(0, tb_const_low);

    $display("=== const_low test ===");
    $display("出力Yは常に0であるべき");
    $display("");

    #0  $display("t=%0t ns | Y=%b", $time, y);
    #10 $display("t=%0t ns | Y=%b", $time, y);
    #20 $display("t=%0t ns | Y=%b", $time, y);
    #30 $display("t=%0t ns | Y=%b", $time, y);

    $finish;
  end
endmodule