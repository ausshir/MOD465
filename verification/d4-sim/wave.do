onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 15 /d4_sim_tb/sut/sys_clk
add wave -noupdate -height 15 /d4_sim_tb/sut/sam_clk
add wave -noupdate -height 15 /d4_sim_tb/sut/sym_clk
add wave -noupdate -height 15 /d4_sim_tb/sut/sam_clk_en
add wave -noupdate -height 15 /d4_sim_tb/sut/sym_clk_en
add wave -noupdate -height 15 /d4_sim_tb/sut/phase
add wave -noupdate -height 15 /d4_sim_tb/clk_tb
add wave -noupdate -height 15 /d4_sim_tb/reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 284
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
WaveRestoreZoom {0 ps} {16442496 ps}
