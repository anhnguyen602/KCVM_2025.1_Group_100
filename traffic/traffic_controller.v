module traffic_controller (
    input clk, rst_n,
    input count_done_y,  count_done_g,
    output reg count_y, count_g,
    output reg [2:0] led_traffic1,
    output reg [2:0] led_traffic2
);

    reg [1:0] cs, ns;

    localparam RED    = 3'b100,
               GREEN  = 3'b010,
               YELLOW = 3'b001;

    localparam G_R = 2'b00, 
               Y_R = 2'b01, 
               R_G = 2'b10, 
               R_Y = 2'b11; 

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cs <= G_R;
        else
            cs <= ns;
    end

    always @(cs, count_done_g, count_done_y) begin
        case (cs)
            G_R: ns = (count_done_g) ? Y_R : G_R;
            Y_R: ns = (count_done_y) ? R_G : Y_R;
            R_G: ns = (count_done_g) ? R_Y : R_G;
            R_Y: ns = (count_done_y) ? G_R : R_Y;
            default: ns = G_R;
        endcase
    end

    always @(cs) begin

        led_traffic1 = 3'b000;
        led_traffic2 = 3'b000;
        count_g = 0;
        count_y = 0;

        case (cs)
            G_R: begin
                led_traffic1 = GREEN; 
                led_traffic2 = RED;   
                count_g = 1;         
                count_y = 0;
            end
            Y_R: begin
                led_traffic1 = YELLOW;
                led_traffic2 = RED;
                count_y = 1;
                count_g = 0;
            end
            R_G: begin
                led_traffic1 = RED;
                led_traffic2 = GREEN;
                count_g = 1;
                count_y = 0;
            end
            R_Y: begin
                led_traffic1 = RED;
                led_traffic2 = YELLOW;
                count_y = 1;
                count_g = 0;
            end
            default: begin
                led_traffic1 = RED;
                led_traffic2 = RED;
                count_g = 0;
                count_y = 0;
            end
        endcase
    end
endmodule
