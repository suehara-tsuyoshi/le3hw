transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {simple_ver2_7_1200mv_100c_slow.vo}

vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple_ver2/simulation/modelsim {C:/Users/momon/le3hw/simple_ver2/simulation/modelsim/simple_ver2_test1.vt}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  simple_ver2_vlg_tst

add wave *
view structure
view signals
run 2500 ns
