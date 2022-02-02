// Generated by PCI Compiler 13.0 [Altera, IP Toolbench 1.3.0 Build 232]
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
// ************************************************************
// Copyright (C) 1991-2017 Altera Corporation
// Any megafunction design, and related net list (encrypted or decrypted),
// support information, device programming or simulation file, and any other
// associated documentation or information provided by Altera or a partner
// under Altera's Megafunction Partnership Program may be used only to
// program PLD devices (but not masked PLD devices) from Altera.  Any other
// use of such megafunction design, net list, support information, device
// programming or simulation file, or any other related documentation or
// information is prohibited for any other purpose, including, but not
// limited to modification, reverse engineering, de-compiling, or use with
// any other silicon devices, unless such use is explicitly licensed under
// a separate agreement with Altera or a megafunction partner.  Title to
// the intellectual property, including patents, copyrights, trademarks,
// trade secrets, or maskworks, embodied in any such megafunction design,
// net list, support information, device programming or simulation file, or
// any other related documentation or information provided by Altera or a
// megafunction partner, remains with Altera, the megafunction partner, or
// their respective licensors.  No other licenses, including any licenses
// needed under any third party's intellectual property, are provided herein.

module pci (
	clk,
	rstn,
	gntn,
	idsel,
	l_adi,
	l_cbeni,
	lm_req32n,
	lm_lastn,
	lm_rdyn,
	lt_rdyn,
	lt_abortn,
	lt_discn,
	lirqn,
	framen,
	irdyn,
	devseln,
	trdyn,
	stopn,
	intan,
	reqn,
	serrn,
	l_adro,
	l_dato,
	l_beno,
	l_cmdo,
	lm_adr_ackn,
	lm_ackn,
	lm_dxfrn,
	lm_tsr,
	lt_framen,
	lt_ackn,
	lt_dxfrn,
	lt_tsr,
	cmd_reg,
	stat_reg,
	cache,
	ad,
	cben,
	par,
	perrn);

	input		clk;
	input		rstn;
	input		gntn;
	input		idsel;
	input	[31:0]	l_adi;
	input	[3:0]	l_cbeni;
	input		lm_req32n;
	input		lm_lastn;
	input		lm_rdyn;
	input		lt_rdyn;
	input		lt_abortn;
	input		lt_discn;
	input		lirqn;
	inout		framen;
	inout		irdyn;
	inout		devseln;
	inout		trdyn;
	inout		stopn;
	output		intan;
	output		reqn;
	output		serrn;
	output	[31:0]	l_adro;
	output	[31:0]	l_dato;
	output	[3:0]	l_beno;
	output	[3:0]	l_cmdo;
	output		lm_adr_ackn;
	output		lm_ackn;
	output		lm_dxfrn;
	output	[9:0]	lm_tsr;
	output		lt_framen;
	output		lt_ackn;
	output		lt_dxfrn;
	output	[11:0]	lt_tsr;
	output	[6:0]	cmd_reg;
	output	[6:0]	stat_reg;
	output	[7:0]	cache;
	inout	[31:0]	ad;
	inout	[3:0]	cben;
	inout		par;
	inout		perrn;
endmodule