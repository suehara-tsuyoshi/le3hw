transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple {C:/Users/momon/le3hw/simple/simple.v}
vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple {C:/Users/momon/le3hw/simple/p1_fetch.v}
vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple {C:/Users/momon/le3hw/simple/p2_decode.v}
vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple {C:/Users/momon/le3hw/simple/p3_exec.v}
vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple {C:/Users/momon/le3hw/simple/p4_mem_access.v}
vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple {C:/Users/momon/le3hw/simple/p5_write_back.v}
vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple {C:/Users/momon/le3hw/simple/alu.v}
vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple {C:/Users/momon/le3hw/simple/mux4_16bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple {C:/Users/momon/le3hw/simple/mux4_4bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple {C:/Users/momon/le3hw/simple/control_unit.v}
vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple {C:/Users/momon/le3hw/simple/main_memory.v}
vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple {C:/Users/momon/le3hw/simple/mux2_16bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple {C:/Users/momon/le3hw/simple/mux4_1bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple {C:/Users/momon/le3hw/simple/mux2_3bit.v}

vlog -vlog01compat -work work +incdir+C:/Users/momon/le3hw/simple/simulation/modelsim {C:/Users/momon/le3hw/simple/simulation/modelsim/simple_test1.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  test1

add wave *
view structure
view signals
run -all
