library verilog;
use verilog.vl_types.all;
entity ref_level_gen is
    port(
        clk             : in     vl_logic;
        clk_en          : in     vl_logic;
        reset           : in     vl_logic;
        hold            : in     vl_logic;
        dec_var         : in     vl_logic_vector(17 downto 0);
        ref_level       : out    vl_logic_vector(17 downto 0);
        avg_power       : out    vl_logic_vector(17 downto 0)
    );
end ref_level_gen;
