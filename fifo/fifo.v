module fifo #(
    parameter WIDTH =16,
    parameter LENGTH =8
)(
    input clk,
    input reset_n,
    input write_en,
    input read_en,
    input [WIDTH-1:0] data_in,
    output   full,
    output   empty,
    output  [WIDTH-1:0] data_out
);
    reg [WIDTH-1:0] register [LENGTH-1:0];
    reg [$clog2(LENGTH)-1:0] pointer_in_next;
    reg [$clog2(LENGTH)-1:0] pointer_out_next;
    reg [$clog2(LENGTH)-1:0] pointer_in;
    reg [$clog2(LENGTH)-1:0] pointer_out;



assign empty = (pointer_in == pointer_out);
assign full = (pointer_in == (pointer_out-1));
always @(write_en or full or pointer_in) begin 
        if(write_en & ~full) begin
            pointer_in_next = pointer_in +1;
        end
        else begin
            pointer_in_next = pointer_in;
        end
end

always @(read_en or empty or pointer_out) begin
    if(read_en & ~empty) begin
            pointer_out_next = pointer_out + 1;
        end
        else begin
            pointer_out_next = pointer_out;
        end
end

always @(posedge clk, negedge reset_n) begin
        if(~reset_n) begin
          //  register <= 'b0;
            pointer_in <= 4'h0;
            pointer_out <= 4'h0;
        end
        else begin
            pointer_in <= pointer_in_next;
            pointer_out <= pointer_out_next;
            if(write_en) begin
               register[pointer_in] <= data_in;

            end
            else begin
                register[pointer_in] <= register [pointer_in];
            end
        end
end
assign data_out = (read_en)? register [pointer_out]: 'h0;

endmodule