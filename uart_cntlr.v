module uart_cntlr(
input uart_clk,
input rbyteready,
input EOP,
input wire [7:0] uart_tx_byte,
output reg [7:0] uart_rx_byte,
output reg uart_tx_com1,
input uart_rx_com1,
input uart_tx_en,
input usb_clk,
output reg uart_tx_com2,
output reg uart_rx_done,
input uart_rx_com2
);


reg [7:0] tx_byte_QUEUE [31:0];
reg [4:0] tx_QUEUE_core_pointer;
reg [4:0] tx_QUEUE_uart_pointer;
//reg [4:0] tx_QUEUE_uart_command_pointer;
reg [4:0] tx_QUEUE_core_last_val;
reg [7:0] TX_buffer;
reg [8:0] TX_shift;
reg [7:0] RX_buffer;
reg [9:0] RX_shift;
reg tx_data_ready;
reg [3:0] tx_data_ready_counter;
reg rx_data_ready;
reg [3:0] rx_data_ready_counter;
reg uart_tx;
reg uart_rx;
reg [1:0] is_command_counter;
reg is_command;
reg [7:0] com_port_number;

wire [4:0] tx_QUEUE_pointer;
assign tx_QUEUE_pointer = uart_tx_en ? tx_QUEUE_core_pointer : tx_QUEUE_uart_pointer;

//reg [11:0] txbytepointerQUEUE;

/*always@(posedge rbyteready)
begin
txbytepointerQUEUE <= {tx_QUEUE_core_pointer,uart_tx_byte};
end*/

always@(posedge rbyteready)
begin
case({tx_QUEUE_core_pointer,uart_tx_byte})
12'h043:
begin
//if(uart_tx_byte == 8'h43)
//com_port_number <= 8'h31;
{is_command,is_command_counter} <= is_command_counter + 1;
//else
//{is_command,is_command_counter} <= 0;
end
12'h14F:
begin
//if(uart_tx_byte == 8'h4F)
//com_port_number <= 8'h31;
{is_command,is_command_counter} <= is_command_counter + 1;
//else
//{is_command,is_command_counter} <= 0;
end
12'h24D:
begin
//if(uart_tx_byte == 8'h4D)
//com_port_number <= 8'h31;
{is_command,is_command_counter} <= is_command_counter + 1;
//else
//{is_command,is_command_counter} <= 0;
end
12'h331:
begin
{is_command,is_command_counter} <= is_command_counter + 1;
end
12'h332:
begin
{is_command,is_command_counter} <= is_command_counter + 1;
end
default: 
begin
//com_port_number <= 8'h0;
{is_command,is_command_counter} <= 0;
end
endcase
end

always@(posedge is_command)
begin
com_port_number[7:0] <= uart_tx_byte[7:0];
end

always@*
begin
if(com_port_number == 8'h31)
begin
uart_tx_com1 = uart_tx;
uart_tx_com2 = 1;
uart_rx = uart_rx_com1;
end
else if(com_port_number == 8'h32)
begin
uart_tx_com1 = 1;
uart_tx_com2 = uart_tx;
uart_rx = uart_rx_com2;
end
else
begin
uart_tx_com1 = uart_tx;
uart_tx_com2 = 1;
uart_rx = uart_rx_com1;
end
end

/*always@*
begin
if(tx_byte_QUEUE[0] == 8'h43 && tx_byte_QUEUE[1] == 8'h4F && tx_byte_QUEUE[2] == 8'h4D && tx_byte_QUEUE[3] == 8'h31)
begin
uart_tx_com1 = uart_tx;
uart_tx_com2 = 1;
end
else if(tx_byte_QUEUE[0] == 8'h43 && tx_byte_QUEUE[1] == 8'h4F && tx_byte_QUEUE[2] == 8'h4D && tx_byte_QUEUE[3] == 8'h32)
begin
uart_tx_com1 = 1;
uart_tx_com2 = uart_tx;
end
else
begin
uart_tx_com1 = uart_tx;
uart_tx_com2 = 1;
end
end*/

always@(posedge rbyteready)
begin
if(!uart_tx_en)
begin
tx_QUEUE_core_pointer <= 0;
end
else
begin
tx_QUEUE_core_pointer <= tx_QUEUE_core_pointer + 1;
tx_QUEUE_core_last_val <= tx_QUEUE_core_pointer;
end
end

always@(posedge uart_clk)
begin
if(uart_tx_en)
begin
tx_data_ready <= 0;
tx_data_ready_counter <= 0;
end
else
begin
if(tx_data_ready_counter < 4'b1010)
begin
tx_data_ready <= 0;
//{tx_data_ready,tx_data_ready_counter} <=  tx_data_ready_counter + 1;
tx_data_ready_counter <=  tx_data_ready_counter + 1;
end
else
begin
tx_data_ready <= 1;
tx_data_ready_counter <=  0;
end
end
end

always@(posedge usb_clk)
begin
if(!uart_tx_en)
begin
TX_buffer <= tx_byte_QUEUE[tx_QUEUE_pointer];
end
else
begin
TX_buffer <= 8'hFF;
tx_byte_QUEUE[tx_QUEUE_pointer] <= uart_tx_byte;
end
end

always@(posedge uart_clk)
begin
if(uart_tx_en)
begin
tx_QUEUE_uart_pointer <= 0;
{TX_shift[8:0],uart_tx} <= 10'h3FF;
end
else
begin
if(!tx_data_ready)
begin
{TX_shift[7:0],uart_tx} <= TX_shift[8:0];
end
else
begin
if(tx_QUEUE_uart_pointer < tx_QUEUE_core_last_val)
begin
tx_QUEUE_uart_pointer <= tx_QUEUE_uart_pointer + 1;
{TX_shift[8:0],uart_tx} <= {1'b1,TX_buffer[7:0],1'b0};
end
else
begin
tx_QUEUE_uart_pointer <= tx_QUEUE_core_last_val;
{TX_shift[8:0],uart_tx} <= 10'h3FF;
end
end
end
end

//РџСЂРёРµРј

always@(posedge uart_clk)
begin
RX_shift[9:0] <= {uart_rx,RX_shift[9:1]};
end

always@(posedge uart_clk)
begin
if(RX_shift != 10'h3FF)
begin
if(rx_data_ready_counter < 4'b1001)
begin
uart_rx_done <= 0;
uart_rx_byte <= 0;
rx_data_ready_counter <= rx_data_ready_counter + 1;
end
else
begin
uart_rx_done <= 1;
uart_rx_byte <= RX_shift[8:1];
rx_data_ready_counter <= 0;
end
end
else
begin
rx_data_ready_counter <= 0;
uart_rx_done <= 0;
uart_rx_byte <= 0;
end
end


endmodule
