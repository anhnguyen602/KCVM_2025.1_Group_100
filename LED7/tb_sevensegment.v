
module tb_sevensegment;

// Khai báo các tín hiệu và biến
reg [3:0] num;      // Input cho DUT (Dùng reg vì nó bị gán trong khối initial)
wire [6:0] seg;     // Output từ DUT (Dùng wire)
integer i;          // Biến lặp (được dùng trong vòng for)

// Khởi tạo (Instantiate) DUT (Giả sử file sevensegment.v đã có)
sevensegment DUT (
    .num (num),
    .seg (seg)
);

initial begin
    $display("=== Simulation of sevensegment ===");
    $display(" num | seg (abcdefg) ");
    $display("--------------------------------");
    for (i = 0; i <= 9; i = i + 1) begin
        num = i[3:0];
        #5; // delay để tín hiệu ổn định
        $display(" %0d | %b", num, seg);
    end
    for (i = 10; i <= 15; i = i + 1) begin
        num = i[3:0];
        #5;
        $display(" %0d | %b", num, seg);
    end
    $display("--------------------------------");
    $finish;
end

// --- Phần 3: THÊM VÀO SAU (Kết thúc module) ---

endmodule