onerror {resume}
quietly virtual signal -install /tx_signal_path_tb { /tx_signal_path_tb/phase[3:2]} phase32
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Filter Internal Data}
add wave -noupdate -divider {Multiplier Filter Internal Data}
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/clk_tb
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/reset
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/clk_25
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/clk_625
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/clk_15625
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/clk_625_en
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/clk_15625_en
add wave -noupdate -height 15 -radix unsigned -childformat {{{/tx_signal_path_tb/phase[3]} -radix unsigned} {{/tx_signal_path_tb/phase[2]} -radix unsigned} {{/tx_signal_path_tb/phase[1]} -radix unsigned} {{/tx_signal_path_tb/phase[0]} -radix unsigned}} -subitemconfig {{/tx_signal_path_tb/phase[3]} {-height 15 -radix unsigned} {/tx_signal_path_tb/phase[2]} {-height 15 -radix unsigned} {/tx_signal_path_tb/phase[1]} {-height 15 -radix unsigned} {/tx_signal_path_tb/phase[0]} {-height 15 -radix unsigned}} /tx_signal_path_tb/phase
add wave -noupdate -height 15 -radix unsigned /tx_signal_path_tb/phase32
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/sym_out
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/seq_out
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/in_phs_sig
add wave -noupdate -format Analog-Step -height 84 -max 49151.0 -min -49151.0 -radix decimal /tx_signal_path_tb/upsampled_sig
add wave -noupdate -format Analog-Step -height 84 -max 49151.0 -min -49151.0 -radix decimal /tx_signal_path_tb/filter/in_reg
add wave -noupdate -height 15 -radix unsigned /tx_signal_path_tb/filter/count4
add wave -noupdate -format Analog-Step -height 84 -max 50256.0 -min -40025.0 -radix decimal /tx_signal_path_tb/channel
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/filter/bin
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/cycle_out
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/quad_sig
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10210 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 357
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
WaveRestoreZoom {0 ns} {65626 ns}
