`timescale 1ns / 1ps

module tb_xand;
  reg a, b;
  wire y;

  xnor_gate uut (
    .a(a),
    .b(b),
    .y(y)
  );

  initial begin
    $dumpfile("sim/waveforms/xand_test.vcd");
    $dumpvars(0, tb_xand);

    $display("A B | Y (XAND/XNOR)");
    $display("-----------------");

    a=0; b=0; #10; $display("%b %b | %b", a,b,y);
    a=0; b=1; #10; $display("%b %b | %b", a,b,y);
    a=1; b=0; #10; $display("%b %b | %b", a,b,y);
    a=1; b=1; #10; $display("%b %b | %b", a,b,y);

    $finish;
  end
endmodule