onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 15 /tx_signal_path_tb/clk_tb
add wave -noupdate -height 15 /tx_signal_path_tb/reset
add wave -noupdate -height 15 /tx_signal_path_tb/clk_25
add wave -noupdate -height 15 /tx_signal_path_tb/clk_625
add wave -noupdate -height 15 /tx_signal_path_tb/clk_15625
add wave -noupdate -height 15 /tx_signal_path_tb/clk_625_en
add wave -noupdate -height 15 /tx_signal_path_tb/clk_15625_en
add wave -noupdate -height 15 /tx_signal_path_tb/phase
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/sym_out
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/seq_out
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/in_phs_sig
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/quad_sig
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/upsampled_sig
add wave -noupdate -height 15 -radix decimal /tx_signal_path_tb/cycle_out
add wave -noupdate -height 15 -radix decimal -childformat {{{/tx_signal_path_tb/channel[17]} -radix decimal} {{/tx_signal_path_tb/channel[16]} -radix decimal} {{/tx_signal_path_tb/channel[15]} -radix decimal} {{/tx_signal_path_tb/channel[14]} -radix decimal} {{/tx_signal_path_tb/channel[13]} -radix decimal} {{/tx_signal_path_tb/channel[12]} -radix decimal} {{/tx_signal_path_tb/channel[11]} -radix decimal} {{/tx_signal_path_tb/channel[10]} -radix decimal} {{/tx_signal_path_tb/channel[9]} -radix decimal} {{/tx_signal_path_tb/channel[8]} -radix decimal} {{/tx_signal_path_tb/channel[7]} -radix decimal} {{/tx_signal_path_tb/channel[6]} -radix decimal} {{/tx_signal_path_tb/channel[5]} -radix decimal} {{/tx_signal_path_tb/channel[4]} -radix decimal} {{/tx_signal_path_tb/channel[3]} -radix decimal} {{/tx_signal_path_tb/channel[2]} -radix decimal} {{/tx_signal_path_tb/channel[1]} -radix decimal} {{/tx_signal_path_tb/channel[0]} -radix decimal}} -subitemconfig {{/tx_signal_path_tb/channel[17]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[16]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[15]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[14]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[13]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[12]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[11]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[10]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[9]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[8]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[7]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[6]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[5]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[4]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[3]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[2]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[1]} {-height 15 -radix decimal} {/tx_signal_path_tb/channel[0]} {-height 15 -radix decimal}} /tx_signal_path_tb/channel
add wave -noupdate -divider {Filter Signals}
add wave -noupdate -format Analog-Step -height 84 -max 49151.0 -min -49151.0 /tx_signal_path_tb/filter/in
add wave -noupdate -height 15 /tx_signal_path_tb/filter/in_reg
add wave -noupdate -format Analog-Step -height 84 -max 38791.000000000007 -min -36474.0 /tx_signal_path_tb/filter/out
add wave -noupdate -height 15 -subitemconfig {{/tx_signal_path_tb/filter/count4[1]} {-height 15} {/tx_signal_path_tb/filter/count4[0]} {-height 15}} /tx_signal_path_tb/filter/count4
add wave -noupdate -height 15 -subitemconfig {{/tx_signal_path_tb/filter/bin[49]} {-height 15} {/tx_signal_path_tb/filter/bin[48]} {-height 15} {/tx_signal_path_tb/filter/bin[47]} {-height 15} {/tx_signal_path_tb/filter/bin[46]} {-height 15} {/tx_signal_path_tb/filter/bin[45]} {-height 15} {/tx_signal_path_tb/filter/bin[44]} {-height 15} {/tx_signal_path_tb/filter/bin[43]} {-height 15} {/tx_signal_path_tb/filter/bin[42]} {-height 15} {/tx_signal_path_tb/filter/bin[41]} {-height 15} {/tx_signal_path_tb/filter/bin[40]} {-height 15} {/tx_signal_path_tb/filter/bin[39]} {-height 15} {/tx_signal_path_tb/filter/bin[38]} {-height 15} {/tx_signal_path_tb/filter/bin[37]} {-height 15} {/tx_signal_path_tb/filter/bin[36]} {-height 15} {/tx_signal_path_tb/filter/bin[35]} {-height 15} {/tx_signal_path_tb/filter/bin[34]} {-height 15} {/tx_signal_path_tb/filter/bin[33]} {-height 15} {/tx_signal_path_tb/filter/bin[32]} {-height 15} {/tx_signal_path_tb/filter/bin[31]} {-height 15} {/tx_signal_path_tb/filter/bin[30]} {-height 15} {/tx_signal_path_tb/filter/bin[29]} {-height 15} {/tx_signal_path_tb/filter/bin[28]} {-height 15} {/tx_signal_path_tb/filter/bin[27]} {-height 15} {/tx_signal_path_tb/filter/bin[26]} {-height 15} {/tx_signal_path_tb/filter/bin[25]} {-height 15} {/tx_signal_path_tb/filter/bin[24]} {-height 15} {/tx_signal_path_tb/filter/bin[23]} {-height 15} {/tx_signal_path_tb/filter/bin[22]} {-height 15} {/tx_signal_path_tb/filter/bin[21]} {-height 15} {/tx_signal_path_tb/filter/bin[20]} {-height 15} {/tx_signal_path_tb/filter/bin[19]} {-height 15} {/tx_signal_path_tb/filter/bin[18]} {-height 15} {/tx_signal_path_tb/filter/bin[17]} {-height 15} {/tx_signal_path_tb/filter/bin[16]} {-height 15} {/tx_signal_path_tb/filter/bin[15]} {-height 15} {/tx_signal_path_tb/filter/bin[14]} {-height 15} {/tx_signal_path_tb/filter/bin[13]} {-height 15} {/tx_signal_path_tb/filter/bin[12]} {-height 15} {/tx_signal_path_tb/filter/bin[11]} {-height 15} {/tx_signal_path_tb/filter/bin[10]} {-height 15} {/tx_signal_path_tb/filter/bin[9]} {-height 15} {/tx_signal_path_tb/filter/bin[8]} {-height 15} {/tx_signal_path_tb/filter/bin[7]} {-height 15} {/tx_signal_path_tb/filter/bin[6]} {-height 15} {/tx_signal_path_tb/filter/bin[5]} {-height 15} {/tx_signal_path_tb/filter/bin[4]} {-height 15} {/tx_signal_path_tb/filter/bin[3]} {-height 15} {/tx_signal_path_tb/filter/bin[2]} {-height 15} {/tx_signal_path_tb/filter/bin[1]} {-height 15} {/tx_signal_path_tb/filter/bin[0]} {-height 15}} /tx_signal_path_tb/filter/bin
add wave -noupdate -height 15 /tx_signal_path_tb/filter/bin_out
add wave -noupdate -height 15 /tx_signal_path_tb/filter/sum_level_1
add wave -noupdate -height 15 /tx_signal_path_tb/filter/sum_level_2
add wave -noupdate -height 15 /tx_signal_path_tb/filter/sum_level_3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {119734 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 280
configure wave -valuecolwidth 40
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
WaveRestoreZoom {119734 ns} {168886 ns}
