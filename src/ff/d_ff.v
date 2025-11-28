module d_ff (
    input D,
    input CLK,
    input RST,
    output Q,
    output Q_bar
);
    wire M;
    wire M_bar;
    wire CLK_bar;
    wire D_in;
    wire const_0;

    // 同期リセット: RST=1の時は0を、RST=0の時はDを入力
    const_low const0(.y(const_0));
    mux2 mux_reset(.a(D), .b(const_0), .sel(RST), .y(D_in));

    not_gate not_clk(CLK, CLK_bar);

    d_latch master_latch (
        .D(D_in),
        .E(CLK),
        .Q(M),
        .Q_bar(M_bar)
    );

    d_latch slave_latch (
        .D(M),
        .E(CLK_bar),
        .Q(Q),
        .Q_bar(Q_bar)
    );
endmodule