#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {clock_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clock_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {sys_clk} -source [get_ports {clock_50}] -divide_by 2 -master_clock {clock_50} [get_registers {clk_gen:clocks|sys_clk}]


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
