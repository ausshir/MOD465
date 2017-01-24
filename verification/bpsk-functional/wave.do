onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TB
add wave -noupdate /impulse_tb/clk_tb
add wave -noupdate /impulse_tb/reset
add wave -noupdate -radix hexadecimal /impulse_tb/imp_count
add wave -noupdate -divider Stimulus
add wave -noupdate -radix decimal /impulse_tb/stimulus
add wave -noupdate -divider {Impulse Response}
add wave -noupdate -format Analog-Step -height 250 -max 32528.999999999996 -min -4518.0 -radix decimal -childformat {{{/impulse_tb/response[17]} -radix decimal} {{/impulse_tb/response[16]} -radix decimal} {{/impulse_tb/response[15]} -radix decimal} {{/impulse_tb/response[14]} -radix decimal} {{/impulse_tb/response[13]} -radix decimal} {{/impulse_tb/response[12]} -radix decimal} {{/impulse_tb/response[11]} -radix decimal} {{/impulse_tb/response[10]} -radix decimal} {{/impulse_tb/response[9]} -radix decimal} {{/impulse_tb/response[8]} -radix decimal} {{/impulse_tb/response[7]} -radix decimal} {{/impulse_tb/response[6]} -radix decimal} {{/impulse_tb/response[5]} -radix decimal} {{/impulse_tb/response[4]} -radix decimal} {{/impulse_tb/response[3]} -radix decimal} {{/impulse_tb/response[2]} -radix decimal} {{/impulse_tb/response[1]} -radix decimal} {{/impulse_tb/response[0]} -radix decimal}} -subitemconfig {{/impulse_tb/response[17]} {-height 15 -radix decimal} {/impulse_tb/response[16]} {-height 15 -radix decimal} {/impulse_tb/response[15]} {-height 15 -radix decimal} {/impulse_tb/response[14]} {-height 15 -radix decimal} {/impulse_tb/response[13]} {-height 15 -radix decimal} {/impulse_tb/response[12]} {-height 15 -radix decimal} {/impulse_tb/response[11]} {-height 15 -radix decimal} {/impulse_tb/response[10]} {-height 15 -radix decimal} {/impulse_tb/response[9]} {-height 15 -radix decimal} {/impulse_tb/response[8]} {-height 15 -radix decimal} {/impulse_tb/response[7]} {-height 15 -radix decimal} {/impulse_tb/response[6]} {-height 15 -radix decimal} {/impulse_tb/response[5]} {-height 15 -radix decimal} {/impulse_tb/response[4]} {-height 15 -radix decimal} {/impulse_tb/response[3]} {-height 15 -radix decimal} {/impulse_tb/response[2]} {-height 15 -radix decimal} {/impulse_tb/response[1]} {-height 15 -radix decimal} {/impulse_tb/response[0]} {-height 15 -radix decimal}} /impulse_tb/response
add wave -noupdate -height 100 /impulse_tb/response
add wave -noupdate -divider SUT
add wave -noupdate /impulse_tb/sut/clk
add wave -noupdate /impulse_tb/sut/reset
add wave -noupdate /impulse_tb/sut/in
add wave -noupdate /impulse_tb/sut/out
add wave -noupdate /impulse_tb/sut/i
add wave -noupdate /impulse_tb/sut/b
add wave -noupdate /impulse_tb/sut/x
add wave -noupdate /impulse_tb/sut/mult_out
add wave -noupdate /impulse_tb/sut/sum_level_1
add wave -noupdate /impulse_tb/sut/sum_level_2
add wave -noupdate /impulse_tb/sut/sum_level_3
add wave -noupdate /impulse_tb/sut/sum_level_4
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2374 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 222
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
configure wave -timelineunits ns
update
WaveRestoreZoom {2034 ns} {3022 ns}
