`timescale 1ns / 1ps

module tb_mux8to1;
    reg [7:0] x;
    reg [2:0] sel;
    wire y;
    integer i;

    // Gọi module cần test
    mux8to1 uut (
        .x(x),
        .sel(sel),
        .y(y)
    );

    initial begin
        x = 8'b10101010;
        for (i = 0; i < 8; i = i + 1) begin
            sel = i;
            #10;
            $display("sel=%b y=%b expected=%b", sel, y, x[sel]);
        end

        x = 8'b11001100;
        for (i = 0; i < 8; i = i + 1) begin
            sel = i;
            #10;
            $display("sel=%b y=%b expected=%b", sel, y, x[sel]);
        end

        $finish;
    end
endmodule
