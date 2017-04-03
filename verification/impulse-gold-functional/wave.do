onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /impulse_gold_tb/clk_tb
add wave -noupdate /impulse_gold_tb/reset
add wave -noupdate /impulse_gold_tb/sys_clk
add wave -noupdate /impulse_gold_tb/sam_clk
add wave -noupdate /impulse_gold_tb/sym_clk
add wave -noupdate /impulse_gold_tb/sam_clk_en
add wave -noupdate /impulse_gold_tb/sym_clk_en
add wave -noupdate /impulse_gold_tb/hb_clk_en
add wave -noupdate /impulse_gold_tb/phase
add wave -noupdate -radix unsigned /impulse_gold_tb/imp_count
add wave -noupdate -format Analog-Step -height 84 -max 131070.99999999999 /impulse_gold_tb/stimulus
add wave -noupdate -format Analog-Step -height 84 -max 22914.0 -min -4796.0 -radix decimal -childformat {{{/impulse_gold_tb/response[17]} -radix decimal} {{/impulse_gold_tb/response[16]} -radix decimal} {{/impulse_gold_tb/response[15]} -radix decimal} {{/impulse_gold_tb/response[14]} -radix decimal} {{/impulse_gold_tb/response[13]} -radix decimal} {{/impulse_gold_tb/response[12]} -radix decimal} {{/impulse_gold_tb/response[11]} -radix decimal} {{/impulse_gold_tb/response[10]} -radix decimal} {{/impulse_gold_tb/response[9]} -radix decimal} {{/impulse_gold_tb/response[8]} -radix decimal} {{/impulse_gold_tb/response[7]} -radix decimal} {{/impulse_gold_tb/response[6]} -radix decimal} {{/impulse_gold_tb/response[5]} -radix decimal} {{/impulse_gold_tb/response[4]} -radix decimal} {{/impulse_gold_tb/response[3]} -radix decimal} {{/impulse_gold_tb/response[2]} -radix decimal} {{/impulse_gold_tb/response[1]} -radix decimal} {{/impulse_gold_tb/response[0]} -radix decimal}} -subitemconfig {{/impulse_gold_tb/response[17]} {-height 15 -radix decimal} {/impulse_gold_tb/response[16]} {-height 15 -radix decimal} {/impulse_gold_tb/response[15]} {-height 15 -radix decimal} {/impulse_gold_tb/response[14]} {-height 15 -radix decimal} {/impulse_gold_tb/response[13]} {-height 15 -radix decimal} {/impulse_gold_tb/response[12]} {-height 15 -radix decimal} {/impulse_gold_tb/response[11]} {-height 15 -radix decimal} {/impulse_gold_tb/response[10]} {-height 15 -radix decimal} {/impulse_gold_tb/response[9]} {-height 15 -radix decimal} {/impulse_gold_tb/response[8]} {-height 15 -radix decimal} {/impulse_gold_tb/response[7]} {-height 15 -radix decimal} {/impulse_gold_tb/response[6]} {-height 15 -radix decimal} {/impulse_gold_tb/response[5]} {-height 15 -radix decimal} {/impulse_gold_tb/response[4]} {-height 15 -radix decimal} {/impulse_gold_tb/response[3]} {-height 15 -radix decimal} {/impulse_gold_tb/response[2]} {-height 15 -radix decimal} {/impulse_gold_tb/response[1]} {-height 15 -radix decimal} {/impulse_gold_tb/response[0]} {-height 15 -radix decimal}} /impulse_gold_tb/response
add wave -noupdate -divider {Filter Internal Data}
add wave -noupdate -expand /impulse_gold_tb/prac_hb_flt/sum_level_1
add wave -noupdate /impulse_gold_tb/prac_hb_flt/mult_out
add wave -noupdate /impulse_gold_tb/prac_hb_flt/sum_level_2
add wave -noupdate /impulse_gold_tb/prac_hb_flt/sum_level_3
add wave -noupdate /impulse_gold_tb/prac_hb_flt/sum_level_4
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12701 ns} 0}
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
WaveRestoreZoom {12176 ns} {13984 ns}
