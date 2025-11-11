`timescale 1ns / 1ps

module tb_full_adder;
  reg a, b, cin;
  wire sum, cout;

  full_adder uut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
  );

  initial begin
    $dumpfile("sim/waveforms/full_adder_test.vcd");
    $dumpvars(0, tb_full_adder);

    $display("A B Cin | SUM Cout");
    $display("------------------");

    a=0; b=0; cin=0; #10; $display("%b %b  %b  |  %b   %b", a,b,cin,sum,cout);
    a=0; b=0; cin=1; #10; $display("%b %b  %b  |  %b   %b", a,b,cin,sum,cout);
    a=0; b=1; cin=0; #10; $display("%b %b  %b  |  %b   %b", a,b,cin,sum,cout);
    a=0; b=1; cin=1; #10; $display("%b %b  %b  |  %b   %b", a,b,cin,sum,cout);
    a=1; b=0; cin=0; #10; $display("%b %b  %b  |  %b   %b", a,b,cin,sum,cout);
    a=1; b=0; cin=1; #10; $display("%b %b  %b  |  %b   %b", a,b,cin,sum,cout);
    a=1; b=1; cin=0; #10; $display("%b %b  %b  |  %b   %b", a,b,cin,sum,cout);
    a=1; b=1; cin=1; #10; $display("%b %b  %b  |  %b   %b", a,b,cin,sum,cout);

    $finish;
  end
endmodule
