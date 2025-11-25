`timescale 1ns / 1ps

module tb_d_latch;
    reg D;
    reg E;
    wire Q;
    wire Q_bar;

    d_latch dut (
        .D(D),
        .E(E),
        .Q(Q),
        .Q_bar(Q_bar)
    );

    initial begin
        $display("--- Dラッチ テスト開始 ---");
        $dumpfile("sim/waveforms/d_latch_test.vcd");
        $dumpvars(0, tb_d_latch);

        D = 0;
        E = 0;
        #10;
        $display("時間 %t: 初期化完了 (D=0, E=0) Q=%b, Q_bar=%b", $time, Q, Q_bar);

        E = 1; 
        #10;
        $display("時間 %t: 透過モード開始 (D=0, E=1) Q=%b", $time, Q); 

        D = 1;
        #10;
        $display("時間 %t: D=1に変更 (E=1) Q=%b", $time, Q); 
        
        E = 0;
        D = 1;
        #10;
        $display("時間 %t: 保持モード開始 (E=0) Q=%b", $time, Q);
        
        D = 0;
        #10;
        $display("時間 %t: D=0に変更 (E=0) Q=%b", $time, Q);

        E = 1; 
        #10;
        $display("時間 %t: 透過モードに戻す (E=1) Q=%b", $time, Q);

        E = 0;
        #10;
        $display("時間 %t: 保持モード (E=0) Q=%b", $time, Q);

        $display("--- Dラッチ テスト終了 ---");
        $finish;
    end
endmodule