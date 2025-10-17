`timescale 1ns / 1ps
module tb_traffic_top();
    reg clk;
    reg rst_n;
    wire [2:0] led_traffic1;
    wire [2:0] led_traffic2;

    // Gọi module top
    traffic_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .led_traffic1(led_traffic1),
        .led_traffic2(led_traffic2)
    );

    // Tạo clock 10ns (100 MHz)
    always #5 clk = ~clk;traffic

    initial begin
        
        // Reset ban đầu
        clk = 0;
        rst_n = 0;
        #20;
        rst_n = 1;

        // Mô phỏng 500ns (đủ vài chu kỳ đèn)
        #500;
        $finish;
    end

    // In ra trạng thái đèn theo thời gian
    initial begin
        $monitor("T=%0t | LED1=%b | LED2=%b", $time, led_traffic1, led_traffic2);
    end
endmodule
