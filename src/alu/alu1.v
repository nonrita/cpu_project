`timescale 1ns / 1ps

// 1ビット ALU
// op[2:0]で演算を選択:
//   000: ADD (a + b + cin)
//   010: AND (a & b)
//   011: OR  (a | b)
//   100: XOR (a ^ b)
//   101: NOT A (~a)
// それ以外: 0
module alu1 (
    input a,
    input b,
    input cin,         // 加算時のキャリー入力
    input [2:0] op,
    output y,          // 演算結果
    output cout        // 加算時のキャリー出力
);
    wire add_sum, add_cout;
    wire and_y, or_y, xor_y, not_y;

    // ADD
    full_adder fa(.a(a), .b(b), .cin(cin), .sum(add_sum), .cout(add_cout));

    // AND, OR, XOR, NOT
    and_gate g_and(.a(a), .b(b), .y(and_y));
    or_gate  g_or (.a(a), .b(b), .y(or_y));
    xor_gate g_xor(.a(a), .b(b), .y(xor_y));
    not_gate g_not(.a(a), .y(not_y));

    // opのデコード（1-hot）
    wire op0_n, op1_n, op2_n;
    not_gate n0(.a(op[0]), .y(op0_n));
    not_gate n1(.a(op[1]), .y(op1_n));
    not_gate n2(.a(op[2]), .y(op2_n));

    wire sel_000, sel_010, sel_011, sel_100, sel_101;
    // 000
    and3_gate d000(.a(op2_n), .b(op1_n), .c(op0_n), .y(sel_000));
    // 010: (~op2) & op1 & (~op0)
    and3_gate d010(.a(op2_n), .b(op[1]), .c(op0_n), .y(sel_010));
    // 011: (~op2) & op1 & op0
    and3_gate d011(.a(op2_n), .b(op[1]), .c(op[0]),  .y(sel_011));
    // 100: op2 & (~op1) & (~op0)
    and3_gate d100(.a(op[2]), .b(op1_n), .c(op0_n), .y(sel_100));
    // 101: op2 & (~op1) & op0
    and3_gate d101(.a(op[2]), .b(op1_n), .c(op[0]),  .y(sel_101));

    // 各結果をゲートしてOR合成
    wire y_add_g, y_and_g, y_or_g, y_xor_g, y_not_g;
    and_gate ga(.a(sel_000), .b(add_sum), .y(y_add_g));
    and_gate gb(.a(sel_010), .b(and_y),   .y(y_and_g));
    and_gate gc(.a(sel_011), .b(or_y),    .y(y_or_g));
    and_gate gd(.a(sel_100), .b(xor_y),   .y(y_xor_g));
    and_gate ge(.a(sel_101), .b(not_y),   .y(y_not_g));

    // OR合成を2入力チェーンからor3_gate構成へ変更
    wire zero_const; // 3入力目の埋め草（0）
    const_low zc(.y(zero_const));
    wire or_grp1, or_grp2, or_final;
    // 1グループ: ADD, AND, OR
    or3_gate og1(.a(y_add_g), .b(y_and_g), .c(y_or_g), .y(or_grp1));
    // 2グループ: XOR, NOT, 0
    or3_gate og2(.a(y_xor_g), .b(y_not_g), .c(zero_const), .y(or_grp2));
    // 最終合成
    or_gate ogf(.a(or_grp1), .b(or_grp2), .y(or_final));
    assign y = or_final;

    // キャリーはADDの時のみ
    wire cout_g;
    and_gate gcout(.a(sel_000), .b(add_cout), .y(cout_g));
    assign cout = cout_g;
endmodule
