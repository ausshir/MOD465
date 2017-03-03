## Generated SDC file "deliverable_3_clocks.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Full Version"

## DATE    "Fri Mar  3 14:49:41 2017"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {clock_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clock_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {sys_clk} -source [get_ports {clock_50}] -divide_by 2 -master_clock {clock_50} [get_registers {clk_gen:clk_gen_mod|sys_clk}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clock_50}] -rise_to [get_clocks {clock_50}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clock_50}] -fall_to [get_clocks {clock_50}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clock_50}] -rise_to [get_clocks {clock_50}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clock_50}] -fall_to [get_clocks {clock_50}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clock_50}] -rise_to [get_clocks {sys_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clock_50}] -fall_to [get_clocks {sys_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clock_50}] -rise_to [get_clocks {sys_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clock_50}] -fall_to [get_clocks {sys_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {sys_clk}] -rise_to [get_clocks {clock_50}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {sys_clk}] -fall_to [get_clocks {clock_50}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {sys_clk}] -rise_to [get_clocks {sys_clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {sys_clk}] -fall_to [get_clocks {sys_clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {sys_clk}] -rise_to [get_clocks {clock_50}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {sys_clk}] -fall_to [get_clocks {clock_50}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {sys_clk}] -rise_to [get_clocks {sys_clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {sys_clk}] -fall_to [get_clocks {sys_clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



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

