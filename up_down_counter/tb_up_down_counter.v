`timescale 1ns/1ps
module tb_up_down_counter;

    parameter N = 4;
    reg clk, rst, up_down;
    wire [N-1:0] count;

    // Gọi module bộ đếm
    up_down_counter #(N) uut (
        .clk(clk),
        .rst(rst),
        .up_down(up_down),
        .count(count)
    );

    // Tạo xung clock 10ns
    always #5 clk = ~clk;

    initial begin
        $display("Time\tclk\trst\tup_down\tcount");
        $monitor("%0dns\t%b\t%b\t%d", $time, rst, up_down, count);

        // Khởi tạo ban đầu
        clk = 0;
        rst = 1;
        up_down = 1;   // bắt đầu ở chế độ đếm lên
        #10;

        rst = 0;       // bỏ reset, bắt đầu đếm
        #80;

        up_down = 0;   // chuyển sang đếm xuống
        #80;

        rst = 1;       // reset lại
        #10;

        rst = 0;       // tiếp tục đếm lên
        up_down = 1;
        #50;

        $finish;
    end

endmodule
