module ls_usb_sender(
	input wire clk,
	input wire EOP,
	input wire core_strobe,
	input wire SOP,
	input wire [7:0] send_reg,
	input wire sEOP,
	input wire sdata_ready,
	output reg dp_out,
	output reg dm_out,
	output wire strobe,
	output reg d_out_enable,
	output wire sixone_signal 
	);
	
	reg [6:0] sEOP_delay;
	//parameter delay = 3; // задержка на передачу на линии dp/dm
	
	reg [7:0] out;
	
	reg [6:0]clk_counter;
	
	reg serial_shift;
	
	reg NRZI_coding;
	
	reg out_enable;
	
	//reg [delay+4:0] sEOP_shift;
	
	assign strobe  = clk_counter[6];
	
	reg [7:0] sixone_counter;
	
	assign sixone_signal = sixone_counter[6];
	
/*always @(posedge strobe)	
begin
if(sEOP)
begin
sEOP_shift[delay+4:1] <= sEOP_shift[delay+3:0];
end
else
begin
sEOP_shift <= 7'b01;
end
end*/

always @(posedge core_strobe)
begin
if(sEOP)
begin
//if(!sixone_signal)
//begin
sEOP_delay[6:1] <= sEOP_delay[5:0];
sEOP_delay[0] <= 0;
//end
end
else
begin
sEOP_delay <= 7'b000011;
end
end

always @(posedge clk)
begin	
if(SOP)
clk_counter <= 6'b001111;
else
begin
if(clk_counter == 0)
clk_counter <= 6'b001111;
else
clk_counter <= clk_counter << 1;
end
end

reg do_bitstaff;
	
	always @(posedge core_strobe or posedge sdata_ready)
	begin
	if(sdata_ready)
	begin
	if(EOP)
	begin
	dp_out <= 0;
	dm_out <= 1;
	NRZI_coding <= 0;
	end
	out[7:0] <= send_reg;
	do_bitstaff <= 0;
	end
	else
	begin
	if(sixone_counter[6])
   begin
	do_bitstaff <= 1;
	end
	else
	begin
	if(do_bitstaff)
	begin
	NRZI_coding <= !NRZI_coding ^ 0;
	do_bitstaff <= 0;
	{out[6:0],serial_shift} <= out;
	out[7] <= 0;   //Чтобы добавить stuffed 0, надо отодвинуть sdata_ready на такт
	end
	else
	begin
	{out[6:0],serial_shift} <= out;
	out[7] <= 0;
	NRZI_coding <= !NRZI_coding ^ serial_shift;
	end
	end
	if(sEOP_delay[3])
	begin
	dp_out <= 0;
	dm_out <= 0;
	end
	else
	begin
	dp_out <= !NRZI_coding;
	dm_out <= NRZI_coding;
	end
	end
	end
	
	/*always @(posedge dp_out or posedge sEOP_shift[7])
	begin
	if(sEOP_shift[7])
	d_out_enable <= 0;
	else
	d_out_enable <= 1;
	end*/
	
	always @(negedge core_strobe)
	begin
	if(serial_shift)
	begin
	sixone_counter[7:1] <= sixone_counter[6:0];
	sixone_counter[0] <= 0;
	end
	else
	begin
	sixone_counter <= 8'b01;
	end
	end
	
	always @(posedge out[5] or posedge sEOP_delay[6]) // на сигнале SYNC в сдвиговом регистре out
	begin
	if(sEOP_delay[6])
	d_out_enable <=0;
	else
	d_out_enable <=1;
	end
	
	endmodule 