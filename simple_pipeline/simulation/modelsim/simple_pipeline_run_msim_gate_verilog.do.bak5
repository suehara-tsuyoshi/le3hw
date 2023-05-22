transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {simple_pipeline_7_1200mv_100c_slow.vo}

vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/17.1/le3hw/simple/simple-team25/simple_pipeline/simulation/modelsim {C:/intelFPGA_lite/17.1/le3hw/simple/simple-team25/simple_pipeline/simulation/modelsim/test1.vt}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  simple_pipeline_vlg_tst

add wave *
view structure
view signals
run 1000 ns
