`timescale 1ns / 1ps

module tb_or3;
  reg a, b, c;
  wire y;

  or3_gate uut (
    .a(a),
    .b(b),
    .c(c),
    .y(y)
  );

  initial begin
    $dumpfile("sim/waveforms/or3_test.vcd");
    $dumpvars(0, tb_or3);

    $display("A B C | Y");
    $display("---------");

    a=0; b=0; c=0; #10; $display("%b %b %b | %b", a,b,c,y);
    a=0; b=0; c=1; #10; $display("%b %b %b | %b", a,b,c,y);
    a=0; b=1; c=0; #10; $display("%b %b %b | %b", a,b,c,y);
    a=0; b=1; c=1; #10; $display("%b %b %b | %b", a,b,c,y);
    a=1; b=0; c=0; #10; $display("%b %b %b | %b", a,b,c,y);
    a=1; b=0; c=1; #10; $display("%b %b %b | %b", a,b,c,y);
    a=1; b=1; c=0; #10; $display("%b %b %b | %b", a,b,c,y);
    a=1; b=1; c=1; #10; $display("%b %b %b | %b", a,b,c,y);

    $finish;
  end
endmodule