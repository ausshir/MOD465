vlog d4_sim_tb.v
vsim -L altera_ver -L cycloneive_ver d4_sim_tb
do wave.do

# From Altera Documentation.. I just made a symlink :)
# vsim -t ps +transport_int_delays +transport_path_delays -L <device family>_ver -sdf(min | typ | max) work.<top-level design entity>
