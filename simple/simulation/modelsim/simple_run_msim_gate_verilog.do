transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {simple_7_1200mv_100c_slow.vo}

vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple/simulation/modelsim {C:/Users/momon/le3hw/simple/simulation/modelsim/simple_test1.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  test1

add wave *
view structure
view signals
run -all
