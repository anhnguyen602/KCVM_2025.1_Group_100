module PRG_LSFR16 #(
    parameter RANDOM_LENGTH = 16
    )(
    input clk,
    input rst_n,
    input start,
    input [RANDOM_LENGTH-1:0] seed,
    output reg [RANDOM_LENGTH-1:0] random_num
);
    localparam [15:0] POLYNOMIAL = 16'b1110_1000_0000_0001;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            random_num <= 1;
        end else begin
            if(start) begin
                random_num <= (seed == 0)? 1 : seed;
            end else begin
                if(random_num == 0) begin
                    random_num <= 1; 
                end else begin
                    random_num <= {^(random_num & POLYNOMIAL), random_num[RANDOM_LENGTH-1:1]};
                end
            end
        end
    end
endmodule


