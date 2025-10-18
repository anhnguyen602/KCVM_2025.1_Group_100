
module encoder8to3_priority_tb;

// Khai báo các tín hiệu và biến
reg [7:0] tb_x;         // Input cho DUT (Device Under Test)
wire [2:0] tb_y;        // Output từ DUT
wire tb_valid;          // Output valid từ DUT

reg [2:0] expected_y;   // Giá trị y mong đợi
reg expected_valid;     // Giá trị valid mong đợi
reg [7:0] i;            // Biến lặp (được dùng trong vòng for)
reg [31:0] errors;      // Biến đếm lỗi (được dùng trong khối initial)

encoder8to3_priority DUT (
    .x (tb_x),
    .y (tb_y),
    .valid (tb_valid)
);

// Định nghĩa Task (Hàm) kiểm tra
task check (input [7:0] test_x);
begin
    tb_x = test_x;
    #1; // Đợi một chút thời gian mô phỏng

    // --- Logic tính toán GIÁ TRỊ MONG ĐỢI (Reference Model) ---
    if (tb_x == 8'b00000000) begin
        expected_valid = 1'b0;
        expected_y = 3'd0; 
    end else begin
        expected_valid = 1'b1;
        // Logic ưu tiên
        if (tb_x[7]) expected_y = 3'd7;
        else if (tb_x[6]) expected_y = 3'd6;
        else if (tb_x[5]) expected_y = 3'd5;
        else if (tb_x[4]) expected_y = 3'd4;
        else if (tb_x[3]) expected_y = 3'd3;
        else if (tb_x[2]) expected_y = 3'd2;
        else if (tb_x[1]) expected_y = 3'd1;
        else expected_y = 3'd0; // Bắt buộc phải là x[0] vì đã kiểm tra tb_x == 0
    end

    // --- So sánh kết quả ---
    if (tb_y !== expected_y || tb_valid !== expected_valid) begin
        $display("TEST FAILED for x=%b: Expected y=%d, valid=%b. Got y=%d, valid=%b", 
                  tb_x, expected_y, expected_valid, tb_y, tb_valid);
        errors = errors + 1;
    end
end
endtask

initial begin
    errors = 0;
    check(8'b00000000);
    check(8'b00000001);
    check(8'b00000010);
    check(8'b00000100);
    check(8'b00001000);
    check(8'b00010000);
    check(8'b00100000);
    check(8'b01000000);
    check(8'b10000000);
    check(8'b00010011);
    check(8'b01010110);
    check(8'b10000001);
    check(8'b01111111);
    check(8'b00011111);
    for (i = 0; i < 50; i = i + 1) begin
        check($random);
    end
    if (errors == 0) $display("ALL TESTS PASSED ✅");
    else $display("TESTS FAILED: %0d errors ❌", errors);
    $finish;
end

// --- Phần 3: THÊM VÀO SAU (Kết thúc module) ---

endmodule