
//simplest low speed USB receive function

module ls_usb_recver(

	//clock should be 5Mhz
	input wire clk,

	//usb BUS signals
	input wire dp,
	input wire dm,

	output wire EOP,

	//output received bytes interface
	output reg [7:0]rdata,
	output reg rdata_ready,
	output reg [3:0]rbyte_cnt
	);

//generate clocks with this counter
reg [5:0]clk_counter;
reg strobe;

////////////////////////////////////////////////////////
//receiver regs
////////////////////////////////////////////////////////

reg [2:0]receiver_cnt;
reg last_fixed_dp;
reg receiver_enabled;

//fix current USB line values

reg [1:0]dp_input;
reg [1:0]dm_input;

always @(posedge clk)
begin		
	dp_input <= { dp_input[0], dp };
	dm_input <= { dm_input[0], dm };
end

//if both lines in ZERO this is low speed EOP
//EOP reinitializes receiver
assign EOP  = !(dp_input[0] | dp_input[1] | dm_input[0] | dm_input[1]);

//change on DP line defines strobing
wire dp_change;
assign dp_change = dp_input[0] ^ dp_input[1];

//flag which mean that zero should be removed from bit stream
wire do_remove_zero;
assign do_remove_zero = (rdata[7:2]==6'b111111) & (last_fixed_dp != dp_input[1]) & (!removed_zero);

//flag that zero was removed from bit stream
reg removed_zero;

//receiver process
always @(posedge clk or posedge EOP )
begin		
	if(EOP)
	begin
		//kind of reset
		receiver_cnt <= 0;
		rbyte_cnt <= 0;
		last_fixed_dp <= 1'b0;
		rdata <= 0;
		receiver_enabled <= 1'b0;
		rdata_ready <= 1'b0;
		clk_counter <= 1'b0;
		strobe <= 1'b0;
		removed_zero <= 1'b0;
	end
	else
	begin		
		//every edge on line resynchronizes receiver clock
		if(dp_change)
		begin
			clk_counter <= 0;
			strobe <= 1'b1;
		end
		else
		begin
			{ strobe , clk_counter } <= clk_counter + 6'h13;
		end

		//enable receiver on raising edge of DP line
		if( dp_input[0] )
		begin
			receiver_enabled <= 1'b1;
		end

		if(strobe & receiver_enabled & (!do_remove_zero))
		begin
			//decode NRZI
			//shift-in ONE  if older and new values are same
			//shift-in ZERO if older and new values are different
			//BUT (bitstuffling) do not shift-in one ZERO after 6 ONEs
			rdata  <= { (last_fixed_dp == dp_input[1]) , rdata[7:1]};
			receiver_cnt <= receiver_cnt + 1'b1;	
		end

		//set write-enable signal (write into receiver buffer)
		rdata_ready <= (receiver_cnt == 7) & (strobe & receiver_enabled & (!do_remove_zero));
		
		if(strobe & receiver_enabled)
		begin
			removed_zero <= do_remove_zero;
			last_fixed_dp <= dp_input[1];
		end

		if(rdata_ready)
			rbyte_cnt <= rbyte_cnt + 1'b1;
	end
end

endmodule
