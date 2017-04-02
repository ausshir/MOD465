onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {System Signals}
add wave -noupdate /total_path_tb/clk_tb
add wave -noupdate /total_path_tb/reset
add wave -noupdate /total_path_tb/sys_clk
add wave -noupdate /total_path_tb/sam_clk
add wave -noupdate /total_path_tb/sym_clk
add wave -noupdate /total_path_tb/sam_clk_en
add wave -noupdate /total_path_tb/sym_clk_en
add wave -noupdate /total_path_tb/phase
add wave -noupdate /total_path_tb/tx_data
add wave -noupdate -radix unsigned /total_path_tb/seq_out
add wave -noupdate /total_path_tb/cycle_out_once
add wave -noupdate /total_path_tb/cycle_out_periodic
add wave -noupdate /total_path_tb/cycle_out_periodic_ahead
add wave -noupdate /total_path_tb/cycle_out_periodic_behind
add wave -noupdate -radix unsigned /total_path_tb/lfsr_counter
add wave -noupdate -radix unsigned /total_path_tb/lfsr_tb/lfsr_cycle_counter
add wave -noupdate -divider -height 25 {TX Signals}
add wave -noupdate -clampanalog 1 -format Analog-Step -height 74 -max 131071.0 -min -131071.0 /total_path_tb/tx_inph/tx_sig
add wave -noupdate -clampanalog 1 -format Analog-Step -height 74 -max 131071.0 -min -131071.0 /total_path_tb/tx_inph/tx_up
add wave -noupdate -clampanalog 1 -format Analog-Step -height 74 -max 79727.000000000015 -min -76556.0 /total_path_tb/tx_inph/tx_srrc
add wave -noupdate -divider -height 25 Channel
add wave -noupdate -clampanalog 1 -format Analog-Step -height 75 -max 79727.0 -min -79727.0 /total_path_tb/tx_inph/tx_channel
add wave -noupdate -format Analog-Step -height 74 -max 104702.0 -min -102332.0 /total_path_tb/rx_up_inph
add wave -noupdate -divider -height 25 Alignment
add wave -noupdate -format Analog-Step -height 74 -max 104702.0 -min -102332.0 /total_path_tb/rx_up_sync_inph
add wave -noupdate -format Analog-Step -height 74 -max 131071.0 -min -131071.0 /total_path_tb/tx_sig_delay_inph
add wave -noupdate /total_path_tb/tx_data_delay_inph
add wave -noupdate -divider -height 25 {RX Signals}
add wave -noupdate -clampanalog 1 -radix binary /total_path_tb/rx_inph/rx_data
add wave -noupdate -clampanalog 1 -format Analog-Step -height 74 -max 69886.999999999985 -min -70053.0 /total_path_tb/rx_inph/rx_down
add wave -noupdate -clampanalog 1 -format Analog-Step -height 74 -max 66687.0 -min -66687.0 /total_path_tb/rx_inph/rx_remapped
add wave -noupdate -divider Performance
add wave -noupdate /total_path_tb/ref_level_inph
add wave -noupdate /total_path_tb/avg_power_inph
add wave -noupdate /total_path_tb/acc_err_sq_inph
add wave -noupdate /total_path_tb/acc_err_dc_inph
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {215810 ns} 0} {{Cursor 2} {0 ns} 0}
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
WaveRestoreZoom {9858 ns} {537922 ns}
