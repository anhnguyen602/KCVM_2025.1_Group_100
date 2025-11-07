module uart_rx(
    input               clk,
    input               tick,
    input               rst_n,

    input               rx,

    input [1:0]         data_bit_num,
    input               stop_bit_num,
    input               parity_en,
    input               parity_type,


    output reg        rts_n,

    output reg        rx_done,
    output reg        parity_error,
    output reg [7:0]  rx_data
);
parameter IDLE   = 3'b000;
parameter START  = 3'b001;
parameter DATA   = 3'b010;
parameter PARITY = 3'b011;
parameter STOP   = 3'b100;


reg [2:0] current_state, next_state;

reg [3:0] num_data;
reg [1:0] num_stop;
reg [3:0] count_data;
reg [1:0] count_stop;
reg [4:0] tick_cnt;
reg [7:0] rx_shift;
reg parity_calc, parity_bit;
reg parity_en_reg, parity_type_reg;


always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        num_data <= 0;
    end
    else begin
        if (current_state == IDLE && !rx) begin
            case (data_bit_num)
                2'b00: num_data <= 5;
                2'b01: num_data <= 6;
                2'b10: num_data <= 7;
                2'b11: num_data <= 8;
                default: num_data <= 5;
            endcase
        end
        else begin
        end
        
    end
end

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        parity_en_reg <= 0;
    end
    else begin
        if (current_state == IDLE && !rx) begin
            parity_en_reg <= parity_en;
        end
        else begin
        end
    end
end
always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        parity_type_reg <= 0;
    end
    else begin
        if (current_state == IDLE && !rx) begin
            parity_type_reg <= parity_type;
        end
        else begin
        end
    end
end

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        num_stop <= 0;
    end
    else begin
        if (current_state == IDLE && !rx) begin
            if (stop_bit_num) begin
                num_stop <= 2;
            end
            else begin
                num_stop <= 1;
            end
        end
        else begin
        end
    end
end

// Next state logic
always@(rx, current_state, tick, tick_cnt, count_data, count_stop) begin
    //next_state = current_state;
    case (current_state)
        IDLE: begin
            if (~rx) next_state = START;
            else begin 
                next_state = IDLE;
            end
        end
        START: begin
            if (tick && tick_cnt == 7)
                next_state = DATA;
            else begin
                next_state = START;
            end
        end
        DATA: begin
            if (tick && tick_cnt == 15 && count_data == num_data - 1)
                next_state = (parity_en_reg) ? PARITY : STOP;
            else begin
                next_state = DATA;
            end
        end
        PARITY: begin
            if (tick && tick_cnt == 15)
                next_state = STOP;
            else begin
                next_state = PARITY;
            end
        end
        STOP: begin
            if (tick && tick_cnt == 15 && count_stop == num_stop - 1)
                next_state = IDLE;
            else begin
                next_state = STOP;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// State transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end
always@(current_state, next_state) begin
    case (current_state) 
        IDLE: begin
            rts_n = 0;
            rx_done = 0;
        end
        START: begin
            rts_n = 1;
            rx_done = 0;
        end
        DATA:  begin
            rts_n = 1;
            rx_done = 0;
        end
        PARITY:  begin
            rts_n = 1;
            rx_done = 0;
        end
        STOP: begin
            if (next_state == IDLE) begin
                rx_done = 1;
                rts_n = 0;
            end
            else begin
                rx_done = 0;
                rts_n = 1;
            end
        end
        default:   begin 
            rts_n = 1;
            rx_done = 0;
        end
    endcase
end


// Output and internal logic
always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        tick_cnt <= 0;
        count_data <= 0;
        count_stop <= 0;
        rx_shift <= 0;
        parity_calc <= 0;
        //parity_bit <= 0;
        parity_error <= 0;
        rx_data <= 0;
    end else begin
        if (tick) begin
            if (current_state != IDLE && tick_cnt == 15)
                tick_cnt <= 0;
            else if (current_state != IDLE)
                tick_cnt <= tick_cnt + 1;

            case (current_state)
                START: begin
                    if (next_state == DATA) begin
                        tick_cnt <= 0;
                    end
                end

                DATA: begin
                    if (tick_cnt == 15) begin
                        rx_shift[count_data] <= rx;
                        count_data <= count_data + 1;
                        // tinh toan parity_bit de so sanh voi rx nhan vao sau
                        if (parity_type_reg) begin
                            parity_calc <= parity_calc ^ rx;
                        end
                        else parity_calc <= ~(parity_calc ^ rx);
                    end
                end

                PARITY: begin
                    if (tick_cnt == 15) begin
                        //parity_bit <= (parity_type) ? ~parity_calc : parity_calc;
                        parity_error <= (rx != parity_calc);
                    end
                end

                STOP: begin
                    if (tick_cnt == 15) begin
                        count_stop <= count_stop + 1;
                        if (count_stop == num_stop - 1) begin 
                            rx_data <= rx_shift;
                        end
                        else begin end
                    end
                    else begin end
                end

                IDLE: begin
                    tick_cnt <= 0;
                    count_data <= 0;
                    count_stop <= 0;
                    rx_shift <= 0;
                    parity_calc <= 0;
                    parity_error <= 0;
                end
            endcase
        end
    end
end
endmodule
