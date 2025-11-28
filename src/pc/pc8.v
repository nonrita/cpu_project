`timescale 1ns / 1ps

// 8ビット プログラムカウンタ
// - INC=1でCLK立ち上がり時にカウントアップ
// - RST=1でリセット（0に戻る）
module pc8 (
    input CLK,          // クロック
    input RST,          // リセット
    input INC,          // インクリメント許可
    output [7:0] PC     // プログラムカウンタ値
);
    wire [7:0] pc_plus_1;
    wire [7:0] next_pc;
    wire cout_unused;

    // 現在のPC + 1 を計算
    wire cin_low;
    const_low cin0(.y(cin_low));
    
    wire [7:0] one;
    const_high b0(.y(one[0]));  // LSBを1に
    const_low b1(.y(one[1]));
    const_low b2(.y(one[2]));
    const_low b3(.y(one[3]));
    const_low b4(.y(one[4]));
    const_low b5(.y(one[5]));
    const_low b6(.y(one[6]));
    const_low b7(.y(one[7]));
    
    adder8 inc_adder (
        .a(PC),
        .b(one),
        .cin(cin_low),
        .sum(pc_plus_1),
        .cout(cout_unused)
    );

    // INCが1ならpc_plus_1、0なら現在のPCを保持
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_inc
            mux2 mux_i (
                .a(PC[i]),
                .b(pc_plus_1[i]),
                .sel(INC),
                .y(next_pc[i])
            );
        end
    endgenerate

    // PCレジスタ（常にWE=1で更新）
    wire we_high;
    const_high we1(.y(we_high));
    
    reg8 pc_reg (
        .D(next_pc),
        .CLK(CLK),
        .WE(we_high),
        .RST(RST),
        .Q(PC)
    );
endmodule
