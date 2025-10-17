`timescale 1ns/1ps

module tb_sub_nbit;
    parameter n = 8;

    // Khai báo các biến kiểm thử
    reg  signed [n-1:0] a, b;
    wire signed [n:0]   sum;

    // Gọi module DUT (Device Under Test)
    sub_nbit #(.n(n)) uut (
        .a(a),
        .b(b),
        .sum(sum)
    );

    // Nhiều case kiểm thử
    initial begin
        $display("====== SUBTRACTOR TEST ======");
        $display("Time\ta\tb\ta-b\t| Binary (sum[n:0])");
        $display("---------------------------------------------");

        // Case 1:  10 - 3 = 7
        a = 8'sd10; b = 8'sd3;
        #10 $display("%0t\t%0d\t%0d\t%0d\t| %b", $time, a, b, sum, sum);

        // Case 2:  5 - (-2) = 7
        a = 8'sd5;  b = -8'sd2;
        #10 $display("%0t\t%0d\t%0d\t%0d\t| %b", $time, a, b, sum, sum);

        // Case 3: -8 - 3 = -11
        a = -8'sd8; b = 8'sd3;
        #10 $display("%0t\t%0d\t%0d\t%0d\t| %b", $time, a, b, sum, sum);

        // Case 4: -5 - (-5) = 0
        a = -8'sd5; b = -8'sd5;
        #10 $display("%0t\t%0d\t%0d\t%0d\t| %b", $time, a, b, sum, sum);

        // Case 5: 127 - (-1) = 128 (tràn dấu!)
        a = 8'sd127; b = -8'sd1;
        #10 $display("%0t\t%0d\t%0d\t%0d\t| %b", $time, a, b, sum, sum);

        // Case 6: -128 - 1 = -129 (tràn âm)
        a = -8'sd128; b = 8'sd1;
        #10 $display("%0t\t%0d\t%0d\t%0d\t| %b", $time, a, b, sum, sum);

        $display("=============================================");
        $stop;
    end
endmodule
