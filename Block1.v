// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 32-bit"
// VERSION		"Version 13.0.0 Build 156 04/24/2013 SJ Web Edition"
// CREATED		"Mon Dec 18 00:18:45 2017"

module Block1(
	RX_COM1,
	RX_COM2,
	usb_clk,
	uart_clk,
	tx_clk,
	TX_COM1,
	TX_COM2,
	d_out_enable,
	TX_COM_LED1,
	TX_COM_LED2,
	dp_inout,
	dm_inout
);


input wire	RX_COM1;
input wire	RX_COM2;
input wire	usb_clk;
input wire	uart_clk;
output wire	tx_clk;
output wire	TX_COM1;
output wire	TX_COM2;
output wire	d_out_enable;
output wire	TX_COM_LED1;
output wire	TX_COM_LED2;
inout wire	dp_inout;
inout wire	dm_inout;

wire	[0:0] SYNTHESIZED_WIRE_0;
wire	[0:0] SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_27;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_28;
wire	SYNTHESIZED_WIRE_29;
wire	SYNTHESIZED_WIRE_9;
wire	SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_11;
wire	SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_13;
wire	[7:0] SYNTHESIZED_WIRE_14;
wire	[7:0] SYNTHESIZED_WIRE_15;
wire	SYNTHESIZED_WIRE_18;
wire	[7:0] SYNTHESIZED_WIRE_19;
wire	SYNTHESIZED_WIRE_20;
wire	SYNTHESIZED_WIRE_21;
wire	SYNTHESIZED_WIRE_23;
wire	SYNTHESIZED_WIRE_24;
wire	SYNTHESIZED_WIRE_25;
wire	[7:0] SYNTHESIZED_WIRE_26;

assign	tx_clk = uart_clk;
assign	d_out_enable = dp_inout;
assign	TX_COM1 = SYNTHESIZED_WIRE_20;
assign	TX_COM2 = SYNTHESIZED_WIRE_21;




ls_usb_recv	b2v_inst(
	.clk(usb_clk),
	.dp(SYNTHESIZED_WIRE_0),
	.dm(SYNTHESIZED_WIRE_1),
	.d_out_enable(SYNTHESIZED_WIRE_27),
	.alternate_strobe(uart_clk),
	.EOP(SYNTHESIZED_WIRE_28),
	.rdata_ready(SYNTHESIZED_WIRE_29),
	.strobe(SYNTHESIZED_WIRE_9),
	.SOP(SYNTHESIZED_WIRE_10),
	.rdata(SYNTHESIZED_WIRE_14));


altiobuf0	b2v_inst14(
	.datain(SYNTHESIZED_WIRE_3),
	.dataio(dm_inout),
	.oe(SYNTHESIZED_WIRE_27),
	
	.dataout(SYNTHESIZED_WIRE_1));


altiobuf0	b2v_inst15(
	.datain(SYNTHESIZED_WIRE_5),
	.dataio(dp_inout),
	.oe(SYNTHESIZED_WIRE_27),
	
	.dataout(SYNTHESIZED_WIRE_0));


ls_usb_core	b2v_inst2(
	.clk(usb_clk),
	.EOP(SYNTHESIZED_WIRE_28),
	.rdata_ready(SYNTHESIZED_WIRE_29),
	.strobe(SYNTHESIZED_WIRE_9),
	.SOP(SYNTHESIZED_WIRE_10),
	.strobe_sender(SYNTHESIZED_WIRE_11),
	.sixone_signal(SYNTHESIZED_WIRE_12),
	.RX_DONE(SYNTHESIZED_WIRE_13),
	.rdata(SYNTHESIZED_WIRE_14),
	.RX_byte(SYNTHESIZED_WIRE_15),
	
	.sEOP(SYNTHESIZED_WIRE_24),
	.sdata_ready(SYNTHESIZED_WIRE_25),
	.btrdcnt_strobe(SYNTHESIZED_WIRE_23),
	.TX_EN(SYNTHESIZED_WIRE_18),
	.send_reg(SYNTHESIZED_WIRE_26),
	.TX_byte_CRC(SYNTHESIZED_WIRE_19));
	defparam	b2v_inst2.IDLE = 0;
	defparam	b2v_inst2.RECV_DATA = 1;
	defparam	b2v_inst2.RECV_TX_DATA = 13;
	defparam	b2v_inst2.SEND_ACK = 4;
	defparam	b2v_inst2.SEND_DATA1_NULL = 5;
	defparam	b2v_inst2.SEND_DATA_GET_DESC = 2;
	defparam	b2v_inst2.SEND_DATA_GET_DESC_CONFIGURATION = 6;
	defparam	b2v_inst2.SEND_DATA_GET_DESC_CONFIGURATION_FULL = 7;
	defparam	b2v_inst2.SEND_DATA_GET_DESC_FULL = 3;
	defparam	b2v_inst2.SEND_DATA_GET_DESC_STRING0 = 8;
	defparam	b2v_inst2.SEND_DATA_GET_DESC_STRING1 = 9;
	defparam	b2v_inst2.SEND_DATA_GET_DESC_STRING2 = 10;
	defparam	b2v_inst2.SEND_DATA_GET_LINE_CODING = 11;
	defparam	b2v_inst2.SEND_DATA_TEST_MESSAGE = 12;
	defparam	b2v_inst2.SEND_DATA_TEST_MESSAGE_RX = 14;


uart_controller	b2v_inst3(
	.uart_clk(uart_clk),
	.rbyteready(SYNTHESIZED_WIRE_29),
	.EOP(SYNTHESIZED_WIRE_28),
	.uart_rx_com1(RX_COM1),
	.uart_tx_en(SYNTHESIZED_WIRE_18),
	.usb_clk(usb_clk),
	.uart_rx_com2(RX_COM2),
	.uart_tx_byte(SYNTHESIZED_WIRE_19),
	.uart_tx_com1(SYNTHESIZED_WIRE_20),
	.uart_tx_com2(SYNTHESIZED_WIRE_21),
	.uart_rx_done(SYNTHESIZED_WIRE_13),
	.uart_rx_byte(SYNTHESIZED_WIRE_15));

assign	TX_COM_LED2 =  ~SYNTHESIZED_WIRE_20;

assign	TX_COM_LED1 =  ~SYNTHESIZED_WIRE_21;


ls_usb_sender	b2v_inst7(
	.clk(usb_clk),
	.EOP(SYNTHESIZED_WIRE_28),
	
	.core_strobe(SYNTHESIZED_WIRE_23),
	
	.sEOP(SYNTHESIZED_WIRE_24),
	.sdata_ready(SYNTHESIZED_WIRE_25),
	
	
	.send_reg(SYNTHESIZED_WIRE_26),
	.dp_out(SYNTHESIZED_WIRE_5),
	.dm_out(SYNTHESIZED_WIRE_3),
	.strobe(SYNTHESIZED_WIRE_11),
	.d_out_enable(SYNTHESIZED_WIRE_27),
	.sixone_signal(SYNTHESIZED_WIRE_12));


endmodule
