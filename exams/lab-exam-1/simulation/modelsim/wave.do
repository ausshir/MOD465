onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /exam1_tb/clk_tb
add wave -noupdate /exam1_tb/reset
add wave -noupdate /exam1_tb/sut/srrc_out
add wave -noupdate /exam1_tb/sut/srrc_input
add wave -noupdate /exam1_tb/sut/i_sym
add wave -noupdate /exam1_tb/sut/sys_clk
add wave -noupdate /exam1_tb/sut/sam_clk_ena
add wave -noupdate /exam1_tb/sut/sym_clk_ena
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {55234 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ps
update
WaveRestoreZoom {500250 ps} {605250 ps}
