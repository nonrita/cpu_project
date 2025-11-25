module d_latch (
    input D,
    input E,
    output Q,
    output Q_bar
);
    wire S_bar;
    wire R_bar;
    wire D_bar;

    not not_d(D_bar, D);

    nand nand_s(S_bar, E, D);

    nand nand_r(R_bar, E, D_bar);

    sr_latch latch (
        .S_bar(S_bar),
        .R_bar(R_bar),
        .Q(Q),
        .Q_bar(Q_bar)
    );
endmodule