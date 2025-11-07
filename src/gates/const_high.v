`timescale 1ns / 1ps

module const_high (
  output wire y
);
  wire zero;
  wire one_in = 1'b1;

  nand_gate n1 (one_in, one_in, zero);
  nand_gate n2 (zero, zero, y);
endmodule
