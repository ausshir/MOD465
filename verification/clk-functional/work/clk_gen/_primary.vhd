library verilog;
use verilog.vl_types.all;
entity clk_gen is
    port(
        clk_in          : in     vl_logic;
        reset           : in     vl_logic;
        sys_clk         : out    vl_logic;
        sam_clk         : out    vl_logic;
        sym_clk         : out    vl_logic;
        sam_clk_ena     : out    vl_logic;
        sym_clk_ena     : out    vl_logic;
        clk_phase       : out    vl_logic_vector(3 downto 0)
    );
end clk_gen;
