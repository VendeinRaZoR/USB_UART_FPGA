// megafunction wizard: %ALTIOBUF%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: altiobuf_bidir 

// ============================================================
// File Name: altiobuf.v
// Megafunction Name(s):
// 			altiobuf_bidir
//
// Simulation Library Files(s):
// 			cycloneive
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 13.0.1 Build 232 06/12/2013 SP 1 SJ Web Edition
// ************************************************************


//Copyright (C) 1991-2013 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.


//altiobuf_bidir CBX_AUTO_BLACKBOX="ALL" DEVICE_FAMILY="Cyclone III" ENABLE_BUS_HOLD="FALSE" NUMBER_OF_CHANNELS=1 OPEN_DRAIN_OUTPUT="FALSE" USE_DIFFERENTIAL_MODE="FALSE" USE_DYNAMIC_TERMINATION_CONTROL="FALSE" USE_TERMINATION_CONTROL="FALSE" datain dataio dataout oe
//VERSION_BEGIN 13.0 cbx_altiobuf_bidir 2013:04:24:18:08:47:SJ cbx_mgl 2013:04:24:18:11:10:SJ cbx_stratixiii 2013:04:24:18:08:47:SJ cbx_stratixv 2013:04:24:18:08:47:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463


//synthesis_resources = cycloneiii_io_ibuf 1 cycloneiii_io_obuf 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  altiobuf_iobuf_bidir_30p
	( 
	datain,
	dataio,
	dataout,
	oe) ;
	input   [0:0]  datain;
	inout   [0:0]  dataio;
	output   [0:0]  dataout;
	input   [0:0]  oe;

	wire  [0:0]   wire_ibufa_o;
	wire  [0:0]   wire_obufa_o;

	cycloneiii_io_ibuf   ibufa_0
	( 
	.i(dataio),
	.o(wire_ibufa_o[0:0])
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.ibar(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	);
	defparam
		ibufa_0.bus_hold = "false",
		ibufa_0.differential_mode = "false",
		ibufa_0.lpm_type = "cycloneiii_io_ibuf";
	cycloneiii_io_obuf   obufa_0
	( 
	.i(datain),
	.o(wire_obufa_o[0:0]),
	.obar(),
	.oe(oe)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.seriesterminationcontrol({16{1'b0}})
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devoe(1'b1)
	// synopsys translate_on
	);
	defparam
		obufa_0.bus_hold = "false",
		obufa_0.open_drain_output = "false",
		obufa_0.lpm_type = "cycloneiii_io_obuf";
	assign
		dataio = wire_obufa_o,
		dataout = wire_ibufa_o;
endmodule //altiobuf_iobuf_bidir_30p
//VALID FILE


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module altiobuf (
	datain,
	oe,
	dataio,
	dataout);

	input	[0:0]  datain;
	input	[0:0]  oe;
	inout	[0:0]  dataio;
	output	[0:0]  dataout;

	wire [0:0] sub_wire0;
	wire [0:0] dataout = sub_wire0[0:0];

	altiobuf_iobuf_bidir_30p	altiobuf_iobuf_bidir_30p_component (
				.dataio (dataio),
				.datain (datain),
				.oe (oe),
				.dataout (sub_wire0));

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: CONSTANT: enable_bus_hold STRING "FALSE"
// Retrieval info: CONSTANT: number_of_channels NUMERIC "1"
// Retrieval info: CONSTANT: open_drain_output STRING "FALSE"
// Retrieval info: CONSTANT: use_differential_mode STRING "FALSE"
// Retrieval info: CONSTANT: use_dynamic_termination_control STRING "FALSE"
// Retrieval info: CONSTANT: use_termination_control STRING "FALSE"
// Retrieval info: USED_PORT: datain 0 0 1 0 INPUT NODEFVAL "datain[0..0]"
// Retrieval info: USED_PORT: dataio 0 0 1 0 BIDIR NODEFVAL "dataio[0..0]"
// Retrieval info: USED_PORT: dataout 0 0 1 0 OUTPUT NODEFVAL "dataout[0..0]"
// Retrieval info: USED_PORT: oe 0 0 1 0 INPUT NODEFVAL "oe[0..0]"
// Retrieval info: CONNECT: @datain 0 0 1 0 datain 0 0 1 0
// Retrieval info: CONNECT: @oe 0 0 1 0 oe 0 0 1 0
// Retrieval info: CONNECT: dataio 0 0 1 0 @dataio 0 0 1 0
// Retrieval info: CONNECT: dataout 0 0 1 0 @dataout 0 0 1 0
// Retrieval info: GEN_FILE: TYPE_NORMAL altiobuf.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL altiobuf.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL altiobuf.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL altiobuf.bsf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL altiobuf_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL altiobuf_bb.v TRUE
// Retrieval info: LIB_FILE: cycloneive

