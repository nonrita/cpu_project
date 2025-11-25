module d_latch (
    input D,
    input E,
    output Q,
    output Q_bar
);
    wire S_bar;
    wire R_bar;
    wire D_bar;

    not_gate not_d(D, D_bar);

    nand_gate nand_s(E, D, S_bar);

    nand_gate nand_r(E, D_bar, R_bar);

    sr_latch latch (
        .S_bar(S_bar),
        .R_bar(R_bar),
        .Q(Q),
        .Q_bar(Q_bar)
    );
endmodule