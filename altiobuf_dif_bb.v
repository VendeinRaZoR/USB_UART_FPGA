// megafunction wizard: %ALTIOBUF%VBB%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: altiobuf_bidir 

// ============================================================
// File Name: altiobuf_dif.v
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

module altiobuf_dif (
	datain,
	oe,
	oe_b,
	dataio,
	dataio_b,
	dataout)/* synthesis synthesis_clearbox = 1 */;

	input	[0:0]  datain;
	input	[0:0]  oe;
	input	[0:0]  oe_b;
	inout	[0:0]  dataio;
	inout	[0:0]  dataio_b;
	output	[0:0]  dataout;

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
// Retrieval info: CONSTANT: use_differential_mode STRING "TRUE"
// Retrieval info: CONSTANT: use_dynamic_termination_control STRING "FALSE"
// Retrieval info: CONSTANT: use_termination_control STRING "FALSE"
// Retrieval info: USED_PORT: datain 0 0 1 0 INPUT NODEFVAL "datain[0..0]"
// Retrieval info: USED_PORT: dataio 0 0 1 0 BIDIR NODEFVAL "dataio[0..0]"
// Retrieval info: USED_PORT: dataio_b 0 0 1 0 BIDIR NODEFVAL "dataio_b[0..0]"
// Retrieval info: USED_PORT: dataout 0 0 1 0 OUTPUT NODEFVAL "dataout[0..0]"
// Retrieval info: USED_PORT: oe 0 0 1 0 INPUT NODEFVAL "oe[0..0]"
// Retrieval info: USED_PORT: oe_b 0 0 1 0 INPUT NODEFVAL "oe_b[0..0]"
// Retrieval info: CONNECT: @datain 0 0 1 0 datain 0 0 1 0
// Retrieval info: CONNECT: @oe 0 0 1 0 oe 0 0 1 0
// Retrieval info: CONNECT: @oe_b 0 0 1 0 oe_b 0 0 1 0
// Retrieval info: CONNECT: dataio 0 0 1 0 @dataio 0 0 1 0
// Retrieval info: CONNECT: dataio_b 0 0 1 0 @dataio_b 0 0 1 0
// Retrieval info: CONNECT: dataout 0 0 1 0 @dataout 0 0 1 0
// Retrieval info: GEN_FILE: TYPE_NORMAL altiobuf_dif.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL altiobuf_dif.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL altiobuf_dif.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL altiobuf_dif.bsf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL altiobuf_dif_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL altiobuf_dif_bb.v TRUE
// Retrieval info: LIB_FILE: cycloneive
