`timescale 1ns/1ps
module rx_tb();
reg        clk;
wire        tick;
reg        rst_n;

reg        rx;
reg  [10:0] dvsr;
reg [1:0]  data_bit_num;     
reg        stop_bit_num;     
reg        parity_en;        
reg        parity_type;     
wire        rx_done;
wire        parity_error;
wire [7:0]  rx_data;
baud_generator baud_gen(
    .clk(clk),
    .rst_n(rst_n),
    .dvsr(dvsr),
    .tick(tick)
);
uart_rx u_uart_rx (
    .clk          (clk),
    .tick         (tick),
    .rst_n        (rst_n),

    .rx           (rx),

    .data_bit_num (data_bit_num),
    .stop_bit_num (stop_bit_num),
    .parity_en    (parity_en),
    .parity_type  (parity_type),

    .rts_n        (rts_n),
    .rx_done      (rx_done),
    .parity_error (parity_error),
    .rx_data      (rx_data)
);
integer i;
 integer  data_num;
 integer stop_num;
reg [7:0] d ;  // random data;
function automatic calc_parity;
    input [7:0] data;
    input integer data_num_bit;
    input parity_type;    
    reg p;
    integer k;
    begin
        p = 0;
        for (k = 0; k < data_num; k = k + 1) p = p ^ data[k];
        calc_parity = (parity_type) ? ~p : p;
    end
endfunction
task automatic check_rx;
    input [7:0] sent;
    begin
            if (rx_data !== sent)
                $display("[ERROR] RX DATA WRONG. Expect %h, got %h at time %t",
                        sent, rx_data, $time);
            else
                $display("[OK] Data matched: %h at %t", rx_data, $time);

            if (parity_en) begin
                if (parity_error)
                    $display("[ERROR] Parity error flagged unexpectedly at %t", $time);
                else
                    $display("[OK] Parity correct at %t", $time);
          //  end
        end
    end
endtask
task automatic send_rx (input [7:0] data);
    reg expected_parity;
    begin
        case (data_bit_num)
            2'b00: data_num = 5;
            2'b01: data_num = 6;
            2'b10: data_num = 7;
            2'b11: data_num = 8;
        endcase

        case (stop_bit_num)
            1'b0: stop_num = 1;
            1'b1: stop_num = 2;
        endcase
        if (parity_en)
            expected_parity = calc_parity(data, data_num, parity_type);

        rx = 1;
        repeat(100) @(posedge clk);
        rx = 0;
        repeat (10416) @(posedge clk);
        for (i = 0; i < data_num; i = i+1) begin
            rx = data[i];
            repeat (10416) @(posedge clk);
        end
        if (parity_en) begin
            rx = expected_parity;
            repeat (10416) @(posedge clk);
        end
        repeat(stop_num) begin
            rx = 1;
            repeat (10416) @(posedge clk);
        end
    end
endtask


initial begin
    clk = 0;
    rst_n = 0;
    dvsr = 10'd651;
    rx = 1;

    data_bit_num = 2'b11;
    stop_bit_num = 1'b0;
    parity_en = 1'b1;
    parity_type = 1'b1;

    #100 rst_n = 1;

    // TEST 1: 8-bit, parity odd, 1 stop bit
    $display("=== TEST 1: 8-bit, odd parity, 1 stop ===");
    send_rx(8'hB9);
    wait(rx_done);
    check_rx(8'hB9);

    // // TEST 2: 7-bit, even parity
    // $display("=== TEST 2: 7-bit, even parity ===");
    // data_bit_num = 2'b10;
    // parity_type = 0;
    // send_rx(8'h55);
    // check_rx(8'h55);

    // // TEST 3: 6-bit, no parity
    // $display("=== TEST 3: 6-bit, no parity ===");
    // data_bit_num = 2'b01;
    // parity_en = 0;
    // send_rx(8'h2A);
    // check_rx(8'h2A);

    // // TEST 4: 5-bit, 2 stop bits
    // $display("=== TEST 4: 5-bit, 2 stop ===");
    // data_bit_num = 2'b00;
    // stop_bit_num = 1;
    // parity_en = 0;
    // send_rx(8'h12);
    // check_rx(8'h12);

    // // TEST 5: Parity sai cố ý
    // $display("=== TEST 5: FORCED PARITY ERROR ===");
    // data_bit_num = 2'b11;
    // parity_en = 1;
    // parity_type = 0;

    // fork
    //     begin
            
    //         send_rx(8'hA5);
    //     end
    //     begin
            
    //         #((1+data_num)*10416*10);   
    //         rx = ~rx; 
    //     end
    // join

    // @(posedge rx_done);
    // if (!parity_error)
    //     $display("[ERROR] DUT failed to detect parity error");
    // else
    //     $display("[OK] DUT detected parity error");

    // // TEST 6: Gửi liên tục nhiều byte
    // $display("=== TEST 6: continuous frames ===");
    // parity_en = 0;
    // repeat (5) begin
    //     d = $random;
    //     send_rx(d);
    //     check_rx(d);
    // end

    // $display("=== ALL TESTS FINISHED ===");
    $stop;
end

endmodule