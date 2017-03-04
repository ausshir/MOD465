#create_clock -name "sys_clk" -period 20.000ns [get_ports {clock_50}]
#derive_pll_clocks -create_base_clocks
#derive_clock_uncertainty

create_clock -name clock_50 -period 20.000 [get_ports {clock_50}]

create_generated_clock -divide_by 2  -source [get_ports {clock_50}] -name sys_clk   [get_keepers {louis_clock:louis_clock_gen|q[0]}]
create_generated_clock -divide_by 8  -source [get_ports {clock_50}] -name sam_clock [get_keepers {louis_clock:louis_clock_gen|q[2]}]
create_generated_clock -divide_by 32 -source [get_ports {clock_50}] -name sym_clock [get_keepers {louis_clock:louis_clock_gen|q[4]}]

create_generated_clock -divide_by 2  -source [get_ports {clock_50}] -name sys_clk_2 [get_registers {clk_gen:clk_gen_mod|sys_clk}]

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
