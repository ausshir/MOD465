onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 15 /impulse_gold_tb/clk_tb
add wave -noupdate -height 15 /impulse_gold_tb/reset
add wave -noupdate -height 15 /impulse_gold_tb/sys_clk
add wave -noupdate -height 15 /impulse_gold_tb/sam_clk
add wave -noupdate -height 15 /impulse_gold_tb/sym_clk
add wave -noupdate -height 15 /impulse_gold_tb/sam_clk_en
add wave -noupdate -height 15 /impulse_gold_tb/sym_clk_en
add wave -noupdate -height 15 /impulse_gold_tb/phase
add wave -noupdate -height 15 -radix unsigned /impulse_gold_tb/imp_count
add wave -noupdate -format Analog-Step -height 84 -max 65536.0 /impulse_gold_tb/stimulus
add wave -noupdate -format Analog-Step -height 200 -max 40000.000000000007 -min -10000.0 -radix decimal /impulse_gold_tb/response
add wave -noupdate -divider {Filter Internal Data}
add wave -noupdate -height 15 /impulse_gold_tb/sut/in_reg
add wave -noupdate -height 15 /impulse_gold_tb/sut/count4
add wave -noupdate -height 15 /impulse_gold_tb/sut/bin
add wave -noupdate -height 15 /impulse_gold_tb/sut/bin_out
add wave -noupdate -divider {Multiplier Filter Internal Data}
add wave -noupdate -height 15 /impulse_gold_tb/sut/sum_level_1
add wave -noupdate -height 15 /impulse_gold_tb/sut/sum_level_2
add wave -noupdate -height 15 /impulse_gold_tb/sut/sum_level_3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11197 ns} 0}
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
WaveRestoreZoom {82568 ns} {111444 ns}
