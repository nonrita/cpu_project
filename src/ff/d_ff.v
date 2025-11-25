module d_ff (
    input D,
    input CLK,
    output Q,
    output Q_bar
);
    wire M;
    wire M_bar;
    wire CLK_bar; 

    not_gate not_clk(CLK, CLK_bar);

    d_latch master_latch (
        .D(D),
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