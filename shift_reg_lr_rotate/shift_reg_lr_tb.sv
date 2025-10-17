`timescale 1ns/1ps

module tb_shift_reg_lr_rotate;
  // Tham số
  localparam int N = 8;

  // Tín hiệu TB
  reg              clk;
  reg              reset_n;
  reg              en;
  reg              right;
  reg              load;
  reg  [N-1:0]     data_i;
  wire [N-1:0]     mem;

  // DUT
  shift_reg_lr_rotate #(.N(N)) dut (
    .clk(clk),
    .reset_n(reset_n),
    .en(en),
    .right(right),
    .load(load),
    .data_i(data_i),
    .mem(mem)
  );

  // Tạo clock 10ns
  initial clk = 0;
  always #5 clk = ~clk;

  // Mô hình vàng (golden) trong TB để so khớp
  reg [N-1:0] golden;

  // Hàm xoay phải/trái 1 bit
  function [N-1:0] rot_right(input [N-1:0] x);
    rot_right = {x[0], x[N-1:1]};
  endfunction

  function [N-1:0] rot_left(input [N-1:0] x);
    rot_left = {x[N-2:0], x[N-1]};
  endfunction

  // Nhiệm vụ: chờ rising edge và so khớp
  task step_and_check(string tag);
    begin
      @(posedge clk);
      #1; // nhỏ để ổn định
      if (mem !== golden) begin
        $display("[%0t] ERROR (%s): mem=%b, golden=%b", $time, tag, mem, golden);
        $fatal;
      end else begin
        $display("[%0t] PASS  (%s): mem=%b", $time, tag, mem);
      end
    end
  endtask

  // Dump sóng


  // Kịch bản kiểm thử
  initial begin
    // Khởi tạo
    en      = 0;
    right   = 0;
    load    = 0;
    data_i  = 8'h00;
    reset_n = 0;
    golden  = '0;

    // Reset
    repeat (2) @(posedge clk);
    reset_n = 1;
    step_and_check("after_reset"); // mem phải = 0

    // LOAD có ưu tiên
    data_i = 8'b1010_1100; // AC
    load   = 1;
    en     = 1;
    golden  = 8'b1010_1100;
    step_and_check("load_1");
    load   = 0;

    // Giữ nguyên khi en=0
    en = 0;
    step_and_check("hold_en0");
    step_and_check("hold_en0_again");

    // Shift right (rotate) 3 lần
    en    = 1;
    right = 1;
    repeat (3) begin
      golden = rot_right(golden);
      step_and_check("rotate_right");
    end

    // Shift left (rotate) 4 lần
    right = 0;
    repeat (4) begin
      golden = rot_left(golden);
      step_and_check("rotate_left");
    end

    // Ưu tiên load khi đang shift
    right  = 1;
    load   = 1;
    data_i = 8'b0110_0001; // 0x61
    golden = data_i;
    step_and_check("load_priority_over_shift");
    load = 0;

    // Thử xen kẽ en=0 trong khi right=1
    en = 0;
    step_and_check("no_change_when_en0_mid_shift");
    en = 1;
    golden = rot_right(golden);
    step_and_check("rotate_right_after_en1");

    $display("All tests passed!");
    $finish;
  end

endmodule
