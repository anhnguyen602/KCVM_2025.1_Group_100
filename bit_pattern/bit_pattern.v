module bit_pattern (
    input clk,
    input rst_n,
    input  data,
    output reg detect
);
parameter IDLE = 3'b000;
parameter S1 = 3'b001;
parameter S10 = 3'b010;
parameter S101 = 3'b011;
reg [2:0] cs ,ns;
always @(posedge clk) begin
    if(!rst_n) begin
        cs <= 0;
    end else begin
        cs <= ns;
    end
end
always @(data or cs) begin
    detect = 1'b0;
    case(cs) 
        IDLE: begin
            if(data) begin
                ns = S1;
            end else begin
                ns = IDLE;
            end
        end
        S1: begin
            if(data) begin
                ns = S1;
            end else begin
                ns = S10;
            end
        end
        S10: begin
            if(data) begin
                ns = S101;
            end else begin
                ns = IDLE;
            end
        end
        S101: begin
            if(data) begin
                ns = S1;
                detect = 1'b1;
            end else begin
                ns = S10;
            end
        end
         default: ns = IDLE;
    endcase
end
endmodule