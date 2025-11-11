`timescale 1ns / 1ps

module tb_adder8;
  reg [7:0] a, b;
  reg cin;
  wire [7:0] sum;
  wire cout;

  adder8 uut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
  );

  initial begin
    $dumpfile("sim/waveforms/adder8_test.vcd");
    $dumpvars(0, tb_adder8);

    $display("A       B       Cin | Sum     Cout");
    $display("---------------------------------");

    a=8'd15; b=8'd20; cin=0; #10; $display("%d %d   %b  | %d    %b", a,b,cin,sum,cout);
    a=8'd100; b=8'd55; cin=1; #10; $display("%d %d   %b  | %d    %b", a,b,cin,sum,cout);
    a=8'd255; b=8'd1; cin=0; #10; $display("%d %d   %b  | %d    %b", a,b,cin,sum,cout);

    $finish;
  end
endmodule
