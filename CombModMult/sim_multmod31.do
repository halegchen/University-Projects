if {[file exists work]} {
vdel -lib work -all
}

vlib  work
vmap  work  work
vlog  -work  work  ../src/multmod31_tb.sv  ../src/multmod31.sv  ../src/ee412lib.sv
vsim  -voptargs="+acc"  -t ns  work.multmod31_tb
run  -all