`timescale 1ns / 1ps

module tb_data_swapper;

    // Parameter
    parameter N = 8;

    // Testbench signals
    reg  [N-1:0] in1, in2;
    reg           swap_en;
    wire [N-1:0] out1, out2;

    // Instantiate the DUT (Device Under Test)
    data_swapper #(.N(N)) uut (
        .in1(in1),
        .in2(in2),
        .swap_en(swap_en),
        .out1(out1),
        .out2(out2)
    );

    // Test process
    initial begin
        $display("Time\t swap_en in1  in2  -> out1 out2");
        $display("====================================");

        // Case 1: Không hoán đổi
        in1 = 8'hAA;  // 10101010
        in2 = 8'h55;  // 01010101
        swap_en = 0;
        #10;
        $display("%0dns\t %b\t %h   %h  -> %h  %h", $time, swap_en, in1, in2, out1, out2);

        // Case 2: Hoán đổi
        swap_en = 1;
        #10;
        $display("%0dns\t %b\t %h   %h  -> %h  %h", $time, swap_en, in1, in2, out1, out2);

        // Case 3: Đổi giá trị đầu vào khác
        in1 = 8'h0F;
        in2 = 8'hF0;
        swap_en = 0;
        #10;
        $display("%0dns\t %b\t %h   %h  -> %h  %h", $time, swap_en, in1, in2, out1, out2);

        swap_en = 1;
        #10;
        $display("%0dns\t %b\t %h   %h  -> %h  %h", $time, swap_en, in1, in2, out1, out2);

        $display("====================================");
        $finish;
    end

endmodule
