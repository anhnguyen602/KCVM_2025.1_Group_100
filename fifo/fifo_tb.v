`timescale 1ns/1ps

module fifo_tb;
    parameter WIDTH = 16;
    parameter LENGTH = 8;
    reg clk;
    reg reset_n;
    reg write_en;
    reg read_en;
    reg [WIDTH-1:0] data_in;
    wire full;
    wire empty;
    wire [WIDTH-1:0] data_out;

    // Khởi tạo FIFO
    fifo #(
        .WIDTH(WIDTH),
        .LENGTH(LENGTH)
    ) uut (
        .clk(clk),
        .reset_n(reset_n),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(data_in),
        .full(full),
        .empty(empty),
        .data_out(data_out)
    );

    // Tạo xung clock 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Chuỗi kiểm thử
    initial begin
        // Ghi log ra console
        $monitor("T=%0t | WE=%b RE=%b DIN=%h DOUT=%h FULL=%b EMPTY=%b",
                  $time, write_en, read_en, data_in, data_out, full, empty);

        // Reset
        reset_n = 0;
        write_en = 0;
        read_en = 0;
        data_in = 16'h00;
        #15;
        reset_n = 1;

        // ===== GHI 5 GIÁ TRỊ =====
        repeat (5) begin
            @(negedge clk);
            write_en = 1;
            data_in = $random;
        end
        @(negedge clk);
        write_en = 0;

        // ===== ĐỌC 3 GIÁ TRỊ =====
        repeat (3) begin
            @(negedge clk);
            read_en = 1;
        end
        @(negedge clk);
        read_en = 0;

        // ===== GHI TIẾP 4 GIÁ TRỊ =====
        repeat (4) begin
            @(negedge clk);
            write_en = 1;
            data_in = $random;
        end
        @(negedge clk);
        write_en = 0;

        // ===== ĐỌC HẾT FIFO =====
        while (!empty) begin
            @(negedge clk);
            read_en = 1;
        end
        @(negedge clk);
        read_en = 0;

        // Kết thúc mô phỏng
        #20;
        $stop;
    end

endmodule
