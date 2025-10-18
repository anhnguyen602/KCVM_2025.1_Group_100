module piso #(
    parameter n = 4
) (
    input wire clk,
    input wire rst,
    input wire load,
    input wire  [n-1:0]parallel_in ,
    output wire serial_out
);
    
    reg [n-1:0]shift_reg ;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            shift_reg <= 'b0;
        end else if (load) begin
            shift_reg <= parallel_in;
        end else begin
            shift_reg <= { 1'b0,shift_reg[n-1:1]}; // Shift left and fill LSB with 0
        end 
    end

assign serial_out = load ? 1'b0 : shift_reg[0];
    
endmodule

