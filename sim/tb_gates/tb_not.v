`timescale 1ns / 1ps

module tb_not;
    reg a;
    wire y;

    not_gate uut (
        .a(a),
        .y(y)
    );

    initial begin
        $dumpfile("sim/waveforms/not_test.vcd");
        $dumpvars(0, tb_not);

        $display("A | Y");
        $display("----");

        a = 0; #10; $display("%b | %b", a, y);
        a = 1; #10; $display("%b | %b", a, y);

        $finish;
    end
endmodule
