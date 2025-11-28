`timescale 1ns / 1ps

module tb_d_ff;
    reg D;
    reg CLK;
    reg RST;
    wire Q;
    wire Q_bar;

    d_ff dut (
        .D(D),
        .CLK(CLK),
        .RST(RST),
        .Q(Q),
        .Q_bar(Q_bar)
    );

    // クロック生成（周期10ns）
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK; 
    end

    // モニタリング
    initial begin
        $display("========================================");
        $display("  Dフリップフロップ（リセット機能付き）");
        $display("========================================");
        $display("");
        $dumpfile("sim/waveforms/d_ff_test.vcd");
        $dumpvars(0, tb_d_ff);
    end

    // テストシナリオ
    initial begin
        // 初期化
        D = 0;
        RST = 0;
        #12;

        // テスト1: 同期リセット機能
        $display("[テスト1] 同期リセット機能");
        $display("  - RST=1でCLK↑時にQ=0になる（同期リセット）");
        RST = 1;
        D = 1;
        @(posedge CLK);
        @(negedge CLK);
        #1;
        if (Q == 0)
            $display("  ✓ 成功: RST=1+CLK↑でQ=0 (実際: Q=%b)", Q);
        else
            $display("  ✗ 失敗: Q=0のはずが Q=%b", Q);
        $display("");

        // テスト2: リセット解除後の動作
        $display("[テスト2] リセット解除してD=1を書き込み");
        $display("  - RST=0に戻して、CLK↑でD=1を取り込む");
        RST = 0;
        D = 1;
        @(posedge CLK);
        @(negedge CLK);  // マスタースレーブFFなのでCLK↓で完全反映
        #1;
        if (Q == 1)
            $display("  ✓ 成功: CLK↑でD=1が反映 (実際: Q=%b)", Q);
        else
            $display("  ✗ 失敗: Q=1のはずが Q=%b", Q);
        $display("");

        // テスト3: データ保持
        $display("[テスト3] データ保持");
        $display("  - D=0に変更してもCLK↑まではQ=1を保持");
        D = 0;
        #3;
        if (Q == 1)
            $display("  ✓ 成功: D変更後もQ=1を保持 (実際: Q=%b)", Q);
        else
            $display("  ✗ 失敗: Q=1を保持すべきだが Q=%b", Q);
        $display("");

        // テスト4: 次のクロックでD=0を取り込み
        $display("[テスト4] 次のクロックでD=0を取り込み");
        @(posedge CLK);
        @(negedge CLK);
        #1;
        if (Q == 0)
            $display("  ✓ 成功: CLK↑でD=0が反映 (実際: Q=%b)", Q);
        else
            $display("  ✗ 失敗: Q=0のはずが Q=%b", Q);
        $display("");

        // テスト5: 再度D=1を書き込み
        $display("[テスト5] 再度D=1を書き込み");
        D = 1;
        @(posedge CLK);
        @(negedge CLK);
        #1;
        if (Q == 1)
            $display("  ✓ 成功: CLK↑でD=1が反映 (実際: Q=%b)", Q);
        else
            $display("  ✗ 失敗: Q=1のはずが Q=%b", Q);
        $display("");

        // テスト6: 保持中に同期リセット
        $display("[テスト6] Q=1の状態で同期リセット");
        $display("  - RST=1+CLK↑でQ=0になる（同期リセット）");
        RST = 1;
        @(posedge CLK);
        @(negedge CLK);
        #1;
        if (Q == 0)
            $display("  ✓ 成功: RST=1+CLK↑でQ=0 (実際: Q=%b)", Q);
        else
            $display("  ✗ 失敗: Q=0のはずが Q=%b", Q);
        $display("");

        $display("========================================");
        $display("  テスト完了");
        $display("========================================");
        #10;
        $finish;
    end
endmodule