`timescale 1ns / 1ps

module tb_alu1;
    reg a, b, cin;
    reg [2:0] op;
    wire y;
    wire cout;

    alu1 dut(
        .a(a), .b(b), .cin(cin), .op(op), .y(y), .cout(cout)
    );

    initial begin
        $display("========================================");
        $display("  1ビット ALU");
        $display("========================================");
        $dumpfile("sim/waveforms/alu1_test.vcd");
        $dumpvars(0, tb_alu1);
    end

    task check(input [2:0] t_op, input ta, input tb, input tcin, input exp_y, input exp_c);
    begin
        op = t_op; a = ta; b = tb; cin = tcin; #1;
        if (y===exp_y && cout===exp_c)
            $display("  ✓ op=%b a=%b b=%b cin=%b -> y=%b cout=%b", t_op, ta, tb, tcin, y, cout);
        else
            $display("  ✗ op=%b a=%b b=%b cin=%b -> y=%b cout=%b (期待 y=%b c=%b)", t_op, ta, tb, tcin, y, cout, exp_y, exp_c);
    end
    endtask

    initial begin
        // ADD 000
        $display("[ADD]");
        check(3'b000, 0,0,0, 0,0);
        check(3'b000, 0,1,0, 1,0);
        check(3'b000, 1,1,0, 0,1);
        check(3'b000, 1,1,1, 1,1);
        $display("");

        // AND 010
        $display("[AND]");
        check(3'b010, 0,0,0, 0,0);
        check(3'b010, 1,0,0, 0,0);
        check(3'b010, 1,1,0, 1,0);
        $display("");

        // OR 011
        $display("[OR]");
        check(3'b011, 0,0,0, 0,0);
        check(3'b011, 1,0,0, 1,0);
        check(3'b011, 1,1,0, 1,0);
        $display("");

        // XOR 100
        $display("[XOR]");
        check(3'b100, 0,0,0, 0,0);
        check(3'b100, 1,0,0, 1,0);
        check(3'b100, 1,1,0, 0,0);
        $display("");

        // NOT 101
        $display("[NOT]");
        check(3'b101, 0,0,0, 1,0);
        check(3'b101, 1,0,0, 0,0);
        $display("");

        $display("========================================");
        $display("  テスト完了");
        $display("========================================");
        #10; $finish;
    end
endmodule
