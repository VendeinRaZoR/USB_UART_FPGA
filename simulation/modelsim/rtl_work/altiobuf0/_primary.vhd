library verilog;
use verilog.vl_types.all;
entity altiobuf0 is
    port(
        datain          : in     vl_logic_vector(0 downto 0);
        oe              : in     vl_logic_vector(0 downto 0);
        dataio          : inout  vl_logic_vector(0 downto 0);
        dataout         : out    vl_logic_vector(0 downto 0)
    );
end altiobuf0;
