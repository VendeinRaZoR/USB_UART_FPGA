library verilog;
use verilog.vl_types.all;
entity uart_controller is
    port(
        uart_clk        : in     vl_logic;
        rbyteready      : in     vl_logic;
        EOP             : in     vl_logic;
        uart_tx_byte    : in     vl_logic_vector(7 downto 0);
        uart_rx_byte    : out    vl_logic_vector(7 downto 0);
        uart_tx_com1    : out    vl_logic;
        uart_rx_com1    : in     vl_logic;
        uart_tx_en      : in     vl_logic;
        usb_clk         : in     vl_logic;
        uart_tx_com2    : out    vl_logic;
        uart_rx_done    : out    vl_logic;
        uart_rx_com2    : in     vl_logic
    );
end uart_controller;
