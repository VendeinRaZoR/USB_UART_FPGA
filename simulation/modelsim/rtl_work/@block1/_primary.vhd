library verilog;
use verilog.vl_types.all;
entity Block1 is
    port(
        RX_COM1         : in     vl_logic;
        RX_COM2         : in     vl_logic;
        usb_clk         : in     vl_logic;
        uart_clk        : in     vl_logic;
        tx_clk          : out    vl_logic;
        TX_COM1         : out    vl_logic;
        TX_COM2         : out    vl_logic;
        d_out_enable    : out    vl_logic;
        TX_COM_LED1     : out    vl_logic;
        TX_COM_LED2     : out    vl_logic;
        dp_inout        : inout  vl_logic;
        dm_inout        : inout  vl_logic
    );
end Block1;
