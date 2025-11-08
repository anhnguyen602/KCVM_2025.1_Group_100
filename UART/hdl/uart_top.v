module uart_top#(parameter baurate = 9600,
                            clk_hz = 100000000)(
    input           clk, 
    input           rst_n,


    input [1:0]     data_bit_num,
    input           stop_bit_num,
    input           parity_en,
    input           parity_type,

    input           start_tx,
    output          tx_done,
    input [7:0]     tx_data,

    output[7:0]     rx_data,
    output          rx_done,
    output          parity_error,


    input           rx,
    input           cts_n,
    output          tx,
    output          rts_n
);
localparam dvsr = clk_hz / ((baurate + 1) * 16);

wire       tick;

baud_generator baud_generator_inst(
    .clk            (clk),
    .rst_n          (rst_n),
    .dvsr           (dvsr),
    .tick           (tick)
);
uart_tx uart_tx_inst(
    .clk            (clk),
    .rst_n          (rst_n),
    .tick           (tick),
    .tx_data        (tx_data),
    .start_tx       (start_tx),
    .data_bit_num   (data_bit_num),
    .stop_bit_num   (stop_bit_num),
    .parity_en      (parity_en),
    .parity_type    (parity_type),
    .cts_n          (cts_n),
    .tx             (tx),
    .tx_done        (tx_done)
);
uart_rx uart_rx_inst(
    .clk            (clk),
    .rst_n          (rst_n),
    .tick           (tick),
    .rx             (rx),
    .data_bit_num   (data_bit_num),
    .stop_bit_num   (stop_bit_num),
    .parity_en      (parity_en),
    .parity_type    (parity_type),  
    .rx_data        (rx_data),
    .rx_done        (rx_done),
    .rts_n          (rts_n),
    .parity_error   (parity_error)
);


endmodule