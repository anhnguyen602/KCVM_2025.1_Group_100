module counter #(
    parameter TIME_G = 'd10,
                TIME_Y = 'd5
) (
    input clk, rst_n,
    input count_g, count_y,
    output count_done_g, count_done_y
);
    reg [3:0] count, count_nxt;
    assign count_done_g = count_g && (count == TIME_G);
    assign count_done_y = count_y && (count == TIME_Y);
    always @(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
            count <= 'b0;

        end
        else count <= count_nxt;
    end

    always @(*) begin
        if(count_done_g | count_done_y) count_nxt = 1'b0;
        else count_nxt = count + 1'b1;
    end
endmodule