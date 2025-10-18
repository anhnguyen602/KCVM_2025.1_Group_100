module data_swapper #(
    parameter N = 8   // Độ rộng dữ liệu (bit)
)(
    input  [N-1:0] in1,  // Đầu vào 1
    input  [N-1:0] in2,  // Đầu vào 2
    input          swap_en, // Tín hiệu điều khiển hoán đổi
    output [N-1:0] out1, // Đầu ra 1
    output [N-1:0] out2  // Đầu ra 2
);

    assign out1 = (swap_en) ? in2 : in1;
    assign out2 = (swap_en) ? in1 : in2;

endmodule
