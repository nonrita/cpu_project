`timescale 1ns / 1ps

module tb_d_ff;
    reg D;
    reg CLK;
    wire Q;
    wire Q_bar;

    d_ff dut (
        .D(D),
        .CLK(CLK),
        .Q(Q),
        .Q_bar(Q_bar)
    );

    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK; 
    end

    initial begin
        $display("時間(ns) | CLK | D | Q | 動作内容");
        $display("---------|-----|---|---|-----------------------------------------");
        $monitor("%0t | %b | %b | %b |", $time, CLK, D, Q);
    end

    initial begin
        $display("--- Dフリップフロップ テスト開始 ---");
        $display("CLK周期: 10ns | 動作エッジ: 立ち上がり (posedge)");
        $display("-----------------------------------------------------");
        $dumpfile("sim/waveforms/d_ff_test.vcd");
        $dumpvars(0, tb_d_ff);

        D = 0;
        @(negedge CLK);
        $display("時間 %t: [初期状態] D=%b, Q=%b (不定)", $time, D, Q);
        
        $display("時間 %t: [準備] D=1を設定 (Qはまだ0を保持)", $time);
        D = 1;
        #5;

        @(posedge CLK);
        $display("時間 %t: [テスト1: キャプチャ] CLK立ち上がり。D=%bがQ=%bに反映 (期待値: 1)", $time, D, Q);
        
        $display("時間 %t: [テスト2: 保持] CLK High中にD=0に変更. Q=%b (期待値: 1を保持)", $time, Q);
        D = 0;
        #5;
        
        @(negedge CLK);
        $display("時間 %t: [中間伝達] CLK立ち下がり。Q=%bに更新 (期待値: 0)", $time, Q);

        #5;
        @(posedge CLK);
        $display("時間 %t: [テスト3: 保持] CLK立ち上がり。D=%b. Q=%b (期待値: 0を保持)", $time, D, Q);

        $display("時間 %t: [テスト4: 準備] CLK High中にD=1に変更.", $time);
        D = 1;
        #5;
        
        @(negedge CLK);
        #5;
        
        @(posedge CLK);
        $display("時間 %t: [テスト4: キャプチャ] CLK立ち上がり。D=%bがQ=%bに反映 (期待値: 1)", $time, D, Q);

        $display("-----------------------------------------------------");
        $display("--- Dフリップフロップ テスト終了 ---");
        $finish;
    end
endmodule