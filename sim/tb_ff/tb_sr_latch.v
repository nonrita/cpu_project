`timescale 1ns / 1ps

module tb_sr_latch;
    reg S_bar;
    reg R_bar;
    wire Q;
    wire Q_bar;

    sr_latch dut (
        .S_bar(S_bar),
        .R_bar(R_bar),
        .Q(Q),
        .Q_bar(Q_bar)
    );

    initial begin
        $display("--- SRラッチ (NANDベース) テスト開始 ---");
        $dumpfile("sim/waveforms/sr_latch_test.vcd");
        $dumpvars(0, tb_sr_latch);

        S_bar = 1;
        R_bar = 0;
        #10;
        $display("時間 %t: リセット (S_bar=1, R_bar=0) Q=%b, Q_bar=%b", $time, Q, Q_bar);
        
        S_bar = 1;
        R_bar = 1;
        #10;
        $display("時間 %t: 保持 (S_bar=1, R_bar=1) Q=%b, Q_bar=%b", $time, Q, Q_bar);
        
        S_bar = 0;
        R_bar = 1;
        #10;
        $display("時間 %t: セット (S_bar=0, R_bar=1) Q=%b, Q_bar=%b", $time, Q, Q_bar);
        
        S_bar = 1;
        R_bar = 1;
        #10;
        $display("時間 %t: 保持 (S_bar=1, R_bar=1) Q=%b, Q_bar=%b", $time, Q, Q_bar);

        S_bar = 0;
        R_bar = 0;
        #10;
        $display("時間 %t: 不定入力 (S_bar=0, R_bar=0) Q=%b, Q_bar=%b", $time, Q, Q_bar);

        S_bar = 1;
        R_bar = 1;
        #10;
        $display("時間 %t: 復帰保持 (S_bar=1, R_bar=1) Q=%b, Q_bar=%b", $time, Q, Q_bar);

        $display("--- SRラッチ テスト終了 ---");
        $finish;
    end
endmodule