vlog bit_pattern.v 
vlog bit_pattern_tb.v

vsim -voptargs=+acc bit_pattern_tb

add wave -r *
run -all