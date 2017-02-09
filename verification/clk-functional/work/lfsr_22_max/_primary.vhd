library verilog;
use verilog.vl_types.all;
entity lfsr_22_max is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        seq_out         : out    vl_logic_vector(21 downto 0);
        sym_out         : out    vl_logic_vector(1 downto 0)
    );
end lfsr_22_max;
