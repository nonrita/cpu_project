`timescale 1ns / 1ps

module tb_alu8;
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] op;
    wire [7:0] result;
    wire zero;
    wire carry;

    alu8 dut (
        .A(A),
        .B(B),
        .op(op),
        .result(result),
        .zero(zero),
        .carry(carry)
    );

    // モニタリング
    initial begin
        $display("========================================");
        $display("  8ビット ALU");
        $display("========================================");
        $display("");
        $dumpfile("sim/waveforms/alu8_test.vcd");
        $dumpvars(0, tb_alu8);
    end

    // テストシナリオ
    initial begin
        // テスト1: ADD（加算）
        $display("[テスト1] ADD（加算）");
        $display("  - op=000でA+Bを計算");
        A = 8'h0A;  // 10
        B = 8'h05;  // 5
        op = 3'b000;
        #10;
        if (result == 8'h0F && carry == 0 && zero == 0)
            $display("  ✓ 成功: 0A + 05 = %h (期待: 0F), carry=%b, zero=%b", result, carry, zero);
        else
            $display("  ✗ 失敗: result=%h (期待: 0F), carry=%b, zero=%b", result, carry, zero);
        $display("");

        // テスト2: ADD with carry
        $display("[テスト2] ADD（キャリー発生）");
        $display("  - 255 + 1 = 0 (キャリー発生)");
        A = 8'hFF;  // 255
        B = 8'h01;  // 1
        op = 3'b000;
        #10;
        if (result == 8'h00 && carry == 1 && zero == 1)
            $display("  ✓ 成功: FF + 01 = %h (期待: 00), carry=%b, zero=%b", result, carry, zero);
        else
            $display("  ✗ 失敗: result=%h (期待: 00), carry=%b, zero=%b", result, carry, zero);
        $display("");

        // テスト3: SUB（減算）
        $display("[テスト3] SUB（減算）");
        $display("  - op=001でA-Bを計算");
        A = 8'h0F;  // 15
        B = 8'h05;  // 5
        op = 3'b001;
        #10;
        if (result == 8'h0A && zero == 0)
            $display("  ✓ 成功: 0F - 05 = %h (期待: 0A), zero=%b", result, zero);
        else
            $display("  ✗ 失敗: result=%h (期待: 0A), zero=%b", result, zero);
        $display("");

        // テスト4: SUB (zero result)
        $display("[テスト4] SUB（結果が0）");
        $display("  - 同じ値を引いてゼロフラグ確認");
        A = 8'h2A;  // 42
        B = 8'h2A;  // 42
        op = 3'b001;
        #10;
        if (result == 8'h00 && zero == 1)
            $display("  ✓ 成功: 2A - 2A = %h (期待: 00), zero=%b", result, zero);
        else
            $display("  ✗ 失敗: result=%h (期待: 00), zero=%b", result, zero);
        $display("");

        // テスト5: AND（論理積）
        $display("[テスト5] AND（論理積）");
        $display("  - op=010でA&Bを計算");
        A = 8'b11110000;
        B = 8'b10101010;
        op = 3'b010;
        #10;
        if (result == 8'b10100000 && zero == 0)
            $display("  ✓ 成功: F0 & AA = %h (期待: A0), zero=%b", result, zero);
        else
            $display("  ✗ 失敗: result=%h (期待: A0), zero=%b", result, zero);
        $display("");

        // テスト6: OR（論理和）
        $display("[テスト6] OR（論理和）");
        $display("  - op=011でA|Bを計算");
        A = 8'b11110000;
        B = 8'b10101010;
        op = 3'b011;
        #10;
        if (result == 8'b11111010 && zero == 0)
            $display("  ✓ 成功: F0 | AA = %h (期待: FA), zero=%b", result, zero);
        else
            $display("  ✗ 失敗: result=%h (期待: FA), zero=%b", result, zero);
        $display("");

        // テスト7: XOR（排他的論理和）
        $display("[テスト7] XOR（排他的論理和）");
        $display("  - op=100でA^Bを計算");
        A = 8'b11110000;
        B = 8'b10101010;
        op = 3'b100;
        #10;
        if (result == 8'b01011010 && zero == 0)
            $display("  ✓ 成功: F0 ^ AA = %h (期待: 5A), zero=%b", result, zero);
        else
            $display("  ✗ 失敗: result=%h (期待: 5A), zero=%b", result, zero);
        $display("");

        // テスト8: NOT（否定）
        $display("[テスト8] NOT（否定）");
        $display("  - op=101で~Aを計算");
        A = 8'b11110000;
        B = 8'h00;  // Bは使用されない
        op = 3'b101;
        #10;
        if (result == 8'b00001111 && zero == 0)
            $display("  ✓ 成功: ~F0 = %h (期待: 0F), zero=%b", result, zero);
        else
            $display("  ✗ 失敗: result=%h (期待: 0F), zero=%b", result, zero);
        $display("");

        // テスト9: 複数の演算を連続実行
        $display("[テスト9] 連続演算テスト");
        A = 8'h10;
        B = 8'h08;
        
        op = 3'b000; #10;  // ADD: 10 + 08 = 18
        $display("  ADD: %h + %h = %h (期待: 18)", 8'h10, 8'h08, result);
        
        op = 3'b001; #10;  // SUB: 10 - 08 = 08
        $display("  SUB: %h - %h = %h (期待: 08)", 8'h10, 8'h08, result);
        
        op = 3'b010; #10;  // AND: 10 & 08 = 00
        $display("  AND: %h & %h = %h (期待: 00)", 8'h10, 8'h08, result);
        
        op = 3'b011; #10;  // OR:  10 | 08 = 18
        $display("  OR:  %h | %h = %h (期待: 18)", 8'h10, 8'h08, result);
        $display("");

        $display("========================================");
        $display("  テスト完了");
        $display("========================================");
        #10;
        $finish;
    end
endmodule
