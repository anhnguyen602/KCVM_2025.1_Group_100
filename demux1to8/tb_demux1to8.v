`timescale 1ns/1ps
module tb_demux1to8;

reg x;
reg [2:0] sel;
wire [7:0] y;
integer i;

// Instance module demux1to8
demux1to8 uut (
    .x(x),
    .sel(sel),
    .y(y)
);

initial begin
    x = 1'b1;
    for (i = 0; i < 8; i = i + 1) begin
        sel = i;
        #10;
        $display("x=%b sel=%b y=%b expected=%b", x, sel, y, (8'b1 << i));
    end

    x = 1'b0;
    for (i = 0; i < 8; i = i + 1) begin
        sel = i;
        #10;
        $display("x=%b sel=%b y=%b expected=00000000", x, sel, y);
    end

    $finish;
end

endmodule
