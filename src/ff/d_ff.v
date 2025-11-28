module d_ff (
    input D,
    input CLK,
    input RST,      // リセット入力（1でリセット）
    output Q,
    output Q_bar
);
    wire M;
    wire M_bar;
    wire CLK_bar;
    wire D_in;
    wire const_0;
    wire Q_internal;
    wire Q_bar_internal;

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
        .Q(Q_internal),
        .Q_bar(Q_bar_internal)
    );
    
    mux2 mux_q_out(.a(Q_internal), .b(const_0), .sel(RST), .y(Q));
    wire const_1;
    const_high const1(.y(const_1));
    mux2 mux_qbar_out(.a(Q_bar_internal), .b(const_1), .sel(RST), .y(Q_bar));
endmodule