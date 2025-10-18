`timescale 1ns / 1ps

module tb_majority;

reg  [7:0] data;
wire       detect;

// Instantiate DUT (Device Under Test)
majority uut (
    .data(data),
    .detect(detect)
);

integer i;
integer count;
integer count_false = 0;
initial begin
    $display("Time\tData\t\tDetect\t(Expected Majority?)");
    $display("---------------------------------------------------");

    // Test tất cả 256 giá trị đầu vào
    for (i = 0; i < 256; i = i + 1) begin
        data = i;
        #5; // đợi 5ns để tín hiệu ổn định
        
        // Đếm số bit 1 trong data

        count = data[0] + data[1] + data[2] + data[3] + data[4] + data[5] + data[6] + data[7];

        // In kết quả
        $display("%0t\t%b\t%b\t(%0d ones)", $time, data, detect, count);
        
        // Kiểm tra kết quả đúng/sai (tùy chọn)
        if (detect !== (count >= 4)) begin
            $display("❌ Error at data = %b (count = %0d)", data, count);
            count_false = count_false + 1;
        end
            
    end
    if (count_false == 0) begin
        $display("Simulation success!");
    end
    $display("---------------------------------------------------");
    $display("Simulation finished!");
    $finish;
end

endmodule
