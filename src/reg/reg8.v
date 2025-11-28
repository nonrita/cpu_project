module reg8 (
    input [7:0] D,
    input CLK,
    input WE,
    input RST,
    output [7:0] Q
);
    genvar i;
    generate 
        for (i = 0; i < 8; i = i + 1) begin : bit_reg

            wire D_in_i;

            mux2 mux_data (Q[i], D[i], WE, D_in_i);

            d_ff ff_i (
              .D(D_in_i),
              .CLK(CLK),
              .RST(RST),
              .Q(Q[i])
            );
        end
    endgenerate
endmodule