library verilog;
use verilog.vl_types.all;
entity mapper_16_qam is
    port(
        clk             : in     vl_logic;
        clk_en          : in     vl_logic;
        data            : in     vl_logic_vector(3 downto 0);
        in_phs_sig      : out    vl_logic_vector(17 downto 0);
        quad_sig        : out    vl_logic_vector(17 downto 0)
    );
end mapper_16_qam;
