`timescale 1ns / 1ps

// 8x8ビット ROM
// 3ビットアドレスで8ビットデータを即時読み出し（組合せ）
// 命令形式: [7:5]=opcode, [4:3]=rd, [2:0]=rs
module rom8x8 (
    input [2:0] A,     // アドレス
    output [7:0] D     // データ
);
    // 簡易プログラム（学習用）:
    // 0: 0x08 = 00001000 → opcode=000(ADD), rd=01(R1), rs=000(R0) → R1←R1+R0
    // 1: 0x19 = 00011001 → opcode=000(ADD), rd=11(R3), rs=001(R1) → R3←R3+R1
    // 2: 0x4A = 01001010 → opcode=010(AND), rd=01(R1), rs=010(R2) → R1←R1&R2
    // 3: 0x63 = 01100011 → opcode=011(OR),  rd=00(R0), rs=011(R3) → R0←R0|R3 (R0書込無視)
    // 4: 0x84 = 10000100 → opcode=100(XOR), rd=00(R0), rs=100(R4未使用) → R0←R0^R4
    // 5: 0xA8 = 10101000 → opcode=101(NOT), rd=01(R1), rs=000(R0) → R1←~R1
    // 6: 0x00 = 00000000 → opcode=000(ADD), rd=00(R0), rs=000(R0) → R0←R0+R0 (NOP相当)
    // 7: 0x00 = 00000000 → 同上
    wire [7:0] d0, d1, d2, d3, d4, d5, d6, d7;
    // 各バイトは const_high/low の組み合わせで構成
    // d0 = 0x08 = 00001000
    const_low c00(.y(d0[0])); const_low c01(.y(d0[1])); const_low c02(.y(d0[2])); const_high c03(.y(d0[3]));
    const_low c04(.y(d0[4])); const_low c05(.y(d0[5])); const_low c06(.y(d0[6])); const_low c07(.y(d0[7]));
    // d1 = 0x19 = 00011001
    const_high c10(.y(d1[0])); const_low c11(.y(d1[1])); const_low c12(.y(d1[2])); const_high c13(.y(d1[3]));
    const_high c14(.y(d1[4])); const_low c15(.y(d1[5])); const_low c16(.y(d1[6])); const_low c17(.y(d1[7]));
    // d2 = 0x4A = 01001010
    const_low c20(.y(d2[0])); const_high c21(.y(d2[1])); const_low c22(.y(d2[2])); const_high c23(.y(d2[3]));
    const_low c24(.y(d2[4])); const_low c25(.y(d2[5])); const_high c26(.y(d2[6])); const_low c27(.y(d2[7]));
    // d3 = 0x63 = 01100011
    const_high c30(.y(d3[0])); const_high c31(.y(d3[1])); const_low c32(.y(d3[2])); const_low c33(.y(d3[3]));
    const_low c34(.y(d3[4])); const_high c35(.y(d3[5])); const_high c36(.y(d3[6])); const_low c37(.y(d3[7]));
    // d4 = 0x84 = 10000100
    const_low c40(.y(d4[0])); const_low c41(.y(d4[1])); const_high c42(.y(d4[2])); const_low c43(.y(d4[3]));
    const_low c44(.y(d4[4])); const_low c45(.y(d4[5])); const_low c46(.y(d4[6])); const_high c47(.y(d4[7]));
    // d5 = 0xA8 = 10101000
    const_low c50(.y(d5[0])); const_low c51(.y(d5[1])); const_low c52(.y(d5[2])); const_high c53(.y(d5[3]));
    const_low c54(.y(d5[4])); const_high c55(.y(d5[5])); const_low c56(.y(d5[6])); const_high c57(.y(d5[7]));
    // d6 = 0x00 = 00000000
    const_low c60(.y(d6[0])); const_low c61(.y(d6[1])); const_low c62(.y(d6[2])); const_low c63(.y(d6[3]));
    const_low c64(.y(d6[4])); const_low c65(.y(d6[5])); const_low c66(.y(d6[6])); const_low c67(.y(d6[7]));
    // d7 = 0x00 = 00000000
    const_low c70(.y(d7[0])); const_low c71(.y(d7[1])); const_low c72(.y(d7[2])); const_low c73(.y(d7[3]));
    const_low c74(.y(d7[4])); const_low c75(.y(d7[5])); const_low c76(.y(d7[6])); const_low c77(.y(d7[7]));

    // アドレスデコードで選択（8:1 MUXを階層化した形）
    wire [7:0] s01, s23, s45, s67;
    mux2 m01[7:0](.a(d0), .b(d1), .sel(A[0]), .y(s01));
    mux2 m23[7:0](.a(d2), .b(d3), .sel(A[0]), .y(s23));
    mux2 m45[7:0](.a(d4), .b(d5), .sel(A[0]), .y(s45));
    mux2 m67[7:0](.a(d6), .b(d7), .sel(A[0]), .y(s67));

    wire [7:0] s0123, s4567;
    mux2 m0123[7:0](.a(s01), .b(s23), .sel(A[1]), .y(s0123));
    mux2 m4567[7:0](.a(s45), .b(s67), .sel(A[1]), .y(s4567));

    mux2 mfinal[7:0](.a(s0123), .b(s4567), .sel(A[2]), .y(D));
endmodule
