module posi #(
    parameter n = 4
) (
    input wire clk,
    input wire rst,
    input wire load,
    input wire serial_in,
    input wire en_o,
    output wire [n-1:0]parallel_out
);
    reg [n-1 :0 ] mem;
    always @(posedge clk, negedge rst) begin
        if(!rst) begin
            mem <= 'b0;
        end
        else begin
            if(load) mem <= {serial_in, mem[n-1 : 1]};
            else mem <= mem;
        end
    end

    assign parallel_out = en_o ? mem : 'b0; 
    
endmodule

