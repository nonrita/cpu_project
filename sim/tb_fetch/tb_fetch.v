`timescale 1ns / 1ps

// フェッチの最小モデルをテストするベンチ
// 目的: PCが毎サイクル+1され、その下位3ビットでROMを参照し
//       連続したバイト列（擬似命令）を取得できることを確認する。
module tb_fetch;
    reg CLK, RST;
    wire [7:0] PC;
    wire [7:0] INST;

    // --- PC（プログラムカウンタ）構成 ---
    // PCは8ビットレジスタ。次値は PC + 1。
    wire [7:0] pc_next;
    wire [7:0] one;
    // 加算する定数1（00000001）をビット毎に生成
    const_high oh0(.y(one[0]));
    genvar bi;
    generate
        for (bi = 1; bi < 8; bi = bi + 1) begin : one_zeros
            const_low oz(.y(one[bi]));
        end
    endgenerate
    // 8ビット加算器で PC + 1 を計算（キャリー出力は未使用）
    adder8 add(.a(PC), .b(one), .cin(1'b0), .sum(pc_next), .cout());
    wire [7:0] pc_in;
    // フェッチでは常にインクリメント（pc_nextを選ぶ）
    mux2 pc_mux[7:0](.a(PC), .b(pc_next), .sel(1'b1), .y(pc_in));
    // 同期リセット付き8ビットレジスタにPCを保持（毎サイクル書き込む）
    reg8 pc_reg(.CLK(CLK), .RST(RST), .WE(1'b1), .D(pc_in), .Q(PC));

    // --- ROM（命令メモリの最小モデル）---
    // アドレスはPCの下位3ビット（0〜7）。組合せで即時読み出し。
    wire [2:0] addr3 = PC[2:0];
    rom8x8 rom(.A(addr3), .D(INST));

    initial begin
        $dumpfile("sim/waveforms/fetch_test.vcd");
        $dumpvars(0, tb_fetch);

        $display("========================================");
        $display("  フェッチテスト (PC→ROM)");
        $display("========================================");

        CLK = 0; RST = 0;
        #1;
        $display("[リセット]");
        // 同期リセット: 立ち上がりでPCが0にクリアされる
        RST = 1; #1 @(posedge CLK); #1 @(negedge CLK); RST = 0; #1;
        $display("[開始]");

        // 8サイクル観察: 毎サイクル PC は +1、INST はROMの内容が循環
        // 表示タイミング: 立ち上がり→立ち下がり後に安定したPC/INSTを表示
        repeat (8) begin
            #1 @(posedge CLK); #1 @(negedge CLK); #1;
            $display("  PC=0x%02h INST=0x%02h", PC, INST);
        end

        $display("\n========================================");
        $display("  テスト完了");
        $display("========================================");
        #5 $finish;
    end

    always #5 CLK = ~CLK;
endmodule
