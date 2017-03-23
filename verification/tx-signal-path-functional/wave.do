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
add wave -noupdate -height 15 -radix unsigned /tx_signal_path_tb/filter/count4
add wave -noupdate -height 15 -radix decimal -childformat {{{/tx_signal_path_tb/filter/bin[28]} -radix decimal} {{/tx_signal_path_tb/filter/bin[27]} -radix decimal} {{/tx_signal_path_tb/filter/bin[26]} -radix decimal} {{/tx_signal_path_tb/filter/bin[25]} -radix decimal} {{/tx_signal_path_tb/filter/bin[24]} -radix decimal} {{/tx_signal_path_tb/filter/bin[23]} -radix decimal} {{/tx_signal_path_tb/filter/bin[22]} -radix decimal} {{/tx_signal_path_tb/filter/bin[21]} -radix decimal} {{/tx_signal_path_tb/filter/bin[20]} -radix decimal} {{/tx_signal_path_tb/filter/bin[19]} -radix decimal} {{/tx_signal_path_tb/filter/bin[18]} -radix decimal} {{/tx_signal_path_tb/filter/bin[17]} -radix decimal} {{/tx_signal_path_tb/filter/bin[16]} -radix decimal} {{/tx_signal_path_tb/filter/bin[15]} -radix decimal} {{/tx_signal_path_tb/filter/bin[14]} -radix decimal} {{/tx_signal_path_tb/filter/bin[13]} -radix decimal} {{/tx_signal_path_tb/filter/bin[12]} -radix decimal} {{/tx_signal_path_tb/filter/bin[11]} -radix decimal} {{/tx_signal_path_tb/filter/bin[10]} -radix decimal} {{/tx_signal_path_tb/filter/bin[9]} -radix decimal} {{/tx_signal_path_tb/filter/bin[8]} -radix decimal} {{/tx_signal_path_tb/filter/bin[7]} -radix decimal} {{/tx_signal_path_tb/filter/bin[6]} -radix decimal} {{/tx_signal_path_tb/filter/bin[5]} -radix decimal} {{/tx_signal_path_tb/filter/bin[4]} -radix decimal} {{/tx_signal_path_tb/filter/bin[3]} -radix decimal} {{/tx_signal_path_tb/filter/bin[2]} -radix decimal} {{/tx_signal_path_tb/filter/bin[1]} -radix decimal} {{/tx_signal_path_tb/filter/bin[0]} -radix decimal}} -subitemconfig {{/tx_signal_path_tb/filter/bin[28]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[27]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[26]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[25]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[24]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[23]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[22]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[21]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[20]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[19]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[18]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[17]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[16]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[15]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[14]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[13]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[12]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[11]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[10]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[9]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[8]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[7]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[6]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[5]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[4]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[3]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[2]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[1]} {-height 15 -radix decimal} {/tx_signal_path_tb/filter/bin[0]} {-height 15 -radix decimal}} /tx_signal_path_tb/filter/bin
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/cycle_out
add wave -noupdate -format Analog-Step -height 84 -max 50256.0 -min -40025.0 -radix decimal /tx_signal_path_tb/channel
add wave -noupdate -format Analog-Step -height 84 -max 24576.0 -min -24576.0 -radix decimal /tx_signal_path_tb/quad_sig
add wave -noupdate -height 15 /tx_signal_path_tb/filter/in
add wave -noupdate -height 15 /tx_signal_path_tb/filter/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {831 ns} 0}
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
WaveRestoreZoom {0 ns} {32816 ns}
