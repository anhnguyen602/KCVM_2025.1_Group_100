module traffic_top (
    input clk,
    input rst_n,
    output [2:0] led_traffic1,
    output [2:0] led_traffic2
);
    // ======= Tín hiệu kết nối giữa FSM và Counter =======
    wire count_g, count_y;
    wire count_done_g, count_done_y;

    // ======= FSM điều khiển đèn =======
    traffic_controller u_traffic (
        .clk(clk),
        .rst_n(rst_n),
        .count_done_g(count_done_g),
        .count_done_y(count_done_y),
        .count_g(count_g),
        .count_y(count_y),
        .led_traffic1(led_traffic1),
        .led_traffic2(led_traffic2)
    );

    // ======= Bộ đếm thời gian =======
    counter #(
        .TIME_G(10),    // đếm 10 chu kỳ cho đèn xanh
        .TIME_Y(5)      // đếm 5 chu kỳ cho đèn vàng
    ) u_counter (
        .clk(clk),
        .rst_n(rst_n),
        .count_g(count_g),
        .count_y(count_y),
        .count_done_g(count_done_g),
        .count_done_y(count_done_y)
    );

endmodule
