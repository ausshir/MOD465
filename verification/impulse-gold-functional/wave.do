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
add wave -noupdate -format Analog-Step -height 84 -max 80.0 /impulse_gold_tb/response
add wave -noupdate -divider {Filter Internal Data}
add wave -noupdate -height 15 -radix decimal -childformat {{{/impulse_gold_tb/sut/bin[76]} -radix decimal} {{/impulse_gold_tb/sut/bin[75]} -radix decimal} {{/impulse_gold_tb/sut/bin[74]} -radix decimal} {{/impulse_gold_tb/sut/bin[73]} -radix decimal} {{/impulse_gold_tb/sut/bin[72]} -radix decimal} {{/impulse_gold_tb/sut/bin[71]} -radix decimal} {{/impulse_gold_tb/sut/bin[70]} -radix decimal} {{/impulse_gold_tb/sut/bin[69]} -radix decimal} {{/impulse_gold_tb/sut/bin[68]} -radix decimal} {{/impulse_gold_tb/sut/bin[67]} -radix decimal} {{/impulse_gold_tb/sut/bin[66]} -radix decimal} {{/impulse_gold_tb/sut/bin[65]} -radix decimal} {{/impulse_gold_tb/sut/bin[64]} -radix decimal} {{/impulse_gold_tb/sut/bin[63]} -radix decimal} {{/impulse_gold_tb/sut/bin[62]} -radix decimal} {{/impulse_gold_tb/sut/bin[61]} -radix decimal} {{/impulse_gold_tb/sut/bin[60]} -radix decimal} {{/impulse_gold_tb/sut/bin[59]} -radix decimal} {{/impulse_gold_tb/sut/bin[58]} -radix decimal} {{/impulse_gold_tb/sut/bin[57]} -radix decimal} {{/impulse_gold_tb/sut/bin[56]} -radix decimal} {{/impulse_gold_tb/sut/bin[55]} -radix decimal} {{/impulse_gold_tb/sut/bin[54]} -radix decimal} {{/impulse_gold_tb/sut/bin[53]} -radix decimal} {{/impulse_gold_tb/sut/bin[52]} -radix decimal} {{/impulse_gold_tb/sut/bin[51]} -radix decimal} {{/impulse_gold_tb/sut/bin[50]} -radix decimal} {{/impulse_gold_tb/sut/bin[49]} -radix decimal} {{/impulse_gold_tb/sut/bin[48]} -radix decimal} {{/impulse_gold_tb/sut/bin[47]} -radix decimal} {{/impulse_gold_tb/sut/bin[46]} -radix decimal} {{/impulse_gold_tb/sut/bin[45]} -radix decimal} {{/impulse_gold_tb/sut/bin[44]} -radix decimal} {{/impulse_gold_tb/sut/bin[43]} -radix decimal} {{/impulse_gold_tb/sut/bin[42]} -radix decimal} {{/impulse_gold_tb/sut/bin[41]} -radix decimal} {{/impulse_gold_tb/sut/bin[40]} -radix decimal} {{/impulse_gold_tb/sut/bin[39]} -radix decimal} {{/impulse_gold_tb/sut/bin[38]} -radix decimal} {{/impulse_gold_tb/sut/bin[37]} -radix decimal} {{/impulse_gold_tb/sut/bin[36]} -radix decimal} {{/impulse_gold_tb/sut/bin[35]} -radix decimal} {{/impulse_gold_tb/sut/bin[34]} -radix decimal} {{/impulse_gold_tb/sut/bin[33]} -radix decimal} {{/impulse_gold_tb/sut/bin[32]} -radix decimal} {{/impulse_gold_tb/sut/bin[31]} -radix decimal} {{/impulse_gold_tb/sut/bin[30]} -radix decimal} {{/impulse_gold_tb/sut/bin[29]} -radix decimal} {{/impulse_gold_tb/sut/bin[28]} -radix decimal} {{/impulse_gold_tb/sut/bin[27]} -radix decimal} {{/impulse_gold_tb/sut/bin[26]} -radix decimal} {{/impulse_gold_tb/sut/bin[25]} -radix decimal} {{/impulse_gold_tb/sut/bin[24]} -radix decimal} {{/impulse_gold_tb/sut/bin[23]} -radix decimal} {{/impulse_gold_tb/sut/bin[22]} -radix decimal} {{/impulse_gold_tb/sut/bin[21]} -radix decimal} {{/impulse_gold_tb/sut/bin[20]} -radix decimal} {{/impulse_gold_tb/sut/bin[19]} -radix decimal} {{/impulse_gold_tb/sut/bin[18]} -radix decimal} {{/impulse_gold_tb/sut/bin[17]} -radix decimal} {{/impulse_gold_tb/sut/bin[16]} -radix decimal} {{/impulse_gold_tb/sut/bin[15]} -radix decimal} {{/impulse_gold_tb/sut/bin[14]} -radix decimal} {{/impulse_gold_tb/sut/bin[13]} -radix decimal} {{/impulse_gold_tb/sut/bin[12]} -radix decimal} {{/impulse_gold_tb/sut/bin[11]} -radix decimal} {{/impulse_gold_tb/sut/bin[10]} -radix decimal} {{/impulse_gold_tb/sut/bin[9]} -radix decimal} {{/impulse_gold_tb/sut/bin[8]} -radix decimal} {{/impulse_gold_tb/sut/bin[7]} -radix decimal} {{/impulse_gold_tb/sut/bin[6]} -radix decimal} {{/impulse_gold_tb/sut/bin[5]} -radix decimal} {{/impulse_gold_tb/sut/bin[4]} -radix decimal} {{/impulse_gold_tb/sut/bin[3]} -radix decimal} {{/impulse_gold_tb/sut/bin[2]} -radix decimal} {{/impulse_gold_tb/sut/bin[1]} -radix decimal} {{/impulse_gold_tb/sut/bin[0]} -radix decimal}} -subitemconfig {{/impulse_gold_tb/sut/bin[76]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[75]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[74]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[73]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[72]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[71]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[70]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[69]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[68]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[67]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[66]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[65]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[64]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[63]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[62]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[61]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[60]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[59]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[58]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[57]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[56]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[55]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[54]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[53]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[52]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[51]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[50]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[49]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[48]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[47]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[46]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[45]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[44]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[43]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[42]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[41]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[40]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[39]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[38]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[37]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[36]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[35]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[34]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[33]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[32]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[31]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[30]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[29]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[28]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[27]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[26]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[25]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[24]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[23]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[22]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[21]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[20]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[19]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[18]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[17]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[16]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[15]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[14]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[13]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[12]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[11]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[10]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[9]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[8]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[7]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[6]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[5]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[4]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[3]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[2]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[1]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin[0]} {-height 15 -radix decimal}} /impulse_gold_tb/sut/bin
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin[5]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin[4]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin[3]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin[2]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin[1]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin[0]}
add wave -noupdate -height 15 {/impulse_gold_tb/sut/bin[76]}
add wave -noupdate -height 15 {/impulse_gold_tb/sut/bin[75]}
add wave -noupdate -height 15 {/impulse_gold_tb/sut/bin[74]}
add wave -noupdate -height 15 {/impulse_gold_tb/sut/bin[73]}
add wave -noupdate -height 15 {/impulse_gold_tb/sut/bin[72]}
add wave -noupdate -height 15 {/impulse_gold_tb/sut/bin[71]}
add wave -noupdate -height 15 -radix decimal -childformat {{{/impulse_gold_tb/sut/bin_out[76]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[75]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[74]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[73]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[72]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[71]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[70]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[69]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[68]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[67]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[66]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[65]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[64]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[63]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[62]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[61]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[60]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[59]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[58]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[57]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[56]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[55]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[54]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[53]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[52]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[51]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[50]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[49]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[48]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[47]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[46]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[45]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[44]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[43]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[42]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[41]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[40]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[39]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[38]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[37]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[36]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[35]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[34]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[33]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[32]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[31]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[30]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[29]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[28]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[27]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[26]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[25]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[24]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[23]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[22]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[21]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[20]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[19]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[18]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[17]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[16]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[15]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[14]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[13]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[12]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[11]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[10]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[9]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[8]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[7]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[6]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[5]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[4]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[3]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[2]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[1]} -radix decimal} {{/impulse_gold_tb/sut/bin_out[0]} -radix decimal}} -subitemconfig {{/impulse_gold_tb/sut/bin_out[76]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[75]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[74]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[73]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[72]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[71]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[70]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[69]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[68]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[67]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[66]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[65]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[64]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[63]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[62]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[61]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[60]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[59]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[58]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[57]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[56]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[55]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[54]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[53]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[52]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[51]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[50]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[49]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[48]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[47]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[46]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[45]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[44]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[43]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[42]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[41]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[40]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[39]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[38]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[37]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[36]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[35]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[34]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[33]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[32]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[31]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[30]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[29]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[28]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[27]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[26]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[25]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[24]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[23]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[22]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[21]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[20]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[19]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[18]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[17]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[16]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[15]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[14]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[13]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[12]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[11]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[10]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[9]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[8]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[7]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[6]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[5]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[4]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[3]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[2]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[1]} {-height 15 -radix decimal} {/impulse_gold_tb/sut/bin_out[0]} {-height 15 -radix decimal}} /impulse_gold_tb/sut/bin_out
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin_out[5]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin_out[4]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin_out[3]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin_out[2]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin_out[1]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin_out[0]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin_out[76]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin_out[75]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin_out[74]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin_out[73]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin_out[72]}
add wave -noupdate -height 15 -radix decimal {/impulse_gold_tb/sut/bin_out[71]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {109137 ns} 0}
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
WaveRestoreZoom {96284 ns} {110722 ns}
