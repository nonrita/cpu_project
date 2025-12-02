`timescale 1ns / 1ps

// 簡易命令デコーダ
// 命令フォーマット（8ビット）:
//   [7:5] opcode  - ALU操作 (3ビット)
//   [4:3] rd      - 書き込み先レジスタ番号 (2ビット → R0〜R3)
//   [2:0] rs      - 読み出し元レジスタ番号 (3ビット → R0〜R7)
//
// opcode対応:
//   000: ADD  (rd ← rd + rs)
//   001: SUB  (rd ← rd - rs)
//   010: AND  (rd ← rd & rs)
//   011: OR   (rd ← rd | rs)
//   100: XOR  (rd ← rd ^ rs)
//   101: NOT  (rd ← ~rd)
//   110: reserved
//   111: reserved
module decoder (
    input [7:0] inst,       // 命令
    output [2:0] opcode,    // ALU操作コード
    output [2:0] rd,        // 書き込み先（3ビットに拡張、上位1ビットは0固定）
    output [2:0] rs         // 読み出し元
);
    // opcode = inst[7:5]
    assign opcode[0] = inst[5];
    assign opcode[1] = inst[6];
    assign opcode[2] = inst[7];
    
    // rd = inst[4:3] → 3ビットに拡張（上位を0に）
    assign rd[0] = inst[3];
    assign rd[1] = inst[4];
    wire zero_rd;
    const_low c_rd(.y(zero_rd));
    assign rd[2] = zero_rd;
    
    // rs = inst[2:0]
    assign rs[0] = inst[0];
    assign rs[1] = inst[1];
    assign rs[2] = inst[2];
endmodule
