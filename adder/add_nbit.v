module full_adder (
    input a, b, cin,
    output sum, cout
);
    assign sum = (a ^ b) ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule



module sub_nbit #(
    parameter n = 8
) (
    input  signed [n-1:0] a, b,
    output signed [n:0] sum
);
    wire [n:0] carry;   // carry[0] = cin, carry[n] = carry_out
    assign carry[0] = 1'b0;
    wire signed [n-1:0] b_sub;
    assign b_sub = ~b + 1'b1;

    genvar i;
    generate
        for (i = 0; i < n; i = i + 1) begin : add
            full_adder fa (
                .a(a[i]),
                .b(b_sub[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    //assign sum = (a[n-1] == b [n-1])? {carry[n],sum[n-1 : 1]} : ~({carry[n],sum[n-1 : 1]});
    assign sum[n] =  a[n-1] ^ b_sub[n-1] ^ carry[n]; // chỉ thêm carry cuối cùng
endmodule

module add_nbit #(
    parameter n = 8
) (
    input  signed [n-1:0] a, b,
    output signed [n:0] sum
);
    wire [n:0] carry;   // carry[0] = cin, carry[n] = carry_out
    assign carry[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < n; i = i + 1) begin : add
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    //assign sum = (a[n-1] == b [n-1])? {carry[n],sum[n-1 : 1]} : ~({carry[n],sum[n-1 : 1]});
    assign sum[n] =  a[n-1] ^ b[n-1] ^ carry[n]; // chỉ thêm carry cuối cùng
endmodule