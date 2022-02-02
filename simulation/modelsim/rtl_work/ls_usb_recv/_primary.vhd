library verilog;
use verilog.vl_types.all;
entity ls_usb_recv is
    port(
        clk             : in     vl_logic;
        dp              : in     vl_logic;
        dm              : in     vl_logic;
        d_out_enable    : in     vl_logic;
        alternate_strobe: in     vl_logic;
        EOP             : out    vl_logic;
        rdata           : out    vl_logic_vector(7 downto 0);
        rdata_ready     : out    vl_logic;
        strobe          : out    vl_logic;
        SOP             : out    vl_logic
    );
end ls_usb_recv;
