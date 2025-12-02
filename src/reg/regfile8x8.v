`timescale 1ns / 1ps

// 8x8ビット レジスタファイル
// 8本の8ビットレジスタ（R0〜R7）
// 2つの読み出しポート、1つの書き込みポート
// R0は常に0を返す（書き込みは無視）
module regfile8x8 (
    input CLK,
    input RST,              // 同期リセット
    input WE,               // Write Enable
    input [2:0] RA1,        // Read Address 1
    input [2:0] RA2,        // Read Address 2
    input [2:0] WA,         // Write Address
    input [7:0] WD,         // Write Data
    output [7:0] RD1,       // Read Data 1
    output [7:0] RD2        // Read Data 2
);
    // 8本のレジスタ
    wire [7:0] reg_out [0:7];
    
    // R0は常に0（const_low x8）
    wire [7:0] zero_reg;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : zero_bits
            const_low clow(.y(zero_reg[i]));
        end
    endgenerate
    assign reg_out[0] = zero_reg;
    
    // R1〜R7の実装
    generate
        for (i = 1; i < 8; i = i + 1) begin : registers
            // 書き込み制御：WE=1 かつ WA==i のとき書き込み
            wire addr_match;
            wire [2:0] reg_addr;
            // iを3ビットに変換
            assign reg_addr[0] = i[0];
            assign reg_addr[1] = i[1];
            assign reg_addr[2] = i[2];
            
            // アドレスマッチング：WA == reg_addr
            wire eq0, eq1, eq2;
            xnor_gate cmp0(.a(WA[0]), .b(reg_addr[0]), .y(eq0));
            xnor_gate cmp1(.a(WA[1]), .b(reg_addr[1]), .y(eq1));
            xnor_gate cmp2(.a(WA[2]), .b(reg_addr[2]), .y(eq2));
            wire eq01;
            and_gate a01(.a(eq0), .b(eq1), .y(eq01));
            and_gate amatch(.a(eq01), .b(eq2), .y(addr_match));
            
            // 最終的な書き込み許可：WE & addr_match
            wire write_enable;
            and_gate we_gate(.a(WE), .b(addr_match), .y(write_enable));
            
            // レジスタインスタンス
            reg8 r(.CLK(CLK), .RST(RST), .WE(write_enable), .D(WD), .Q(reg_out[i]));
        end
    endgenerate
    
    // Read Port 1: RA1でデコード（1ビットmuxを8本並列に）
    wire [7:0] mux1_stage1 [0:3];
    genvar b1;
    generate
        for (i = 0; i < 4; i = i + 1) begin : rd1_stage1
            for (b1 = 0; b1 < 8; b1 = b1 + 1) begin : rd1_stage1_bits
                mux2 m1s1(.a(reg_out[i*2][b1]), .b(reg_out[i*2+1][b1]), .sel(RA1[0]), .y(mux1_stage1[i][b1]));
            end
        end
    endgenerate
    wire [7:0] mux1_stage2 [0:1];
    genvar b2;
    generate
        for (i = 0; i < 2; i = i + 1) begin : rd1_stage2
            for (b2 = 0; b2 < 8; b2 = b2 + 1) begin : rd1_stage2_bits
                mux2 m1s2(.a(mux1_stage1[i*2][b2]), .b(mux1_stage1[i*2+1][b2]), .sel(RA1[1]), .y(mux1_stage2[i][b2]));
            end
        end
    endgenerate
    wire [7:0] rd1_result;
    genvar b3;
    generate
        for (b3 = 0; b3 < 8; b3 = b3 + 1) begin : rd1_stage3_bits
            mux2 m1s3(.a(mux1_stage2[0][b3]), .b(mux1_stage2[1][b3]), .sel(RA1[2]), .y(rd1_result[b3]));
        end
    endgenerate
    assign RD1 = rd1_result;
    
    // Read Port 2: RA2でデコード（1ビットmuxを8本並列に）
    wire [7:0] mux2_stage1 [0:3];
    genvar b4;
    generate
        for (i = 0; i < 4; i = i + 1) begin : rd2_stage1
            for (b4 = 0; b4 < 8; b4 = b4 + 1) begin : rd2_stage1_bits
                mux2 m2s1(.a(reg_out[i*2][b4]), .b(reg_out[i*2+1][b4]), .sel(RA2[0]), .y(mux2_stage1[i][b4]));
            end
        end
    endgenerate
    wire [7:0] mux2_stage2 [0:1];
    genvar b5;
    generate
        for (i = 0; i < 2; i = i + 1) begin : rd2_stage2
            for (b5 = 0; b5 < 8; b5 = b5 + 1) begin : rd2_stage2_bits
                mux2 m2s2(.a(mux2_stage1[i*2][b5]), .b(mux2_stage1[i*2+1][b5]), .sel(RA2[1]), .y(mux2_stage2[i][b5]));
            end
        end
    endgenerate
    wire [7:0] rd2_result;
    genvar b6;
    generate
        for (b6 = 0; b6 < 8; b6 = b6 + 1) begin : rd2_stage3_bits
            mux2 m2s3(.a(mux2_stage2[0][b6]), .b(mux2_stage2[1][b6]), .sel(RA2[2]), .y(rd2_result[b6]));
        end
    endgenerate
    assign RD2 = rd2_result;
endmodule
