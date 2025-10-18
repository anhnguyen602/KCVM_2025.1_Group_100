module majority(
    input [7:0] data,
    output      detect
);

wire [1:0] sum_s0_q1, sum_s0_q2, sum_s0_q3, sum_s0_q4;
wire [2:0] sum_s1_q1, sum_s1_q2;
wire [3:0] sum_s2;

assign sum_s0_q1 = data[0] + data[1];
assign sum_s0_q2 = data[2] + data[3];
assign sum_s0_q3 = data[4] + data[5];
assign sum_s0_q4 = data[6] + data[7];

assign sum_s1_q1 = sum_s0_q1 + sum_s0_q2;
assign sum_s1_q2 = sum_s0_q3 + sum_s0_q4;

assign sum_s2    = sum_s1_q1 + sum_s1_q2;

assign detect    = (sum_s2 >= 4) ? 1 : 0;
endmodule 