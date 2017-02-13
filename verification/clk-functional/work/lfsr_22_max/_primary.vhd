library verilog;
use verilog.vl_types.all;
entity lfsr_22_max is
    generic(
        LFSR_SEED       : vl_logic_vector(0 to 20) := (Hi1, Hi1, Hi1, Hi0, Hi1, Hi0, Hi1, Hi1, Hi0, Hi1, Hi1, Hi1, Hi1, Hi0, Hi1, Hi0, Hi1, Hi0, Hi1, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        clk_en          : in     vl_logic;
        reset           : in     vl_logic;
        seq_out         : out    vl_logic_vector(21 downto 0);
        sym_out         : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LFSR_SEED : constant is 1;
end lfsr_22_max;
