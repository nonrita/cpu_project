`timescale 1ns / 1ps

module tb_reg8;

    reg [7:0] D;
    reg CLK;
    reg WE;
    reg RST;
    wire [7:0] Q;

    reg8 dut (
        .D(D),
        .CLK(CLK),
        .WE(WE),
        .RST(RST),
        .Q(Q)
    );

    // クロック生成（周期10ns）
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK; 
    end

    // モニタリング
    initial begin
        $display("========================================");
        $display("  8ビットレジスタ（リセット機能付き）");
        $display("========================================");
        $display("");
        $dumpfile("sim/waveforms/reg8_test.vcd");
        $dumpvars(0, tb_reg8);
    end

    // テストシナリオ
    initial begin
        // 初期化
        D = 8'h00; 
        WE = 0;
        RST = 0;
        #12;

        // テスト1: 同期リセット機能
        $display("[テスト1] 同期リセット機能");
        $display("  - RST=1でCLK↑時にQ=00になる（同期リセット）");
        RST = 1;
        D = 8'hFF;
        @(posedge CLK);
        @(negedge CLK);
        #1;
        if (Q == 8'h00)
            $display("  ✓ 成功: RST=1+CLK↑でQ=00 (実際: Q=%h)", Q);
        else
            $display("  ✗ 失敗: Q=00のはずが Q=%h", Q);
        $display("");

        // テスト2: リセット解除
        $display("[テスト2] リセット解除");
        $display("  - RST=0に戻してもQ=00を保持");
        RST = 0;
        @(negedge CLK);
        #1;
        if (Q == 8'h00)
            $display("  ✓ 成功: RST解除後もQ=00 (実際: Q=%h)", Q);
        else
            $display("  ✗ 失敗: Q=00のはずが Q=%h", Q);
        $display("");

        // テスト3: 書き込み無効（WE=0）
        $display("[テスト3] 書き込み無効（WE=0）");
        $display("  - WE=0の時、D=55を設定してもQは変化しない");
        D = 8'h55; 
        WE = 0;
        @(posedge CLK);
        @(negedge CLK);
        #1;
        if (Q == 8'h00)
            $display("  ✓ 成功: WE=0でQ変化なし (実際: Q=%h)", Q);
        else
            $display("  ✗ 失敗: Q=00のはずが Q=%h", Q);
        $display("");

        // テスト4: 書き込み有効（WE=1）でデータ書き込み
        $display("[テスト4] 書き込み有効（WE=1）");
        $display("  - WE=1でCLK↑時にD=CCを書き込み");
        D = 8'hCC;
        WE = 1;
        @(posedge CLK);
        @(negedge CLK);
        #1;
        if (Q == 8'hCC)
            $display("  ✓ 成功: WE=1でD=CCが書き込まれた (実際: Q=%h)", Q);
        else
            $display("  ✗ 失敗: Q=CCのはずが Q=%h", Q);
        $display("");

        // テスト5: 連続書き込み
        $display("[テスト5] 連続書き込み");
        $display("  - WE=1のままD=11を書き込み");
        D = 8'h11;
        @(posedge CLK);
        @(negedge CLK);
        #1;
        if (Q == 8'h11)
            $display("  ✓ 成功: D=11が書き込まれた (実際: Q=%h)", Q);
        else
            $display("  ✗ 失敗: Q=11のはずが Q=%h", Q);
        $display("");

        // テスト6: 書き込み無効に戻す
        $display("[テスト6] 書き込み無効に戻す");
        $display("  - WE=0にするとD=EEに変更してもQは保持");
        WE = 0;
        D = 8'hEE;
        @(posedge CLK);
        @(negedge CLK);
        #1;
        if (Q == 8'h11)
            $display("  ✓ 成功: WE=0でQ=11を保持 (実際: Q=%h)", Q);
        else
            $display("  ✗ 失敗: Q=11のはずが Q=%h", Q);
        $display("");

        // テスト7: データ保持中に同期リセット
        $display("[テスト7] データ保持中に同期リセット");
        $display("  - Q=11の状態でRST=1+CLK↑でQ=00");
        RST = 1;
        @(posedge CLK);
        @(negedge CLK);
        #1;
        if (Q == 8'h00)
            $display("  ✓ 成功: RST=1+CLK↑でQ=00 (実際: Q=%h)", Q);
        else
            $display("  ✗ 失敗: Q=00のはずが Q=%h", Q);
        $display("");

        $display("========================================");
        $display("  テスト完了");
        $display("========================================");
        #10;
        $finish;
    end
endmodule