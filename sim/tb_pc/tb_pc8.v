`timescale 1ns / 1ps

module tb_pc8;
    reg CLK;
    reg RST;
    reg INC;
    wire [7:0] PC;

    pc8 dut (
        .CLK(CLK),
        .RST(RST),
        .INC(INC),
        .PC(PC)
    );

    // クロック生成（周期10ns）
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    // モニタリング
    initial begin
        $display("========================================");
        $display("  8ビット プログラムカウンタ");
        $display("========================================");
        $display("");
        $dumpfile("sim/waveforms/pc8_test.vcd");
        $dumpvars(0, tb_pc8);
    end

    // テストシナリオ
    initial begin
        // 初期化
        RST = 1;
        INC = 0;
        #12;
        
        // テスト1: 同期リセット機能
        $display("[テスト1] 同期リセット機能");
        $display("  - RST=1でCLK↑時にPC=00になる（同期リセット）");
        @(posedge CLK);
        @(negedge CLK);
        #1;
        if (PC == 8'h00)
            $display("  ✓ 成功: RST=1+CLK↑でPC=00 (実際: PC=%h)", PC);
        else
            $display("  ✗ 失敗: PC=00のはずが PC=%h", PC);
        $display("");
        
        // テスト2: INC=0で保持
        $display("[テスト2] カウント無効（INC=0）");
        $display("  - RST解除後、INC=0ではPC=00を保持");
        RST = 0;
        INC = 0;
        repeat(3) begin
            @(posedge CLK);
            @(negedge CLK);
            #1;
        end
        if (PC == 8'h00)
            $display("  ✓ 成功: INC=0でPC変化なし (実際: PC=%h)", PC);
        else
            $display("  ✗ 失敗: PC=00のはずが PC=%h", PC);
        $display("");
        
        // テスト3: INC=1でカウントアップ
        $display("[テスト3] カウントアップ（INC=1）");
        $display("  - INC=1でCLK↑ごとにPCが+1される");
        INC = 1;
        repeat(5) begin
            @(posedge CLK);
            @(negedge CLK);
            #1;
        end
        if (PC == 8'h05)
            $display("  ✓ 成功: 5回カウントでPC=05 (実際: PC=%h)", PC);
        else
            $display("  ✗ 失敗: PC=05のはずが PC=%h", PC);
        $display("");
        
        // テスト4: カウント中断
        $display("[テスト4] カウント中断");
        $display("  - INC=0にすると現在の値を保持");
        INC = 0;
        repeat(3) begin
            @(posedge CLK);
            @(negedge CLK);
            #1;
        end
        if (PC == 8'h05)
            $display("  ✓ 成功: INC=0でPC=05を保持 (実際: PC=%h)", PC);
        else
            $display("  ✗ 失敗: PC=05のはずが PC=%h", PC);
        $display("");
        
        // テスト5: カウント再開
        $display("[テスト5] カウント再開");
        $display("  - INC=1に戻すとカウント再開");
        INC = 1;
        repeat(3) begin
            @(posedge CLK);
            @(negedge CLK);
            #1;
        end
        if (PC == 8'h08)
            $display("  ✓ 成功: 3回カウントでPC=08 (実際: PC=%h)", PC);
        else
            $display("  ✗ 失敗: PC=08のはずが PC=%h", PC);
        $display("");
        
        // テスト6: カウント中に同期リセット
        $display("[テスト6] カウント中に同期リセット");
        $display("  - RST=1+CLK↑でPC=00に戻る");
        RST = 1;
        @(posedge CLK);
        @(negedge CLK);
        #1;
        if (PC == 8'h00)
            $display("  ✓ 成功: RST=1+CLK↑でPC=00 (実際: PC=%h)", PC);
        else
            $display("  ✗ 失敗: PC=00のはずが PC=%h", PC);
        $display("");
        
        // テスト7: リセット解除後のカウント
        $display("[テスト7] リセット解除後のカウント");
        $display("  - RST=0に戻して、INC=1でカウント継続");
        RST = 0;
        INC = 1;
        repeat(3) begin
            @(posedge CLK);
            @(negedge CLK);
            #1;
        end
        if (PC == 8'h03)
            $display("  ✓ 成功: リセット後3回カウントでPC=03 (実際: PC=%h)", PC);
        else
            $display("  ✗ 失敗: PC=03のはずが PC=%h", PC);
        $display("");

        $display("========================================");
        $display("  テスト完了");
        $display("========================================");
        #10;
        $finish;
    end
endmodule
