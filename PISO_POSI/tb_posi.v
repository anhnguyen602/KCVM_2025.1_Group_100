`timescale 1ns / 1ps

module tb_posi;
    parameter n = 4;
    
    // Khai báo tín hiệu kết nối
    reg clk, rst, load, serial_in, en_o;
    wire [n-1:0] parallel_out;
    
    // Gọi module posi
    posi #(n) uut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .serial_in(serial_in),
        .en_o(en_o),
        .parallel_out(parallel_out)
    );
    
    // Tạo xung clock 10ns
    always #5 clk = ~clk;
    
    // In giá trị mỗi khi có cạnh dương của clock
    always @(posedge clk) begin
        $display("Time=%0t | load=%b | serial_in=%b | en_o=%b | mem=%b | parallel_out=%b", 
                 $time, load, serial_in, en_o, uut.mem, parallel_out);
    end

    initial begin
        // Ghi waveform nếu dùng với simulator như iverilog/gtkwave

        // Khởi tạo ban đầu
        clk = 0;
        rst = 0;
        load = 0;
        serial_in = 0;
        en_o = 0;
        
        // Reset toàn bộ
        #10 rst = 1;
        
        // Bắt đầu shift dữ liệu serial_in (ví dụ: 1 0 1 1)
        #10 load = 1; serial_in = 1;
        #10 serial_in = 0;
        #10 serial_in = 1;
        #10 serial_in = 1;

        // Ngừng load
        #10 load = 0;

        // Bật output song song
        #10 en_o = 1;
        #20 en_o = 0;

        // Thử reset lại để kiểm tra
        #10 rst = 0;
        #10 rst = 1;

        #20 $finish;
    end

endmodule
