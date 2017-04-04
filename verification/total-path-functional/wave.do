onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {System Signals}
add wave -noupdate -height 15 /total_path_tb/clk_tb
add wave -noupdate -height 15 /total_path_tb/reset
add wave -noupdate -height 15 /total_path_tb/sys_clk
add wave -noupdate -height 15 /total_path_tb/sam_clk
add wave -noupdate -height 15 /total_path_tb/sym_clk
add wave -noupdate -height 15 /total_path_tb/hb_clk_en
add wave -noupdate -height 15 /total_path_tb/sam_clk_en
add wave -noupdate -height 15 /total_path_tb/sym_clk_en
add wave -noupdate -height 15 /total_path_tb/phase
add wave -noupdate -height 15 /total_path_tb/tx_data
add wave -noupdate -height 15 -radix unsigned /total_path_tb/seq_out
add wave -noupdate -height 15 /total_path_tb/cycle_out_once
add wave -noupdate -height 15 /total_path_tb/cycle_out_periodic
add wave -noupdate -height 15 /total_path_tb/cycle_out_periodic_ahead
add wave -noupdate -height 15 /total_path_tb/cycle_out_periodic_behind
add wave -noupdate -height 15 -radix unsigned /total_path_tb/lfsr_counter
add wave -noupdate -height 15 -radix unsigned /total_path_tb/lfsr_tb/lfsr_cycle_counter
add wave -noupdate -divider -height 25 {TX Signals}
add wave -noupdate -clampanalog 1 -format Analog-Step -height 74 -max 131071.0 -min -131071.0 /total_path_tb/tx_inph/tx_sig
add wave -noupdate -clampanalog 1 -format Analog-Step -height 74 -max 131071.0 -min -131071.0 /total_path_tb/tx_inph/tx_up
add wave -noupdate -clampanalog 1 -format Analog-Step -height 74 -max 79727.000000000015 -min -76556.0 /total_path_tb/tx_inph/tx_srrc
add wave -noupdate -format Analog-Step -height 74 -max 92087.999999999985 -min -93668.0 /total_path_tb/tx_inph/tx_up_hba
add wave -noupdate -format Analog-Step -height 74 -max 46043.999999999993 -min -46834.0 /total_path_tb/tx_inph/tx_hb_hba
add wave -noupdate -format Analog-Step -height 74 -max 46043.999999999993 -min -46834.0 /total_path_tb/tx_inph/tx_up_hbb
add wave -noupdate -format Analog-Step -height 74 -max 23021.999999999996 -min -23417.0 /total_path_tb/tx_inph/tx_hb_hbb
add wave -noupdate -height 15 /total_path_tb/tx_out_inph
add wave -noupdate -height 15 /total_path_tb/tx_out_quad
add wave -noupdate -divider -height 25 Channel
add wave -noupdate -height 15 /total_path_tb/tx_channel
add wave -noupdate -format Analog-Step -height 74 -max 104702.0 -min -102332.0 /total_path_tb/rx_up_inph
add wave -noupdate -height 15 /total_path_tb/tx_inph/tx_up_hbb
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
add wave -noupdate /total_path_tb/acc_sq_err_inph
add wave -noupdate /total_path_tb/acc_sq_err_full_inph
add wave -noupdate /total_path_tb/acc_dc_err_inph
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7662527 ns} 0} {{Cursor 2} {195730 ns} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {250477 ns} {513133 ns}
