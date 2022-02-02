
//simplest low speed USB send function

module ls_usb_send(

	//clock should be 5Mhz
	input wire clk,
	input wire reset,

	input wire [7:0]sbyte,  //byte for send
	input wire start_pkt,	//start sending packet on that signal
	input wire last_pkt_byte,  //mean send EOP at the end

	//usb BUS signals
	output reg sbit,
	output reg dp,
	output reg dm,
	
	output reg  bus_enable,
	output reg  show_next,	//on that signal core should send next byte for send and flag for last packet byte
	output wire six_ones
	);

assign six_ones = (ones_cnt==3'h6);

reg [2:0]ones_cnt;

reg [2:0]bit_count;
wire bit_count_eq7; assign bit_count_eq7 = (bit_count==3'h7);

//reg do_eop;
reg prev_sbit;
reg my_eop;

always @*
begin
	sbit = prev_sbit^(send_reg[0]==1'b0)^(six_ones&send_reg[0]);
		
	dm =   sbit  & my_eop;
	dp = (!sbit) & my_eop;
	show_next = bit_count_eq7 & strobe & (!six_ones);
	bus_enable = bus_ena | bus_ena_prev[1];
	my_eop = !(bus_ena ^ (bus_ena | bus_ena_prev[1]));
end

reg [7:0]send_reg;
reg last;

//generate send strobes only when bus enabled 
reg [5:0]clk_counter;
reg strobe;
reg bus_ena;
reg [1:0]bus_ena_prev;

always @(posedge clk or posedge start_pkt)
begin
	if(start_pkt)
	begin
		strobe <= 1'b0;
		clk_counter <= 0;
	end
	else
		{ strobe , clk_counter } <= clk_counter + 6'h13;
end

always @(posedge clk)
begin
	if(strobe)
		bus_ena_prev <= {bus_ena_prev[0],bus_ena};
end

always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		prev_sbit <= 1'b0;
		bit_count <= 7;
		send_reg <= 0;
		bus_ena <= 1'b0;
		last <= 1'b0;
		ones_cnt <= 0;
	end	
	else
	begin
	
		if(strobe & bus_ena)
		begin
			if(sbit==prev_sbit)
				ones_cnt <= ones_cnt+1'b1;
			else
				ones_cnt <= 0;
		end
		
		if( (bit_count_eq7 & last & strobe) | start_pkt)
			bus_ena <= !bus_ena;
		
		if(strobe & bus_ena)
			prev_sbit <= sbit;

		if(strobe & bus_ena & bit_count_eq7)
			last <= last_pkt_byte;
	
		if(strobe & bus_ena & (!six_ones))
		begin	 
			bit_count <= bit_count + 1'b1;
			if(bit_count_eq7)
				send_reg <= sbyte;
			else
				send_reg <= {1'b0, send_reg[7:1]};
		end

	end
end

endmodule
