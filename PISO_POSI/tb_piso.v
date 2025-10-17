`timescale 1ns / 1ps

module tb_piso;
    // --- Parameter ---
    parameter n = 4;

    // --- Testbench signals ---
    reg clk;
    reg rst;
    reg load;
    reg [n-1:0] parallel_in;
    wire serial_out;

    // --- Instantiate DUT ---
    piso #(.n(n)) uut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .parallel_in(parallel_in),
        .serial_out(serial_out)
    );

    // --- Clock generation ---
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // chu kỳ 10ns
    end

    // --- Test procedure ---
    initial begin
        // Khởi tạo
        rst = 0;
        load = 0;
        parallel_in = 4'b0000;
        #10;
        
        // Bỏ reset
        rst = 1;
        #10;
        
        // Load dữ liệu song song
        parallel_in = 4'b1011;
        load = 1;
        #10;
        load = 0;

        // Dịch dữ liệu ra serial
        repeat (5) begin
            #10; // mỗi xung clock dịch 1 bit
        end

        // Load dữ liệu mới
        parallel_in = 4'b1100;
        load = 1;
        #10;
        load = 0;
        repeat (5) #10;

        // Kết thúc mô phỏng
        $finish;
    end

    // --- Monitor ---
    initial begin
        $monitor("Time=%0t | rst=%b | load=%b | parallel_in=%b | shift_reg=%b| serial_out=%b", 
                  $time, rst, load, parallel_in,uut.shift_reg, serial_out);
    end

endmodule
