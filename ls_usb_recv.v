
//simplest low speed USB receive function

module ls_usb_recv(

	//clock should be 5Mhz
	input wire clk,

	//usb BUS signals
	input wire dp,
	input wire dm,
   input wire d_out_enable,
	input wire alternate_strobe,
	output reg EOP,

	//output received bytes interface
	output reg [7:0]rdata,
	output reg rdata_ready,
	output wire strobe,
	output reg SOP
	);

	
wire dnrzi;
//generate clocks with this counter
reg [6:0]clk_counter;

reg [2:0] EOP_counter;

reg [2:0] byteready_counter;

////////////////////////////////////////////////////////
//receiver regs
////////////////////////////////////////////////////////

//fix current USB line values
wire dpw,dmw;
reg dp_input;
reg dm_input;
buf dpbuf(dpw,dp);
buf dmbuf(dmw,dm);


reg delnrzi;

always @(posedge clk or posedge d_out_enable)
begin		
if(d_out_enable)
begin
dp_input <= 0;
dm_input <= 1;
end
else
begin
	dp_input <= dpw;
	dm_input <= dmw;
end
	end
//if both lines in ZERO this is low speed EOP
//EOP reinitializes receiver
assign EOP_condition  = !(dp_input | dm_input | dmw | dpw); //Условие срабатывания сигнала End-Of-Packet
wire dp_change; //Изменение состояния на линии DP
assign dp_change = dpw ^ dp_input;
//assign strobe  = alternate_strobe; // внешний строб 1.5 МГц для Low Speed прямо с ФАПЧ без синхронизации
assign strobe  = clk_counter[6]; // внутренний строб с поддержкой синхронизации NRZI

always @(posedge clk or posedge dm_input) //Нужно для гарантированного EOP в течении 8 тактов,  
begin ///так как сигнал EOP_condition может сработать во время приема пакета при DM и DP = 0
if(dm_input)
EOP <= 0; //По сигналу DM очищаем регистр EOP
else
begin
if(EOP_condition) //Короче, если EOP_condition в течении 8 тактов (1-ый строб) - значит это EOP
begin
if(EOP_counter != 0)
{EOP,EOP_counter} <= EOP_counter + 1;
end
else
begin
EOP_counter <= 1;
end
end
end

//прием пакета и деление частоты
always @(posedge clk or posedge EOP)
begin	
if(EOP)
clk_counter <= 7'b001111;
else
begin
if(dp_change || clk_counter == 0)
begin
clk_counter <= 7'b001111;
end
else
begin
clk_counter <= clk_counter << 1;
end
end
end

wire delnrziw;
wire outnrzi;
assign delnrziw = !(dpw ^ delnrzi);
assign dnrzi = delnrziw;


always @(posedge strobe or posedge EOP)
begin ///избавляемся от NRZI и bit unstaffing
if(EOP)
begin
byteready_counter <= 0;
rdata <= 0;
rdata_ready <= 0;
end
else
begin
if(SOP)
begin
delnrzi <= dpw;
if(!((rdata == 8'b11111100) && (delnrziw == 0)))
begin
rdata <= {delnrziw,rdata[7:1]};
{rdata_ready,byteready_counter} <= byteready_counter + 1'b01;
end
end
end
end

always @(posedge dp_input or posedge EOP)
begin ///Импульс-маркер, который длится в течении всего пакета
if(EOP)
SOP = 0;
else 
SOP = 1;
end 

endmodule
