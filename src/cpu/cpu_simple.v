`timescale 1ns / 1ps

// 簡易シングルサイクルCPU
// 1クロックで: Fetch → Decode → RegRead → ALU → WriteBack
// 現状の制約:
//   - rdとrsの両方を読み出し、ALU結果をrdに書き戻す（rd = rd op rs形式）
//   - 分岐なし（PCは常に+1）
//   - R0は書き込み無視（regfileの仕様）
module cpu_simple (
    input CLK,
    input RST
);
    // --- PC構成 ---
    wire [7:0] PC, pc_next;
    wire [7:0] one;
    const_high oh0(.y(one[0]));
    genvar gi;
    generate
        for (gi = 1; gi < 8; gi = gi + 1) begin : one_zeros
            const_low oz(.y(one[gi]));
        end
    endgenerate
    wire c_out_pc;
    adder8 add_pc(.a(PC), .b(one), .cin(1'b0), .sum(pc_next), .cout(c_out_pc));
    wire [7:0] pc_in;
    mux2 pc_mux[7:0](.a(PC), .b(pc_next), .sel(1'b1), .y(pc_in));
    reg8 pc_reg(.CLK(CLK), .RST(RST), .WE(1'b1), .D(pc_in), .Q(PC));

    // --- Fetch ---
    wire [2:0] addr3 = PC[2:0];
    wire [7:0] INST;
    rom8x8 rom(.A(addr3), .D(INST));

    // --- Decode ---
    wire [2:0] opcode, rd, rs;
    decoder dec(.inst(INST), .opcode(opcode), .rd(rd), .rs(rs));

    // --- Register File ---
    // RA1 = rd（現在の値を読む）、RA2 = rs、WA = rd（結果を書き戻す）
    wire [7:0] RD1, RD2;
    wire [7:0] alu_result;
    wire we_reg;
    const_high we_h(.y(we_reg)); // 常にWrite Enable（R0は内部で無視される）
    regfile8x8 regfile(
        .CLK(CLK), .RST(RST), .WE(we_reg),
        .RA1(rd), .RA2(rs), .WA(rd),
        .WD(alu_result), .RD1(RD1), .RD2(RD2)
    );

    // --- ALU ---
    // A = RD1（rdの現在値）、B = RD2（rsの値）、op = opcode
    wire zero, carry;
    alu8 alu(
        .A(RD1), .B(RD2), .op(opcode),
        .result(alu_result), .zero(zero), .carry(carry)
    );
endmodule
