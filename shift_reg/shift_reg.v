module shift_reg #(parameter WIDTH = 8 ) (
    input clk,
    input rst_n,
    input left_right,
    input load ,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out

);
always @(posedge clk) begin
    if(!rst_n) begin
        data_out <= 0;
    end else begin 
        if(load) begin
            if(left_right) begin
                data_out <= data_in << 1;
            end else begin
                data_out <= data_in >> 1;
            end
        end else begin
            data_out <= data_out;
        end
    end
end
endmodule