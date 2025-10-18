module encoder8to3_priority (
    input [7:0] x,
    output reg [2:0] y,
    output valid
);

assign valid = |x;

always @(x) begin
    if (x[7]) y = 3'd7;
    else if (x[6]) y = 3'd6;
    else if (x[5]) y = 3'd5;
    else if (x[4]) y = 3'd4;
    else if (x[3]) y = 3'd3;
    else if (x[2]) y = 3'd2;
    else if (x[1]) y = 3'd1;
    else if (x[0]) y = 3'd0;
    else y = 3'd0;
end

endmodule