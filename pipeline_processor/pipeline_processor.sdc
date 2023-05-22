## Generated SDC file "pipeline_processor.sdc"

## Copyright (C) 2017  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 17.1.0 Build 590 10/25/2017 SJ Lite Edition"

## DATE    "Fri May 14 13:56:34 2021"

##
## DEVICE  "EP4CE30F23I7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

# create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {clock_20MHz} -period 50.000 -waveform { 0.000 25.000 } [get_ports {clock}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clock_20MHz}] -rise_to [get_clocks {clock_20MHz}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clock_20MHz}] -fall_to [get_clocks {clock_20MHz}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clock_20MHz}] -rise_to [get_clocks {clock_20MHz}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clock_20MHz}] -fall_to [get_clocks {clock_20MHz}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {altera_reserved_tck}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {altera_reserved_tdi}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {altera_reserved_tms}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {clock}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {exec}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[0]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[1]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[2]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[3]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[4]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[5]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[6]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[7]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[8]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[9]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[10]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[11]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[12]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[13]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[14]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {outside_input[15]}]
set_input_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {reset}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {altera_reserved_tdo}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[0]}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[1]}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[2]}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[3]}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[4]}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[5]}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[6]}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[7]}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[8]}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[9]}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[10]}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[11]}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[12]}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[13]}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[14]}]
set_output_delay -add_delay  -clock [get_clocks {clock_20MHz}]  0.000 [get_ports {data_for_output[15]}]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

