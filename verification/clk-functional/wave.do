onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 35 /clk_tb/reset
add wave -noupdate -height 35 /clk_tb/clk_tb
add wave -noupdate -height 35 /clk_tb/clk_25
add wave -noupdate -height 35 /clk_tb/clk_625
add wave -noupdate -height 35 /clk_tb/clk_15625
add wave -noupdate -height 35 /clk_tb/clk_625_en
add wave -noupdate -height 35 /clk_tb/clk_15625_en
add wave -noupdate -height 35 -radix unsigned /clk_tb/phase
add wave -noupdate -height 15 /clk_tb/lfsr/seq_out
add wave -noupdate -height 15 /clk_tb/sym_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {615 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 194
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
WaveRestoreZoom {0 ns} {2625 ns}
