onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TB
add wave -noupdate /impulse_tb/clk_tb
add wave -noupdate /impulse_tb/clk_sym
add wave -noupdate /impulse_tb/reset
add wave -noupdate -radix hexadecimal /impulse_tb/imp_count
add wave -noupdate -divider Stimulus
add wave -noupdate -radix decimal /impulse_tb/stimulus
add wave -noupdate -divider {Impulse Response}
add wave -noupdate -format Analog-Step -height 126 -max 66022.0 -min -6936.0 -radix decimal -childformat {{{/impulse_tb/response[17]} -radix decimal} {{/impulse_tb/response[16]} -radix decimal} {{/impulse_tb/response[15]} -radix decimal} {{/impulse_tb/response[14]} -radix decimal} {{/impulse_tb/response[13]} -radix decimal} {{/impulse_tb/response[12]} -radix decimal} {{/impulse_tb/response[11]} -radix decimal} {{/impulse_tb/response[10]} -radix decimal} {{/impulse_tb/response[9]} -radix decimal} {{/impulse_tb/response[8]} -radix decimal} {{/impulse_tb/response[7]} -radix decimal} {{/impulse_tb/response[6]} -radix decimal} {{/impulse_tb/response[5]} -radix decimal} {{/impulse_tb/response[4]} -radix decimal} {{/impulse_tb/response[3]} -radix decimal} {{/impulse_tb/response[2]} -radix decimal} {{/impulse_tb/response[1]} -radix decimal} {{/impulse_tb/response[0]} -radix decimal}} -subitemconfig {{/impulse_tb/response[17]} {-height 15 -radix decimal} {/impulse_tb/response[16]} {-height 15 -radix decimal} {/impulse_tb/response[15]} {-height 15 -radix decimal} {/impulse_tb/response[14]} {-height 15 -radix decimal} {/impulse_tb/response[13]} {-height 15 -radix decimal} {/impulse_tb/response[12]} {-height 15 -radix decimal} {/impulse_tb/response[11]} {-height 15 -radix decimal} {/impulse_tb/response[10]} {-height 15 -radix decimal} {/impulse_tb/response[9]} {-height 15 -radix decimal} {/impulse_tb/response[8]} {-height 15 -radix decimal} {/impulse_tb/response[7]} {-height 15 -radix decimal} {/impulse_tb/response[6]} {-height 15 -radix decimal} {/impulse_tb/response[5]} {-height 15 -radix decimal} {/impulse_tb/response[4]} {-height 15 -radix decimal} {/impulse_tb/response[3]} {-height 15 -radix decimal} {/impulse_tb/response[2]} {-height 15 -radix decimal} {/impulse_tb/response[1]} {-height 15 -radix decimal} {/impulse_tb/response[0]} {-height 15 -radix decimal}} /impulse_tb/response
add wave -noupdate -height 100 /impulse_tb/response
add wave -noupdate -divider SUT
add wave -noupdate /impulse_tb/sut/clk
add wave -noupdate /impulse_tb/sut/symbol_clk
add wave -noupdate /impulse_tb/sut/reset
add wave -noupdate /impulse_tb/sut/in
add wave -noupdate /impulse_tb/sut/out
add wave -noupdate /impulse_tb/sut/i
add wave -noupdate /impulse_tb/sut/reset
add wave -noupdate /impulse_tb/sut/in
add wave -noupdate /impulse_tb/sut/out
add wave -noupdate /impulse_tb/sut/i
add wave -noupdate /impulse_tb/sut/symbol
add wave -noupdate /impulse_tb/sut/count4
add wave -noupdate /impulse_tb/sut/bin
add wave -noupdate /impulse_tb/sut/bin_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {105699261 ns} 0}
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
WaveRestoreZoom {0 ns} {427216524 ns}
