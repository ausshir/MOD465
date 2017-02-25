create_clock -name "input_clock" -period 20.000 [get_ports {clock_50}]
create_generated_clock -divide_by 2  -source [get_ports {clock_50}] -name sys_clock [get_ports {sys_clk}]
create_generated_clock -divide_by 8  -source [get_ports {clock_50}] -name sam_clock [get_ports {sam_clk}]
create_generated_clock -divide_by 32 -source [get_ports {clock_50}] -name sym_clock [get_ports {sym_clk}]
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
