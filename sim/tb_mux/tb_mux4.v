`timescale 1ns / 1ps

module tb_mux4;
    reg d0, d1, d2, d3;
    reg [1:0] sel;
    wire y;

    // テスト対象モジュール
    mux4 uut(d0, d1, d2, d3, sel, y);

    initial begin
        // 波形出力
        $dumpfile("sim/waveforms/mux4_test.vcd");
        $dumpvars(0, tb_mux4);

        $display("sel | d0 d1 d2 d3 | y");
        $display("----------------------");

        // 代表的なパターンのみ
        d0 = 0; d1 = 1; d2 = 0; d3 = 1;

        sel = 0; #5; $display("%b   | %b %b %b %b | %b", sel,d0,d1,d2,d3,y);
        sel = 1; #5; $display("%b   | %b %b %b %b | %b", sel,d0,d1,d2,d3,y);
        sel = 2; #5; $display("%b   | %b %b %b %b | %b", sel,d0,d1,d2,d3,y);
        sel = 3; #5; $display("%b   | %b %b %b %b | %b", sel,d0,d1,d2,d3,y);

        // 別の入力パターンでもテスト
        d0 = 1; d1 = 0; d2 = 1; d3 = 0;
        sel = 0; #5; $display("%b   | %b %b %b %b | %b", sel,d0,d1,d2,d3,y);
        sel = 1; #5; $display("%b   | %b %b %b %b | %b", sel,d0,d1,d2,d3,y);
        sel = 2; #5; $display("%b   | %b %b %b %b | %b", sel,d0,d1,d2,d3,y);
        sel = 3; #5; $display("%b   | %b %b %b %b | %b", sel,d0,d1,d2,d3,y);

        $finish;
    end
endmodule
