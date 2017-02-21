library verilog;
use verilog.vl_types.all;
entity lfsr_gen_max is
    port(
        clk             : in     vl_logic;
        clk_en          : in     vl_logic;
        reset           : in     vl_logic;
        seq_out         : out    vl_logic_vector(21 downto 0);
        sym_out         : out    vl_logic_vector(3 downto 0);
        cycle_out       : out    vl_logic;
        lfsr_counter    : out    vl_logic_vector(4 downto 0)
    );
end lfsr_gen_max;
