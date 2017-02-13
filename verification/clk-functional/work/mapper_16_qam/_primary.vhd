library verilog;
use verilog.vl_types.all;
entity mapper_16_qam is
    generic(
        SYMBOL_P1       : vl_logic_vector(0 to 17) := (Hi0, Hi0, Hi1, Hi0, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1);
        SYMBOL_P2       : vl_logic_vector(0 to 17) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1);
        SYMBOL_N1       : integer := -16384;
        SYMBOL_N2       : integer := -49151
    );
    port(
        clk             : in     vl_logic;
        clk_en          : in     vl_logic;
        data            : in     vl_logic_vector(3 downto 0);
        in_phs_sig      : out    vl_logic_vector(17 downto 0);
        quad_sig        : out    vl_logic_vector(17 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SYMBOL_P1 : constant is 1;
    attribute mti_svvh_generic_type of SYMBOL_P2 : constant is 1;
    attribute mti_svvh_generic_type of SYMBOL_N1 : constant is 1;
    attribute mti_svvh_generic_type of SYMBOL_N2 : constant is 1;
end mapper_16_qam;
