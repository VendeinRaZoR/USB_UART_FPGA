library verilog;
use verilog.vl_types.all;
entity ls_usb_core is
    generic(
        IDLE            : integer := 0;
        RECV_DATA       : integer := 1;
        SEND_DATA_GET_DESC: integer := 2;
        SEND_DATA_GET_DESC_FULL: integer := 3;
        SEND_ACK        : integer := 4;
        SEND_DATA1_NULL : integer := 5;
        SEND_DATA_GET_DESC_CONFIGURATION: integer := 6;
        SEND_DATA_GET_DESC_CONFIGURATION_FULL: integer := 7;
        SEND_DATA_GET_DESC_STRING0: integer := 8;
        SEND_DATA_GET_DESC_STRING1: integer := 9;
        SEND_DATA_GET_DESC_STRING2: integer := 10;
        SEND_DATA_GET_LINE_CODING: integer := 11;
        SEND_DATA_TEST_MESSAGE: integer := 12;
        RECV_TX_DATA    : integer := 13;
        SEND_DATA_TEST_MESSAGE_RX: integer := 14
    );
    port(
        clk             : in     vl_logic;
        EOP             : in     vl_logic;
        rdata           : in     vl_logic_vector(7 downto 0);
        rdata_ready     : in     vl_logic;
        strobe          : in     vl_logic;
        SOP             : in     vl_logic;
        strobe_sender   : in     vl_logic;
        sixone_signal   : in     vl_logic;
        SETUP_token     : out    vl_logic;
        send_reg        : out    vl_logic_vector(7 downto 0);
        sEOP            : out    vl_logic;
        sdata_ready     : out    vl_logic;
        btrdcnt_strobe  : out    vl_logic;
        TX_byte_CRC     : out    vl_logic_vector(7 downto 0);
        RX_byte         : in     vl_logic_vector(7 downto 0);
        TX_EN           : out    vl_logic;
        RX_DONE         : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of RECV_DATA : constant is 1;
    attribute mti_svvh_generic_type of SEND_DATA_GET_DESC : constant is 1;
    attribute mti_svvh_generic_type of SEND_DATA_GET_DESC_FULL : constant is 1;
    attribute mti_svvh_generic_type of SEND_ACK : constant is 1;
    attribute mti_svvh_generic_type of SEND_DATA1_NULL : constant is 1;
    attribute mti_svvh_generic_type of SEND_DATA_GET_DESC_CONFIGURATION : constant is 1;
    attribute mti_svvh_generic_type of SEND_DATA_GET_DESC_CONFIGURATION_FULL : constant is 1;
    attribute mti_svvh_generic_type of SEND_DATA_GET_DESC_STRING0 : constant is 1;
    attribute mti_svvh_generic_type of SEND_DATA_GET_DESC_STRING1 : constant is 1;
    attribute mti_svvh_generic_type of SEND_DATA_GET_DESC_STRING2 : constant is 1;
    attribute mti_svvh_generic_type of SEND_DATA_GET_LINE_CODING : constant is 1;
    attribute mti_svvh_generic_type of SEND_DATA_TEST_MESSAGE : constant is 1;
    attribute mti_svvh_generic_type of RECV_TX_DATA : constant is 1;
    attribute mti_svvh_generic_type of SEND_DATA_TEST_MESSAGE_RX : constant is 1;
end ls_usb_core;
