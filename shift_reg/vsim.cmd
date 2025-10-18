vlog shift_reg.v 
vlog shift_reg_tb.v 

vsim -voptargs=+acc shift_reg_tb
add wave -r *
run -all 

