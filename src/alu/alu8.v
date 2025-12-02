`timescale 1ns / 1ps

// 8ビット ALU（算術論理演算ユニット）
// op[2:0]で演算を選択:
//   000: ADD (加算)
//   001: SUB (減算)
//   010: AND (論理積)
//   011: OR  (論理和)
//   100: XOR (排他的論理和)
//   101: NOT A (Aの否定)
//   110: 予約
//   111: 予約
module alu8 (
    input [7:0] A,        // 入力A
    input [7:0] B,        // 入力B
    input [2:0] op,       // 演算選択
    output [7:0] result,  // 演算結果
    output zero,          // ゼロフラグ（result == 0）
    output carry          // キャリーフラグ（加算/減算のキャリー）
);
    wire [7:0] add_result, sub_result, and_result, or_result, xor_result, not_result;
    wire add_carry, sub_carry;
    wire cin_low;
    
    // 定数0
    const_low const0(.y(cin_low));
    
    // ===== 各演算の実行 =====
    
    // ADD: A + B
    adder8 add_unit (
        .a(A),
        .b(B),
        .cin(cin_low),
        .sum(add_result),
        .cout(add_carry)
    );
    
    // SUB: A - B (2の補数を使用: A + (~B) + 1)
    wire [7:0] B_inv;
    wire cin_high;
    const_high const1(.y(cin_high));
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : inv_b
            not_gate not_i(.a(B[i]), .y(B_inv[i]));
        end
    endgenerate
    
    adder8 sub_unit (
        .a(A),
        .b(B_inv),
        .cin(cin_high),  // +1 for 2's complement
        .sum(sub_result),
        .cout(sub_carry)
    );
    
    // AND: A & B
    generate
        for (i = 0; i < 8; i = i + 1) begin : and_op
            and_gate and_i(.a(A[i]), .b(B[i]), .y(and_result[i]));
        end
    endgenerate
    
    // OR: A | B
    generate
        for (i = 0; i < 8; i = i + 1) begin : or_op
            or_gate or_i(.a(A[i]), .b(B[i]), .y(or_result[i]));
        end
    endgenerate
    
    // XOR: A ^ B
    generate
        for (i = 0; i < 8; i = i + 1) begin : xor_op
            xor_gate xor_i(.a(A[i]), .b(B[i]), .y(xor_result[i]));
        end
    endgenerate
    
    // NOT: ~A
    generate
        for (i = 0; i < 8; i = i + 1) begin : not_op
            not_gate not_i(.a(A[i]), .y(not_result[i]));
        end
    endgenerate
    
    // ===== 演算選択（MUXツリー） =====
    
    // 第1段階: 6つの結果を3つに絞る
    wire [7:0] mux0_out, mux1_out, mux2_out;
    
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_stage1
            // mux0: ADD(0) or SUB(1)
            mux2 m0(.a(add_result[i]), .b(sub_result[i]), .sel(op[0]), .y(mux0_out[i]));
            // mux1: AND(0) or OR(1)
            mux2 m1(.a(and_result[i]), .b(or_result[i]), .sel(op[0]), .y(mux1_out[i]));
            // mux2: XOR(0) or NOT(1)
            mux2 m2(.a(xor_result[i]), .b(not_result[i]), .sel(op[0]), .y(mux2_out[i]));
        end
    endgenerate
    
    // 第2段階: 3つの結果を2つに絞る
    wire [7:0] mux3_out, mux4_out;
    
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_stage2
            // mux3: mux0_out(op[1]=0) or mux1_out(op[1]=1)
            mux2 m3(.a(mux0_out[i]), .b(mux1_out[i]), .sel(op[1]), .y(mux3_out[i]));
            // mux4: mux2_out
            assign mux4_out[i] = mux2_out[i];
        end
    endgenerate
    
    // 第3段階: 最終選択
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_stage3
            // op[2]=0: mux3_out (ADD/SUB/AND/OR)
            // op[2]=1: mux4_out (XOR/NOT)
            mux2 m_final(.a(mux3_out[i]), .b(mux4_out[i]), .sel(op[2]), .y(result[i]));
        end
    endgenerate
    
    // ===== フラグ生成 =====
    
    // Zeroフラグ: result == 0
    wire or_tree_1, or_tree_2, or_tree_3, or_tree_4;
    wire or_tree_5, or_tree_6, or_tree_7;
    
    or_gate or1(.a(result[0]), .b(result[1]), .y(or_tree_1));
    or_gate or2(.a(result[2]), .b(result[3]), .y(or_tree_2));
    or_gate or3(.a(result[4]), .b(result[5]), .y(or_tree_3));
    or_gate or4(.a(result[6]), .b(result[7]), .y(or_tree_4));
    
    or_gate or5(.a(or_tree_1), .b(or_tree_2), .y(or_tree_5));
    or_gate or6(.a(or_tree_3), .b(or_tree_4), .y(or_tree_6));
    or_gate or7(.a(or_tree_5), .b(or_tree_6), .y(or_tree_7));
    
    not_gate not_zero(.a(or_tree_7), .y(zero));
    
    // Carryフラグ: ADD/SUBのキャリーを選択
    mux2 carry_mux(.a(add_carry), .b(sub_carry), .sel(op[0]), .y(carry));

endmodule
