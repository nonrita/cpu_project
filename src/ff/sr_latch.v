module sr_latch (
    input S_bar,
    input R_bar,
    output Q,
    output Q_bar
);
    nand_gate nand_set(S_bar, Q_bar, Q);
    nand_gate nand_reset(R_bar, Q, Q_bar);
endmodule