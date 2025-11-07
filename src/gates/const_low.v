`timescale 1ns / 1ps

module const_low (
  output wire y
);
  wire one_in;
  assign one_in = 1'b1;

  nand_gate n1 (one_in, one_in, y);
endmodule
