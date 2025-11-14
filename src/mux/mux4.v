`timescale 1ns / 1ps

module mux4 (
    input wire d0, d1, d2, d3,
    input wire [1:0] sel,
    output wire y
);
    wire y0, y1;

    mux2 m0(d0, d1, sel[0], y0);
    mux2 m1(d2, d3, sel[0], y1);
    mux2 m2(y0, y1, sel[1], y);
endmodule
