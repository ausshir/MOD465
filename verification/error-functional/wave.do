onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 15 /error_tb/clk_tb
add wave -noupdate -height 15 /error_tb/reset
add wave -noupdate -height 15 /error_tb/clk_25
add wave -noupdate -height 15 /error_tb/clk_625
add wave -noupdate -height 15 /error_tb/clk_15625
add wave -noupdate -height 15 /error_tb/clk_625_en
add wave -noupdate -height 15 /error_tb/clk_15625_en
add wave -noupdate -height 15 /error_tb/phase
add wave -noupdate -height 15 /error_tb/sym_out
add wave -noupdate -height 15 /error_tb/seq_out
add wave -noupdate -height 15 /error_tb/quad_sig
add wave -noupdate -height 15 /error_tb/ref_level
add wave -noupdate -height 15 /error_tb/avg_power
add wave -noupdate -height 15 /error_tb/lfsr_counter
add wave -noupdate -height 15 /error_tb/cycle_out
add wave -noupdate -height 15 /error_tb/cycle_out_periodic
add wave -noupdate -divider {Error Outputs}
add wave -noupdate -height 15 -radix decimal /error_tb/in_phs_sig
add wave -noupdate -height 15 /error_tb/acc_dc_err_out
add wave -noupdate -height 15 /error_tb/acc_sq_err_out
add wave -noupdate -divider {Symbol Synchonizer}
add wave -noupdate -height 15 /error_tb/sym_in_delay
add wave -noupdate -height 15 /error_tb/sym_delayed
add wave -noupdate -height 15 /error_tb/sym_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19081 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 279
configure wave -valuecolwidth 100
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
WaveRestoreZoom {13975 ns} {24475 ns}
