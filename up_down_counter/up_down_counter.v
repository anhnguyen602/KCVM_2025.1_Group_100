module up_down_counter #(
    parameter N = 4   // Số bit của bộ đếm, mặc định là 4
)(
    input clk,        // xung clock
    input rst,        // tín hiệu reset (đưa bộ đếm về 0)
    input up_down,    // điều khiển hướng đếm: 1 = up, 0 = down
    output reg [N-1:0] count // giá trị đếm hiện tại
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 0; // reset về 0
        else if (up_down)
            count <= count + 1; // đếm lên
        else
            count <= count - 1; // đếm xuống
    end

endmodule
