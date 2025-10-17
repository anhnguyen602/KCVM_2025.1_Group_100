module shift_reg_lr_rotate#(
    parameter N = 8 
)(
    input clk,
    input reset_n,
    input en,
    input right,
    input load,
    input [N - 1:0]data_i,
    output reg [N-1: 0] mem
);
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        mem <= 0;
    end
    else begin
        if (en) begin
            if (load) begin
                mem <= data_i;
            end
            else begin
                if (right) begin
                    mem[N - 1]    <= mem[0];
                    mem[N - 2: 0] <= mem[N - 1: 1];
                end
                else begin
                    mem[0]        <= mem[N - 1];
                    mem[N - 1: 1] <= mem[N - 2: 0]; 
                end
            end

        end
        else begin
        end
    end
end
endmodule