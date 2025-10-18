module mux8to1 (
    input [7:0] x,
    input [2:0] sel,
    output reg y
);

always @(x or sel) begin
    case (sel)
        3'b000: y = x[0];
        3'b001: y = x[1];
        3'b010: y = x[2];
        3'b011: y = x[3];
        3'b100: y = x[4];
        3'b101: y = x[5];
        3'b110: y = x[6];
        3'b111: y = x[7];
        default: y = 1'b0;
    endcase
end

endmodule
    