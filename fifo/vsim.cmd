vlog fifo.v
vlog fifo_tb.v

vsim -voptargs=+acc fifo_tb

add wave -r *
run -all