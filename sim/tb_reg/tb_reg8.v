`timescale 1ns / 1ps

module tb_reg8;

    reg [7:0] D;
    reg CLK;
    reg WE;
    wire [7:0] Q;

    reg8 dut (
        .D(D),
        .CLK(CLK),
        .WE(WE),
        .Q(Q)
    );

    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK; 
    end

    initial begin
        $display("時間(ns) | CLK | WE | D | Q");
        $display("---------|-----|----|---|---");
        $monitor("%0t | %b | %b | %h | %h", $time, CLK, WE, D, Q);
    end

    initial begin
        $dumpfile("sim/waveforms/reg8_test.vcd");
        $dumpvars(0, tb_reg8);

        D = 8'hAA; 
        WE = 0;
        @(negedge CLK); 

        D = 8'h55; 
        #5;
        
        @(posedge CLK);
        
        D = 8'hCC;
        WE = 1;
        #5; 

        @(posedge CLK);
        
        D = 8'h11;
        #5;
        
        @(negedge CLK);
        #5; 
        
        @(posedge CLK);
        
        WE = 0;
        D = 8'hEE;
        #5; 
        
        @(posedge CLK); 

        $finish;
    end
endmodule