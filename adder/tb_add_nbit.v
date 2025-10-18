`timescale 1ns/1ps

module tb_add_nbit;
    // Tham số
    parameter n = 8;

    // Tín hiệu test
    reg  signed [n-1:0] a, b;
    wire signed [n:0]   sum;

    // Gọi module cần test
    add_nbit #(.n(n)) uut (
        .a(a),
        .b(b),
        .sum(sum)
    );

    // Test nhiều trường hợp
    initial begin
        $display("==== Test n-bit Adder ====");
        $display("Time\t\ta\tb\t| sum");

        // Trường hợp 1: 5 + 3
        a = 8'd5;  b = 8'd3;
        #10 $display("%0t\t%d\t%d\t| %d", $time, a, b, sum);

        // Trường hợp 2: -5 + 7
        a = -8'd5; b = 8'd7;
        #10 $display("%0t\t%d\t%d\t| %d", $time, a, b, sum);

        // Trường hợp 3: -10 + (-20)
        a = -8'd10; b = -8'd20;
        #10 $display("%0t\t%d\t%d\t| %d", $time, a, b, sum);

        // Trường hợp 4: 50 + 70
        a = 8'd50; b = 8'd70;
        #10 $display("%0t\t%d\t%d\t| %d", $time, a, b, sum);

        // Trường hợp 5: 127 + 1 (tràn dấu)
        a = 8'd127; b = 8'd1;
        #10 $display("%0t\t%d\t%d\t| %d", $time, a, b, sum);

        // Trường hợp 6: -128 + (-1) (tràn dấu)
        a = -8'd128; b = -8'd1;
        #10 $display("%0t\t%d\t%d\t| %d", $time, a, b, sum);

        $display("==========================");
        $stop;
    end
endmodule
