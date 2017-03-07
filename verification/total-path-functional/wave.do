onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {System Signals}
add wave -noupdate -height 15 /total_path_tb/clk_tb
add wave -noupdate -height 15 /total_path_tb/reset
add wave -noupdate -height 15 /total_path_tb/sys_clk
add wave -noupdate -height 15 /total_path_tb/sam_clk
add wave -noupdate -height 15 /total_path_tb/sym_clk
add wave -noupdate -height 15 /total_path_tb/sam_clk_en
add wave -noupdate -height 15 /total_path_tb/sym_clk_en
add wave -noupdate -height 15 /total_path_tb/phase
add wave -noupdate -height 15 /total_path_tb/tx_data
add wave -noupdate -height 15 /total_path_tb/seq_out
add wave -noupdate -height 15 /total_path_tb/cycle_out_once
add wave -noupdate -height 15 /total_path_tb/cycle_out_periodic
add wave -noupdate -height 15 /total_path_tb/cycle_out_periodic_ahead
add wave -noupdate -height 15 /total_path_tb/cycle_out_periodic_behind
add wave -noupdate -height 15 /total_path_tb/lfsr_counter
add wave -noupdate -divider {Signal Path}
add wave -noupdate -format Analog-Step -height 84 -max 131071.00000000001 -min -131071.0 /total_path_tb/tx_sig_inphase
add wave -noupdate -format Analog-Step -height 84 -max 131071.00000000001 -min -131071.0 /total_path_tb/tx_up_inphase
add wave -noupdate -format Analog-Step -height 84 -max 107637.0 -min -95101.0 /total_path_tb/tx_chan_inphase
add wave -noupdate -format Analog-Step -height 84 -max 130976.99999999999 -min -131050.0 /total_path_tb/rx_up_inphase
add wave -noupdate -divider Synchronization
add wave -noupdate -height 15 /total_path_tb/sam_clk_en
add wave -noupdate -height 15 /total_path_tb/sym_clk_en
add wave -noupdate -format Analog-Step -height 84 -max 99166.999999999985 -min -94551.0 /total_path_tb/rx_up_sync_inphase
add wave -noupdate -format Analog-Step -height 84 -max 99166.999999999985 -min -94551.0 /total_path_tb/rx_inphase
add wave -noupdate -format Analog-Step -height 84 -max 131071.00000000001 -min -131071.0 -radix decimal /total_path_tb/tx_sig_sync_inphase
add wave -noupdate -divider Decoding
add wave -noupdate -height 15 /total_path_tb/rx_ref_level
add wave -noupdate -height 15 /total_path_tb/rx_avg_power
add wave -noupdate -height 15 /total_path_tb/tx_data_delay
add wave -noupdate -height 15 /total_path_tb/rx_data
add wave -noupdate -format Analog-Step -height 84 -max 64244.999999999993 -min -64245.0 /total_path_tb/rx_sig_mapped
add wave -noupdate -height 15 /total_path_tb/symbol_p2
add wave -noupdate -height 15 /total_path_tb/symbol_p1
add wave -noupdate -height 15 /total_path_tb/symbol_n1
add wave -noupdate -height 15 /total_path_tb/symbol_n2
add wave -noupdate -divider {Performance Evaluation}
add wave -noupdate -format Analog-Step -height 84 -max 65273.0 -min -65430.0 /total_path_tb/err_diff
add wave -noupdate -height 15 /total_path_tb/acc_sq_err_out
add wave -noupdate -height 15 /total_path_tb/acc_out_full
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {855650 ns} 0} {{Cursor 2} {82530 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 346
configure wave -valuecolwidth 135
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {68130 ns} {1643170 ns}
