`timescale 1ns / 1ps

module tb_mux2;
    reg a, b;
    reg sel;
    wire y;

    mux2 uut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    initial begin
        $dumpfile("sim/waveforms/mux2_test.vcd");
        $dumpvars(0, tb_mux2);

        $display("sel a b | y");
        $display("-----------");

        a = 0; b = 0; sel = 0; #10 $display("%b   %b %b | %b", sel, a, b, y);
        a = 0; b = 1; sel = 0; #10 $display("%b   %b %b | %b", sel, a, b, y);
        a = 1; b = 0; sel = 0; #10 $display("%b   %b %b | %b", sel, a, b, y);
        a = 1; b = 1; sel = 0; #10 $display("%b   %b %b | %b", sel, a, b, y);

        a = 0; b = 0; sel = 1; #10 $display("%b   %b %b | %b", sel, a, b, y);
        a = 0; b = 1; sel = 1; #10 $display("%b   %b %b | %b", sel, a, b, y);
        a = 1; b = 0; sel = 1; #10 $display("%b   %b %b | %b", sel, a, b, y);
        a = 1; b = 1; sel = 1; #10 $display("%b   %b %b | %b", sel, a, b, y);

        $finish;
    end
endmodule
