`timescale 1ns/1ps
module bit_pattern_tb;
reg clk;
reg rst_n;
reg data;
wire detect;
bit_pattern dut (
.clk(clk),
.rst_n(rst_n),
.data(data),
.detect(detect)
);

always #5 clk = ~clk;
task send_bit(input din);
begin
    @(negedge clk);
    data = din;
    @(posedge clk);
    $display("[%0t] Send bit = %b | detect = %b", $time, din, detect);
end
endtask

initial begin

    clk = 0;
    rst_n = 0;
    data = 0;

    repeat (2) @(posedge clk);
    rst_n = 1;
    $display("[%0t] Reset released.", $time);
    $display("\n=== Test 1: Single pattern 1011 ===");
    send_bit(1);
    send_bit(0);
    send_bit(1);
    send_bit(1);  
    $display("\n=== Test 2: Overlapping pattern 1011011 ===");
    send_bit(1);
    send_bit(0);
    send_bit(1);
    send_bit(1);  
    send_bit(0);
    send_bit(1);
    send_bit(1);  
    $display("\n=== Test 3: Random pattern ===");
    repeat (10) send_bit($random % 2);
    #20;
    $finish;
    end
endmodule
