`timescale 1ns / 1ps

// シングルサイクルCPUの統合テスト
// 目的: 命令フェッチ→デコード→レジスタ読み→ALU実行→書き戻し
//       が1サイクルで完結し、複数サイクルでレジスタが期待通り変化するか確認
module tb_cpu_simple;
    reg CLK, RST;

    cpu_simple cpu(.CLK(CLK), .RST(RST));

    initial begin
        $dumpfile("sim/waveforms/cpu_simple_test.vcd");
        $dumpvars(0, tb_cpu_simple);

        $display("========================================");
        $display("  シングルサイクルCPU テスト");
        $display("========================================");

        CLK = 0; RST = 0;
        #1;

        $display("\n[リセット]");
        RST = 1; #1 @(posedge CLK); #1 @(negedge CLK); RST = 0; #1;
        $display("  PC=0x%02h (初期化完了)", cpu.PC);

        $display("\n[プログラム実行]");
        $display("  命令一覧（ROM内容）:");
        $display("    0: 0x08 → ADD R1, R0 (R1←R1+R0=0+0=0)");
        $display("    1: 0x19 → ADD R3, R1 (R3←R3+R1=0+0=0)");
        $display("    2: 0x4A → AND R1, R2 (R1←R1&R2=0&0=0)");
        $display("    3: 0x63 → OR  R0, R3 (R0←R0|R3, R0書込無視)");
        $display("    4: 0x84 → XOR R0, R4 (R0←R0^R4, R0書込無視)");
        $display("    5: 0xA8 → NOT R1, R0 (R1←~R1=~0=0xFF)");
        $display("    6: 0x00 → ADD R0, R0 (NOP)");
        $display("    7: 0x00 → ADD R0, R0 (NOP)");

        // 8サイクル実行してレジスタ状態を観察
        repeat (8) begin
            #1 @(posedge CLK); #1 @(negedge CLK); #1;
            $display("  [Cycle] PC=0x%02h INST=0x%02h | R0=0x%02h R1=0x%02h R2=0x%02h R3=0x%02h",
                cpu.PC, cpu.INST,
                cpu.regfile.reg_out[0], cpu.regfile.reg_out[1],
                cpu.regfile.reg_out[2], cpu.regfile.reg_out[3]
            );
        end

        $display("\n[検証]");
        // 期待: R0は常に0、R1は命令5でNOTされて0xFF、R2/R3は変化なし（初期0）
        if (cpu.regfile.reg_out[0] === 8'h00)
            $display("  ✓ R0 = 0x00 (固定ゼロ維持)");
        else
            $display("  ✗ R0 は 0x00 のはず。得た値 0x%02h", cpu.regfile.reg_out[0]);

        if (cpu.regfile.reg_out[1] === 8'hFF)
            $display("  ✓ R1 = 0xFF (NOT命令で反転)");
        else
            $display("  ✗ R1 は 0xFF のはず。得た値 0x%02h", cpu.regfile.reg_out[1]);

        if (cpu.regfile.reg_out[2] === 8'h00)
            $display("  ✓ R2 = 0x00 (未変更)");
        else
            $display("  ✗ R2 は 0x00 のはず。得た値 0x%02h", cpu.regfile.reg_out[2]);

        if (cpu.regfile.reg_out[3] === 8'h00)
            $display("  ✓ R3 = 0x00 (未変更)");
        else
            $display("  ✗ R3 は 0x00 のはず。得た値 0x%02h", cpu.regfile.reg_out[3]);

        $display("\n========================================");
        $display("  テスト完了");
        $display("========================================");
        #5 $finish;
    end

    always #5 CLK = ~CLK;
endmodule
