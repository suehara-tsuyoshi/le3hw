## Generated SDC file "countup.sdc"

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

## DATE    "Wed Apr 14 20:20:03 2021"

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

create_clock -name {clock2} -period 50.000 -waveform { 0.000 25.000 } [get_ports {clock2}]
create_clock -name {clock} -period 1000000.000 -waveform { 0.000 500000.000 } [get_ports {clock}]
create_clock -name {reset} -period 1000000000.000 -waveform { 0.000 500000000.000 } [get_ports {reset}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {reset}] -rise_to [get_clocks {clock}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {reset}] -fall_to [get_clocks {clock}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {reset}] -rise_to [get_clocks {clock2}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {reset}] -fall_to [get_clocks {clock2}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {reset}] -rise_to [get_clocks {clock}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {reset}] -fall_to [get_clocks {clock}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {reset}] -rise_to [get_clocks {clock2}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {reset}] -fall_to [get_clocks {clock2}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clock}] -rise_to [get_clocks {reset}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clock}] -fall_to [get_clocks {reset}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clock}] -rise_to [get_clocks {clock}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clock}] -fall_to [get_clocks {clock}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clock}] -rise_to [get_clocks {clock2}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {clock}] -fall_to [get_clocks {clock2}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {clock}] -rise_to [get_clocks {reset}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clock}] -fall_to [get_clocks {reset}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clock}] -rise_to [get_clocks {clock}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clock}] -fall_to [get_clocks {clock}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clock}] -rise_to [get_clocks {clock2}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {clock}] -fall_to [get_clocks {clock2}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {clock2}] -rise_to [get_clocks {clock2}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clock2}] -fall_to [get_clocks {clock2}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clock2}] -rise_to [get_clocks {clock2}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clock2}] -fall_to [get_clocks {clock2}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



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

