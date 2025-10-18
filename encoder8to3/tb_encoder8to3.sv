`timescale 1ns/1ps
module tb_encoder8to3;

    reg  [7:0] in;     // tín hiệu đầu vào (8 bit)
    wire [2:0] out;    // tín hiệu đầu ra (3 bit)

    // Gọi module encoder
    encoder8to3 uut (
        .in(in),
        .out(out)
    );

    initial begin
        $display("Time\tInput(in)\tOutput(out)");
        $monitor("%0dns\t%b\t%b", $time, in, out);

        // Kiểm tra từng giá trị one-hot
        in = 8'b00000001; #10;
        in = 8'b00000010; #10;
        in = 8'b00000100; #10;
        in = 8'b00001000; #10;
        in = 8'b00010000; #10;
        in = 8'b00100000; #10;
        in = 8'b01000000; #10;
        in = 8'b10000000; #10;

        // Trường hợp không hợp lệ (nhiều bit cùng bật)
        in = 8'b00001100; #10;
        in = 8'b00000000; #10;

        $finish;
    end

endmodule
