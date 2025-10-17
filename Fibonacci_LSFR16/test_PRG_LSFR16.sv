module test_PRG_LSFR16;
    reg clk;
    reg rst_n;
    reg start;
    reg [15:0] seed;
    wire [15:0] random_num;
    PRG_LSFR16 #(
    .RANDOM_LENGTH(16)
    ) DUT (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .seed(seed),
    .random_num(random_num)
);

initial clk = 0;
always #5 clk = ~clk;

initial begin
    rst_n = 0;
    start = 0;
    seed = 16'd1413;
    #5;
    rst_n = 1;
    #10;
    start = 1;
    #5;
    start = 0;
    #200;
    $finish;
end

always @(random_num) begin
    $display("random_num = %d", random_num);
end

endmodule




