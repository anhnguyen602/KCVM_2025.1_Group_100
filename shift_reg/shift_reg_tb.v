`timescale 1ns/1ps 
module shift_reg_tb();
parameter WIDTH = 8;
reg clk, rst_n, left_right, load;
reg [WIDTH-1:0] data_in;
wire [WIDTH-1:0] data_out;
shift_reg #(.WIDTH(WIDTH)) dut(.clk(clk), .rst_n(rst_n), .left_right(left_right), .load(load), .data_in(data_in), .data_out(data_out)
);
always #5 clk =~clk;
task load_data(input a, input  b, input [WIDTH -1:0] data);
   begin
      @(negedge clk);
      load = a;
      data_in = data;
      left_right = b;
      @(negedge clk);
      load = 0;
      $display("[%0t] Load=%b, Dir=%s, Data_in=%b, Data_out=%b",
               $time, a, (b ? "LEFT" : "RIGHT"), data, data_out);
    end
endtask
initial begin
    clk = 0;
    rst_n = 0;
    load = 1'b0;
    left_right = 1'b0;
    #10;
    rst_n =1;
    load_data(1,1,8'h3);
    #10;
    load_data(1,0,8'h4);
    #10;
    load_data(0,1,8'h11);
    #10;
    load_data(1,1,8'h45);
    #10;
    load_data(1,0,8'h0);
    #10;
    load_data(1,1,8'h50);
    #10;
    load_data(1,0,8'h32);
    #10;
    load_data(1,0,8'h34);
    #10;
    load_data(0,1,8'h07);
    #10;
    $stop;
end
endmodule