library verilog;
use verilog.vl_types.all;
entity ls_usb_sender is
    port(
        clk             : in     vl_logic;
        EOP             : in     vl_logic;
        rdata           : in     vl_logic_vector(7 downto 0);
        rdata_ready     : in     vl_logic;
        rbyte_cnt       : in     vl_logic_vector(3 downto 0);
        core_strobe     : in     vl_logic;
        SOP             : in     vl_logic;
        send_reg        : in     vl_logic_vector(7 downto 0);
        sEOP            : in     vl_logic;
        sdata_ready     : in     vl_logic;
        dp_out          : out    vl_logic;
        dm_out          : out    vl_logic;
        strobe          : out    vl_logic;
        d_out_enable    : out    vl_logic;
        sixone_signal   : out    vl_logic
    );
end ls_usb_sender;
