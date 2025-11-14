`timescale 1ns / 1ps

module mux2 (
    input wire a,
    input wire b,
    input wire sel,
    output wire y
);
    wire not_sel, a_and, b_and;

    not_gate n1(sel, not_sel);

    and_gate a1(a, not_sel, a_and);
    and_gate a2(b, sel, b_and);

    or_gate o1(a_and, b_and, y);
endmodule
