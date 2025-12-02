`timescale 1ns / 1ps

module tb_regfile8x8;
    reg CLK, RST, WE;
    reg [2:0] RA1, RA2, WA;
    reg [7:0] WD;
    wire [7:0] RD1, RD2;
    
    regfile8x8 uut (
        .CLK(CLK), .RST(RST), .WE(WE),
        .RA1(RA1), .RA2(RA2), .WA(WA),
        .WD(WD), .RD1(RD1), .RD2(RD2)
    );
    
    initial begin
        $dumpfile("sim/waveforms/regfile8x8_test.vcd");
        $dumpvars(0, tb_regfile8x8);
        
        $display("========================================");
        $display("  8x8 レジスタファイル テスト");
        $display("========================================");
        
        CLK = 0; RST = 0; WE = 0;
        RA1 = 0; RA2 = 0; WA = 0; WD = 0;
        
        // リセット
        $display("\n[リセット]");
        RST = 1;
        #1 @(posedge CLK); #1 @(negedge CLK); #1;
        RST = 0;
        #1 @(posedge CLK); #1 @(negedge CLK); #1;
        
        // R0は常に0を確認
        $display("\n[R0 定数ゼロの確認]");
        RA1 = 0; RA2 = 0;
        #1;
        if (RD1 === 8'h00 && RD2 === 8'h00)
            $display("  \u2713 R0 = 0x00 (両ポートとも) ");
        else
            $display("  \u2717 R0 は 0x00 のはず。RD1=0x%02h RD2=0x%02h", RD1, RD2);
        
        // R0への書き込みは無視される
        $display("\n[R0 書き込み無視の確認]");
        WA = 0; WD = 8'hFF; WE = 1;
        #1 @(posedge CLK); #1 @(negedge CLK); #1;
        WE = 0;
        RA1 = 0;
        #1;
        if (RD1 === 8'h00)
            $display("  \u2713 書き込み試行後も R0 は 0x00 のまま");
        else
            $display("  \u2717 R0 は 0x00 のままのはず。得た値 0x%02h", RD1);
        
        // R1〜R7への書き込みとリードバック
        $display("\n[書き込みと読み戻しの確認]");
        begin : write_test
            integer r;
            for (r = 1; r < 8; r = r + 1) begin
                WA = r; WD = 8'h10 + r; WE = 1;
                #1 @(posedge CLK); #1 @(negedge CLK); #1;
                WE = 0;
                RA1 = r;
                #1;
                if (RD1 === (8'h10 + r))
                    $display("  \u2713 R%0d = 0x%02h", r, RD1);
                else
                    $display("  \u2717 R%0d は 0x%02h のはず。得た値 0x%02h", r, 8'h10 + r, RD1);
            end
        end
        
        // 同時読み出し
        $display("\n[同時読み出しの確認]");
        RA1 = 1; RA2 = 2; // R1=0x11, R2=0x12
        #1;
        if (RD1 === 8'h11 && RD2 === 8'h12)
            $display("  \u2713 RD1=0x%02h (R1), RD2=0x%02h (R2)", RD1, RD2);
        else
            $display("  \u2717 期待値 RD1=0x11 RD2=0x12。得た値 RD1=0x%02h RD2=0x%02h", RD1, RD2);
        
        RA1 = 7; RA2 = 0; // R7=0x17, R0=0x00
        #1;
        if (RD1 === 8'h17 && RD2 === 8'h00)
            $display("  \u2713 RD1=0x%02h (R7), RD2=0x%02h (R0)", RD1, RD2);
        else
            $display("  \u2717 期待値 RD1=0x17 RD2=0x00。得た値 RD1=0x%02h RD2=0x%02h", RD1, RD2);
        
        // WE=0で書き込まれないことを確認
        $display("\n[WE=0 の時は書き込まれない]");
        RA1 = 3; // R3=0x13
        #1;
        $display("  事前確認: R3=0x%02h", RD1);
        WA = 3; WD = 8'hAA; WE = 0;
        #1 @(posedge CLK); #1 @(negedge CLK); #1;
        RA1 = 3;
        #1;
        if (RD1 === 8'h13)
            $display("  \u2713 WE=0 では R3 は変化せず (0x%02h)", RD1);
        else
            $display("  \u2717 R3 は 0x13 のはず。得た値 0x%02h", RD1);
        
        // 上書きテスト
        $display("\n[上書きの確認]");
        WA = 5; WD = 8'hBB; WE = 1; // R5を上書き
        #1 @(posedge CLK); #1 @(negedge CLK); #1;
        WE = 0;
        RA1 = 5;
        #1;
        if (RD1 === 8'hBB)
            $display("  \u2713 R5 は 0x%02h に上書きされた", RD1);
        else
            $display("  \u2717 R5 は 0xBB のはず。得た値 0x%02h", RD1);
        
        // リセット後全レジスタが0になることを確認
        $display("\n[リセット後に全レジスタが0]");
        RST = 1;
        #1 @(posedge CLK); #1 @(negedge CLK); #1;
        RST = 0;
        #1 @(posedge CLK); #1 @(negedge CLK); #1;
        
        begin : reset_check
            integer r;
            reg all_zero;
            all_zero = 1;
            for (r = 0; r < 8; r = r + 1) begin
                RA1 = r;
                #1;
                if (RD1 !== 8'h00) begin
                    $display("  \u2717 リセット後 R%0d は 0x00 のはず。得た値 0x%02h", r, RD1);
                    all_zero = 0;
                end
            end
            if (all_zero)
                $display("  \u2713 全レジスタが 0x00 にリセットされた");
        end
        
        $display("\n========================================");
        $display("  テスト完了");
        $display("========================================");
        #5 $finish;
    end
    
    always #5 CLK = ~CLK;
endmodule
