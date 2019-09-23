if {[file exists work]} {
	vdel -lib work -all
}
vlib  work
vmap  work  work
vlog  -work  work  ../src/*.sv
vsim  -voptargs="+acc"  -t ns  work.noise_tb
do wave.do
run  -all
