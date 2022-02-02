module ls_usb_core(
	input wire clk,
	input wire EOP,
	input wire [7:0]rdata,
	input wire rdata_ready,
	input wire strobe,
	input wire SOP,
	input wire strobe_sender,
	input wire sixone_signal,
	output reg SETUP_token,
	output reg [7:0] send_reg,
	output reg sEOP,
	output reg sdata_ready,
	output wire btrdcnt_strobe,
	output reg [7:0] TX_byte_CRC, //TX_bytes with CRC
	input wire [7:0] RX_byte,
	output reg TX_EN,
	input RX_DONE
	);
	
	//Состояния
	parameter IDLE = 0;
	parameter RECV_DATA = 1;
	parameter SEND_DATA_GET_DESC = 2;
	parameter SEND_DATA_GET_DESC_FULL = 3;
	parameter SEND_ACK = 4;
	//parameter RECV_HANDSHAKE = 20;
	//parameter SEND_NACK = 100;
	//parameter SEND_DATA0_NULL = 50;
	parameter SEND_DATA1_NULL = 5;
	parameter SEND_DATA_GET_DESC_CONFIGURATION = 6;
	parameter SEND_DATA_GET_DESC_CONFIGURATION_FULL = 7;
	parameter SEND_DATA_GET_DESC_STRING0 = 8; //странно почему нельзя 8 ? Может косяк в машине состояний ? 
	parameter SEND_DATA_GET_DESC_STRING1 = 9; // вместо 8 выдается состояние 4...
	parameter SEND_DATA_GET_DESC_STRING2 = 10; //бывает и такая транзакция
	parameter SEND_DATA_GET_LINE_CODING = 11; //настройки COM порта
	
	parameter SEND_DATA_TEST_MESSAGE = 12; //посылаем тестовое сообщение на ПК (говорим что мы на связи)
	
	parameter RECV_TX_DATA = 13;
	
	parameter SEND_DATA_TEST_MESSAGE_RX = 14;
	
	//parameter SEND_DATA_RX_NULL = 15;
	
	
	reg [15:0] state;
	
	reg [11:0] bytenum;
	reg [8:0] PID_decoder;
	
	reg [5:0] byteready_counter;

	reg [15:0] ADDR_ENDP_CRC_decoder;
	reg [15:0] FRAMENUM_CRC_decoder;
	
	reg [7:0] bmRequestType;
	reg [7:0] bRequestCode;
	reg [15:0] wValue;
	reg [15:0] wIndex;
	reg [15:0] wLength;
	
	reg [7:0] FIFO_pointer;
	
	reg [7:0] device_address; //адрес устройства на шине
	
	reg [3:0] transac_counter;

	//reg [4:0] FIFO_init;
	
	reg [7:0] recv_packet[12:0];
	
	reg [2:0] EOP_delay;
	
	
	//wire xSEOP;
	//assign xSEOP = !(SOP ^ EOP);
	
	always @*
	begin
	if(SOP)
	begin
	sEOP <= 0;
	end
	else
	begin
	case(FIFO_pointer)
	8'h00: begin send_reg <= 8'b00000000; sEOP <= 0; end //RESERVED
	8'h01: begin send_reg <= 8'b10000000; sEOP <= 0; end//SEND_ACK
	8'h02: begin send_reg <= 8'b11010010; sEOP <= 0; end
	8'h03: begin send_reg <= 8'b0; sEOP <= 1; end //EOP и обнуляем "счетчик" пакетов
	/////////descriptor device
	8'h04: begin send_reg <= 8'b10000000; sEOP <= 0; end //SYNC
	8'h05: begin send_reg <= 8'b01001011; sEOP <= 0; end //DATA1, так как за SETUP идет DATA0 
	8'h06: begin send_reg <= 8'h12; sEOP <= 0; end
	8'h07: begin send_reg <= 8'h01; sEOP <= 0; end
	8'h08: begin send_reg <= 8'h10; sEOP <= 0; end//specification
	8'h09: begin send_reg <= 8'h01; sEOP <= 0; end//specification
	8'h0A: begin send_reg <= 8'h02; sEOP <= 0; end
	8'h0B: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h0C: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h0D: begin send_reg <= 8'h08; sEOP <= 0; end
	8'h0E: begin send_reg <= 8'h10; sEOP <= 0; end
	8'h0F: begin send_reg <= 8'hCF; sEOP <= 0; end
	8'h10: begin send_reg <= 8'b0; sEOP <= 1; end //EOP
	
	8'h11: begin send_reg <= 8'b10000000; sEOP <= 0; end //SYNC
	8'h12: begin send_reg <= 8'b11000011; sEOP <= 0; end //DATA0
	8'h13: begin send_reg <= 8'h74; sEOP <= 0; end
	8'h14: begin send_reg <= 8'h04; sEOP <= 0; end
	8'h15: begin send_reg <= 8'h01; sEOP <= 0; end
	8'h16: begin send_reg <= 8'h07; sEOP <= 0; end
	8'h17: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h18: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h19: begin send_reg <= 8'h01; sEOP <= 0; end
	8'h1A: begin send_reg <= 8'h02; sEOP <= 0; end
	8'h1B: begin send_reg <= 8'hC8; sEOP <= 0; end
	8'h1C: begin send_reg <= 8'hA3; sEOP <= 0; end
	8'h1D: begin send_reg <= 8'b0; sEOP <= 1; end
	
	8'h1E: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'h1F: begin send_reg <= 8'b01001011; sEOP <= 0; end
	8'h20: begin send_reg <= 8'h03; sEOP <= 0; end
	8'h21: begin send_reg <= 8'h01; sEOP <= 0; end
	8'h22: begin send_reg <= 8'h3F; sEOP <= 0; end 
	8'h23: begin send_reg <= 8'h7F; sEOP <= 0; end
	8'h24: begin send_reg <= 8'b0; sEOP <= 1; end
	/////////set addr
	8'h25: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'h26: begin send_reg <= 8'b01001011; sEOP <= 0; end
	8'h27: begin send_reg <= 8'b0; sEOP <= 0; end
	8'h28: begin send_reg <= 8'b0; sEOP <= 0; end
	8'h29: begin send_reg <= 8'b0; sEOP <= 1; end
	/////////configuration descriptor start
	8'h2A: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'h2B: begin send_reg <= 8'b01001011; sEOP <= 0; end //DATA1, так как за SETUP идет DATA0 
	8'h2C: begin send_reg <= 8'h09; sEOP <= 0; end
	8'h2D: begin send_reg <= 8'h02; sEOP <= 0; end 
	8'h2E: begin send_reg <= 8'h43; sEOP <= 0; end 
	8'h2F: begin send_reg <= 8'h00; sEOP <= 0; end 
	8'h30: begin send_reg <= 8'h02; sEOP <= 0; end 
	8'h31: begin send_reg <= 8'h01; sEOP <= 0; end 
	8'h32: begin send_reg <= 8'h00; sEOP <= 0; end 
	8'h33: begin send_reg <= 8'hE0; sEOP <= 0; end //далее тут надо подсчитать контрольные суммы и все такое
	8'h34: begin send_reg <= 8'h03; sEOP <= 0; end
	8'h35: begin send_reg <= 8'h5D; sEOP <= 0; end
	8'h36: begin send_reg <= 8'b0; sEOP <= 1; end
	
	8'h37: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'h38: begin send_reg <= 8'b11000011; sEOP <= 0; end
	8'h39: begin send_reg <= 8'h32; sEOP <= 0; end
	8'h3A: begin send_reg <= 8'hC1; sEOP <= 0; end
	8'h3B: begin send_reg <= 8'h6A; sEOP <= 0; end
	8'h3C: begin send_reg <= 8'h0; sEOP <= 1; end
	/////////configuration descriptor full
	8'h3D: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'h3E: begin send_reg <= 8'b11000011; sEOP <= 0; end
	8'h3F: begin send_reg <= 8'h32; sEOP <= 0; end
	8'h40: begin send_reg <= 8'h09; sEOP <= 0; end
	8'h41: begin send_reg <= 8'h04; sEOP <= 0; end
	8'h42: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h43: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h44: begin send_reg <= 8'h01; sEOP <= 0; end
	8'h45: begin send_reg <= 8'h02; sEOP <= 0; end
	8'h46: begin send_reg <= 8'h02; sEOP <= 0; end
	8'h47: begin send_reg <= 8'h74; sEOP <= 0; end
	8'h48: begin send_reg <= 8'hDC; sEOP <= 0; end
	8'h49: begin send_reg <= 8'h0; sEOP <= 1; end
	
	8'h4A: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'h4B: begin send_reg <= 8'b01001011; sEOP <= 0; end
	8'h4C: begin send_reg <= 8'h01; sEOP <= 0; end
	8'h4D: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h4E: begin send_reg <= 8'h05; sEOP <= 0; end
	8'h4F: begin send_reg <= 8'h24; sEOP <= 0; end
	8'h50: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h51: begin send_reg <= 8'h10; sEOP <= 0; end
	8'h52: begin send_reg <= 8'h01; sEOP <= 0; end
	8'h53: begin send_reg <= 8'h05; sEOP <= 0; end
	8'h54: begin send_reg <= 8'hCE; sEOP <= 0; end
	8'h55: begin send_reg <= 8'h3C; sEOP <= 0; end
	8'h56: begin send_reg <= 8'h0; sEOP <= 1; end
	
	8'h57: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'h58: begin send_reg <= 8'b11000011; sEOP <= 0; end
	8'h59: begin send_reg <= 8'h24; sEOP <= 0; end
	8'h5A: begin send_reg <= 8'h01; sEOP <= 0; end
	8'h5B: begin send_reg <= 8'h03; sEOP <= 0; end
	8'h5C: begin send_reg <= 8'h01; sEOP <= 0; end
	8'h5D: begin send_reg <= 8'h04; sEOP <= 0; end
	8'h5E: begin send_reg <= 8'h24; sEOP <= 0; end
	8'h5F: begin send_reg <= 8'h02; sEOP <= 0; end
	8'h60: begin send_reg <= 8'h0F; sEOP <= 0; end
	8'h61: begin send_reg <= 8'h91; sEOP <= 0; end
	8'h62: begin send_reg <= 8'h73; sEOP <= 0; end
	8'h63: begin send_reg <= 8'h0; sEOP <= 1; end
	
	8'h64: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'h65: begin send_reg <= 8'b01001011; sEOP <= 0; end
	8'h66: begin send_reg <= 8'h05; sEOP <= 0; end
	8'h67: begin send_reg <= 8'h24; sEOP <= 0; end
	8'h68: begin send_reg <= 8'h06; sEOP <= 0; end
	8'h69: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h6A: begin send_reg <= 8'h01; sEOP <= 0; end
	8'h6B: begin send_reg <= 8'h07; sEOP <= 0; end
	8'h6C: begin send_reg <= 8'h05; sEOP <= 0; end
	8'h6D: begin send_reg <= 8'h81; sEOP <= 0; end
	8'h6E: begin send_reg <= 8'h68; sEOP <= 0; end
	8'h6F: begin send_reg <= 8'hA2; sEOP <= 0; end
	8'h70: begin send_reg <= 8'h0; sEOP <= 1; end
	
	8'h71: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'h72: begin send_reg <= 8'b11000011; sEOP <= 0; end
	8'h73: begin send_reg <= 8'h03; sEOP <= 0; end
	8'h74: begin send_reg <= 8'h10; sEOP <= 0; end
	8'h75: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h76: begin send_reg <= 8'h20; sEOP <= 0; end
	8'h77: begin send_reg <= 8'h09; sEOP <= 0; end
	8'h78: begin send_reg <= 8'h04; sEOP <= 0; end
	8'h79: begin send_reg <= 8'h01; sEOP <= 0; end
	8'h7A: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h7B: begin send_reg <= 8'h2C; sEOP <= 0; end
	8'h7C: begin send_reg <= 8'h2A; sEOP <= 0; end
	8'h7D: begin send_reg <= 8'h0; sEOP <= 1; end
	
	8'h7E: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'h7F: begin send_reg <= 8'b01001011; sEOP <= 0; end
	8'h80: begin send_reg <= 8'h02; sEOP <= 0; end
	8'h81: begin send_reg <= 8'h0A; sEOP <= 0; end
	8'h82: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h83: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h84: begin send_reg <= 8'h04; sEOP <= 0; end
	8'h85: begin send_reg <= 8'h07; sEOP <= 0; end
	8'h86: begin send_reg <= 8'h05; sEOP <= 0; end
	8'h87: begin send_reg <= 8'h8A; sEOP <= 0; end
	8'h88: begin send_reg <= 8'hA6; sEOP <= 0; end
	8'h89: begin send_reg <= 8'h2B; sEOP <= 0; end
	8'h8A: begin send_reg <= 8'h0; sEOP <= 1; end
	
	8'h8B: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'h8C: begin send_reg <= 8'b11000011; sEOP <= 0; end
	8'h8D: begin send_reg <= 8'h02; sEOP <= 0; end
	8'h8E: begin send_reg <= 8'h40; sEOP <= 0; end
	8'h8F: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h90: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h91: begin send_reg <= 8'h07; sEOP <= 0; end
	8'h92: begin send_reg <= 8'h05; sEOP <= 0; end
	8'h93: begin send_reg <= 8'h0B; sEOP <= 0; end
	8'h94: begin send_reg <= 8'h02; sEOP <= 0; end
	8'h95: begin send_reg <= 8'hE8; sEOP <= 0; end
	8'h96: begin send_reg <= 8'h6D; sEOP <= 0; end
	8'h97: begin send_reg <= 8'h00; sEOP <= 1; end
	
	8'h98: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'h99: begin send_reg <= 8'b01001011; sEOP <= 0; end
	8'h9A: begin send_reg <= 8'h40; sEOP <= 0; end
	8'h9B: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h9C: begin send_reg <= 8'h00; sEOP <= 0; end
	8'h9D: begin send_reg <= 8'h8F; sEOP <= 0; end
	8'h9E: begin send_reg <= 8'hEB; sEOP <= 0; end
	8'h9F: begin send_reg <= 8'h00; sEOP <= 1; end
	//Descriptor String0
	8'hA0: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'hA1: begin send_reg <= 8'b01001011; sEOP <= 0; end
	8'hA2: begin send_reg <= 8'h04; sEOP <= 0; end
	8'hA3: begin send_reg <= 8'h03; sEOP <= 0; end
	8'hA4: begin send_reg <= 8'h09; sEOP <= 0; end
	8'hA5: begin send_reg <= 8'h04; sEOP <= 0; end
	8'hA6: begin send_reg <= 8'h09; sEOP <= 0; end
	8'hA7: begin send_reg <= 8'h78; sEOP <= 0; end
	8'hA8: begin send_reg <= 8'h00; sEOP <= 1; end
	//Descriptor String1
	8'hA9: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'hAA: begin send_reg <= 8'b01001011; sEOP <= 0; end
	8'hAB: begin send_reg <= 8'h20; sEOP <= 0; end
	8'hAC: begin send_reg <= 8'h03; sEOP <= 0; end
	8'hAD: begin send_reg <= 8'h53; sEOP <= 0; end
	8'hAE: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hAF: begin send_reg <= 8'h41; sEOP <= 0; end
	8'hB0: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hB1: begin send_reg <= 8'h4E; sEOP <= 0; end
	8'hB2: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hB3: begin send_reg <= 8'hA3; sEOP <= 0; end
	8'hB4: begin send_reg <= 8'h13; sEOP <= 0; end
	8'hB5: begin send_reg <= 8'h0; sEOP <= 1; end
	
	8'hB6: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'hB7: begin send_reg <= 8'b11000011; sEOP <= 0; end
	8'hB8: begin send_reg <= 8'h59; sEOP <= 0; end
	8'hB9: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hBA: begin send_reg <= 8'h4F; sEOP <= 0; end
	8'hBB: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hBC: begin send_reg <= 8'h20; sEOP <= 0; end
	8'hBD: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hBE: begin send_reg <= 8'h55; sEOP <= 0; end
	8'hBF: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hC0: begin send_reg <= 8'h40; sEOP <= 0; end
	8'hC1: begin send_reg <= 8'h0D; sEOP <= 0; end
	8'hC2: begin send_reg <= 8'h0; sEOP <= 1; end
	
	8'hC3: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'hC4: begin send_reg <= 8'b01001011; sEOP <= 0; end
	8'hC5: begin send_reg <= 8'hA0; sEOP <= 0; end
	8'hC6: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hC7: begin send_reg <= 8'h60; sEOP <= 0; end
	8'hC8: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hC9: begin send_reg <= 8'h50; sEOP <= 0; end
	8'hCA: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hCB: begin send_reg <= 8'h50; sEOP <= 0; end
	8'hCC: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hCD: begin send_reg <= 8'h91; sEOP <= 0; end
	8'hCE: begin send_reg <= 8'h2C; sEOP <= 0; end
	8'hCF: begin send_reg <= 8'h00; sEOP <= 1; end
	
	8'hD0: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'hD1: begin send_reg <= 8'b11000011; sEOP <= 0; end
	8'hD2: begin send_reg <= 8'h68; sEOP <= 0; end
	8'hD3: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hD4: begin send_reg <= 8'h6F; sEOP <= 0; end
	8'hD5: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hD6: begin send_reg <= 8'h6E; sEOP <= 0; end
	8'hD7: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hD8: begin send_reg <= 8'h65; sEOP <= 0; end
	8'hD9: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hDA: begin send_reg <= 8'h86; sEOP <= 0; end
	8'hDB: begin send_reg <= 8'h9D; sEOP <= 0; end
	8'hDC: begin send_reg <= 8'h00; sEOP <= 1; end
	
	8'hDD: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'hDE: begin send_reg <= 8'b01001011; sEOP <= 0; end
	8'hDF: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hE0: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hE1: begin send_reg <= 8'h00; sEOP <= 1; end
	
	8'hE2: begin send_reg <= 8'b10000000; sEOP <= 0; end //SYNC
	8'hE3: begin send_reg <= 8'b01001011; sEOP <= 0; end //DATA1, так как за SETUP идет DATA0 
	8'hE4: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hE5: begin send_reg <= 8'hC2; sEOP <= 0; end
	8'hE6: begin send_reg <= 8'h01; sEOP <= 0; end
	8'hE7: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hE8: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hE9: begin send_reg <= 8'h00; sEOP <= 0; end
	8'hEA: begin send_reg <= 8'h08; sEOP <= 0; end
	8'hEB: begin send_reg <= 8'hC8; sEOP <= 0; end
	8'hEC: begin send_reg <= 8'h1B; sEOP <= 0; end
	8'hED: begin send_reg <= 8'b0; sEOP <= 1; end //EOP

	8'hEE: begin send_reg <= 8'b10000000; sEOP <= 0; end
	8'hEF: begin send_reg <= 8'b11000011; sEOP <= 0; end
	8'hF0: begin send_reg <= 8'h48; sEOP <= 0; end
	8'hF1: begin send_reg <= 8'h45; sEOP <= 0; end
	8'hF2: begin send_reg <= 8'h4c; sEOP <= 0; end
	8'hF3: begin send_reg <= 8'h4c; sEOP <= 0; end
	8'hF4: begin send_reg <= 8'h4f; sEOP <= 0; end
	8'hF5: begin send_reg <= 8'h21; sEOP <= 0; end
	8'hF6: begin send_reg <= 8'h0A; sEOP <= 0; end
	8'hF7: begin send_reg <= 8'h8C; sEOP <= 0; end
	8'hF8: begin send_reg <= 8'hB0; sEOP <= 0; end
	8'hF9: begin send_reg <= 8'h00; sEOP <= 1; end
	
	8'hFA: begin send_reg <= 8'h00; sEOP <= 1; end
	8'hFB: begin send_reg <= 8'h00; sEOP <= 1; end
	8'hFC: begin send_reg <= 8'h00; sEOP <= 1; end
	8'hFD: begin send_reg <= 8'h00; sEOP <= 1; end
	8'hFE: begin send_reg <= 8'h00; sEOP <= 1; end
	8'hFF: begin send_reg <= 8'h00; sEOP <= 1; end
	
	default: begin send_reg <= 8'h00; sEOP <= 1; end
	endcase
	end
	end

	always @(posedge clk)
	begin
	if(EOP)
	begin
	EOP_delay <= EOP_delay << 1;
	end
	else
	begin
	EOP_delay <= 2'b01;
	end
	end
	
	
	always @(posedge rdata_ready or posedge EOP)
	begin
	if(EOP)
	begin
	bytenum <= 1;
	end
	else
	begin
	if(SOP)
	begin
	bytenum[11:1] <= bytenum[10:0];
	bytenum[0] <= 0;
	end
	end
	end
	
	always @(posedge rdata_ready or posedge EOP)
	begin
	if(EOP)
	begin
	//SETUP_token <= 0;
	//bmRequestType <= 0;
	//bRequestCode <= 0;
	//wValue <=0;
	//recv_packet <= 0;
	end
	else
	begin
	if(bytenum[1])
	begin
	recv_packet[0] <= rdata[7:0];
	case (rdata[7:4])
	4'b0000: PID_decoder <= 0;
	4'b0111: PID_decoder <= 0;
	4'b1000: PID_decoder <= 0;
	4'b1001: PID_decoder <= 0;
	4'b1011: PID_decoder <= 0;
	4'b1111: PID_decoder <= 0;
	4'b0010: PID_decoder <= 9'b01; //SETUP
	4'b1110: PID_decoder <= 9'b10; //OUT
	4'b0110: PID_decoder <= 9'b100; //IN
	4'b1010: PID_decoder <= 9'b1000;
	4'b1100: PID_decoder <= 9'b10000;//DATA0
	4'b0100: PID_decoder <= 9'b100000;//DATA1
	4'b1101: PID_decoder <= 9'b1000000;//ACK,NACK,STALL
	4'b0101: PID_decoder <= 9'b10000000;
	4'b0001: PID_decoder <= 9'b100000000;
	4'b0011: PID_decoder <= 9'b100000000;//HP packet
	endcase
	end
	if(bytenum[2])
	begin
	recv_packet[1] <= rdata[7:0];
	ADDR_ENDP_CRC_decoder[7:0] <= rdata[7:0];
	end
	if(bytenum[3])
	begin
	recv_packet[2] <= rdata[7:0];
	ADDR_ENDP_CRC_decoder[15:8] <= rdata[7:0];
	end
	if(bytenum[4])
	recv_packet[3] <= rdata[7:0];
	if(bytenum[5])
	recv_packet[4] <= rdata[7:0];
	if(bytenum[6])
	recv_packet[5] <= rdata[7:0];
	if(bytenum[7])
	recv_packet[6] <= rdata[7:0];
	if(bytenum[8])
	recv_packet[7] <= rdata[7:0];
	if(bytenum[9])
	recv_packet[8] <= rdata[7:0];
	end
	end
	
	always @(posedge rdata_ready or posedge EOP)
	begin
	if(EOP)
	begin
	TX_byte_CRC <= 0;
	TX_EN <= 0;
	end
	else
	begin
	if((state == RECV_TX_DATA) && (PID_decoder[4] || PID_decoder[5]))
	begin
	TX_byte_CRC <= rdata;
	TX_EN <= 1;
	end
	else
	begin
	TX_byte_CRC <= 0;
	TX_EN <= 0;
	end
	end
	end
	
	wire xsEOP;
	
	assign xsEOP = EOP | sEOP;
	
	reg fsm_sync; //триггер для синхронизации машины состояний (а то была ошибка, все работало не так в signal tap)
	
	always @(posedge clk)
	begin
	if(xsEOP)
	fsm_sync <= 1;
	else
	fsm_sync <= 0;
	end
	
	reg RX_SEND_USB;
	
	/*always@(posedge RX_DONE)
	begin
	if(state == SEND_DATA_TEST_MESSAGE_RX)
	RX_SEND_USB <= 0;
	else
	RX_SEND_USB <= 1;
	end*/
	
	always @(posedge fsm_sync or posedge RX_DONE)
	begin
	//if(xsEOP) //надо было не использовать комбинационную функцию как тактовую...
	//begin
	if(RX_DONE)
	begin
	RX_SEND_USB <= 1;
	end
	else
	begin
	case(state)
	IDLE:
	begin
	if(PID_decoder[0])
	begin
	transac_counter <= 0;
	//ADDR_ENDP_CRC_decoder[7:0] <= recv_packet[1];
	//ADDR_ENDP_CRC_decoder[15:8] <= recv_packet[2];
	state <= RECV_DATA;
   end
	else if(PID_decoder[1])
	begin
	transac_counter <= 0;
	if((ADDR_ENDP_CRC_decoder[6:0] == device_address && device_address != 0) && (ADDR_ENDP_CRC_decoder[10:7] == 4'b1011))
	begin
	state <= RECV_TX_DATA;
	end
	else
	begin
	state <= RECV_DATA;
	end
	end
	else if(PID_decoder[2])
	begin
	//ADDR_ENDP_CRC_decoder[7:0] <= recv_packet[1];
	//ADDR_ENDP_CRC_decoder[15:8] <= recv_packet[2];
	if(ADDR_ENDP_CRC_decoder[6:0] == 0 && ADDR_ENDP_CRC_decoder[10:7] == 0)
	begin
	if(bmRequestType == 8'h80 && bRequestCode == 8'h06 && wValue == 16'h0100)
	begin
	state <= SEND_DATA_GET_DESC_FULL;
	end
	else if(bmRequestType == 8'h0 && bRequestCode == 8'h05)
	begin
	device_address <= wValue[7:0];
	state <= SEND_DATA1_NULL;
	end
	else
	begin
	state <= IDLE;
	end
	end
	else if((ADDR_ENDP_CRC_decoder[6:0] == device_address && device_address != 0) && (ADDR_ENDP_CRC_decoder[10:7] == 0))
	begin
   if(bmRequestType == 8'h80 && bRequestCode == 8'h06 && wValue == 16'h0100) // тоже самое что и в начале,
	begin //только по определенному адресу уже
	state <= SEND_DATA_GET_DESC_FULL;
	end
	else if(bmRequestType == 8'h80 && bRequestCode == 8'h06 && wValue == 16'h0200 && wLength == 16'h0009) //дескриптор конфигурации
	begin
	state <= SEND_DATA_GET_DESC_CONFIGURATION;
	end
	else if(bmRequestType == 8'h80 && bRequestCode == 8'h06 && wValue == 16'h0200 && (wLength == 16'h00FF || wLength == 16'h0043)) //дескриптор конфигурации
	begin
	state <= SEND_DATA_GET_DESC_CONFIGURATION_FULL;
	end
	else if(bmRequestType == 8'h80 && bRequestCode == 8'h06 && wValue == 16'h0300 /*&& wLength == 16'h00FF*/) //дескриптор строки 0
	begin
	state <= SEND_DATA_GET_DESC_STRING0;
	end
	else if(bmRequestType == 8'h80 && bRequestCode == 8'h06 && (wValue == 16'h0301 || wValue == 16'h0302 || wValue == 16'h0303 || wValue == 16'h0304)   && wLength == 16'h00FF) //дескриптор строки 1
	begin
	state <= SEND_DATA_GET_DESC_STRING1;
	end
	else if(bmRequestType == 8'h80 && bRequestCode == 8'h06 && (wValue == 16'h0301 || wValue == 16'h0302 || wValue == 16'h0303 || wValue == 16'h0304)   && wLength == 16'h0002) //дескриптор строки 1
	begin
	state <= SEND_DATA_GET_DESC_STRING2;
	end
	else if(bmRequestType == 8'h00 && bRequestCode == 8'h09 && wValue == 16'h0001) // тоже самое что и в начале,
	begin //SET_CONFIGURATION - устройство сконфигурировано, поздравляем !!!
	state <= SEND_DATA1_NULL;
	end
	else if((bmRequestType == 8'h80 && bRequestCode == 8'h25) || (bmRequestType == 8'h00 && bRequestCode == 8'hE1) /*&& wValue == 16'h0000*/) // тоже самое что и в начале,
	begin //SET_LINE_CODING  здесь не путать !!! значения bmRequestType и bRequestCode 
	state <= SEND_DATA1_NULL; //являются комбинацией в пакете OUT DWORD байтов dwDTERate !!!
	end
	else if(bmRequestType == 8'hA1 && bRequestCode == 8'h21 /*&& wValue == 16'h0000*/) // тоже самое что и в начале,
	begin //GET_LINE_CODING
	state <= SEND_DATA_GET_LINE_CODING;
	end
	else if(bmRequestType == 8'h21 && bRequestCode == 8'h22 /*&& wValue == 16'h0000*/) // тоже самое что и в начале,
	begin //SET_CONTROL_LINE_STATE
	state <= SEND_DATA1_NULL;
	end
	end
	else if((ADDR_ENDP_CRC_decoder[6:0] == device_address && device_address != 0) && (ADDR_ENDP_CRC_decoder[10:7] == 4'b1010))
	begin
	if(!RX_SEND_USB)
	state <= SEND_DATA_TEST_MESSAGE;
	else
	state <= SEND_DATA_TEST_MESSAGE_RX;
	end
	end
	else
	begin
	state <= IDLE;
	end
	end
	RECV_TX_DATA:
	begin
	if(PID_decoder[4] || PID_decoder[5])
	begin
	state <= SEND_ACK;
	end
	else
	begin
	state <= IDLE;
	end
	end
	RECV_DATA:
	begin
	if(PID_decoder[4] || PID_decoder[5])
	begin
	bmRequestType <= recv_packet[1];
	bRequestCode <= recv_packet[2];
	wValue[7:0] <= recv_packet[3];
	wValue[15:8] <= recv_packet[4];
	wIndex[7:0] <= recv_packet[5];
	wIndex[15:8] <= recv_packet[6];
	wLength[7:0] <= recv_packet[7];
	wLength[15:8] <= recv_packet[8];
	state <= SEND_ACK; //окончание транзакции пакетом ACK или NACK (просто даем знать что приняли данные)
	end
	else
	begin
	state <= IDLE;
	end
	end
	
	SEND_DATA_GET_DESC_CONFIGURATION: //дескриптор конфигурации
	begin
	transac_counter <= transac_counter + 1;
	state <= IDLE; //хотя надо бы RECV_HANDSHAKE
	end
	
	SEND_DATA_GET_DESC_CONFIGURATION_FULL: //дескриптор конфигурации полный 
	begin
	transac_counter <= transac_counter + 1;
	state <= IDLE; //хотя надо бы RECV_HANDSHAKE
	end
	
	SEND_DATA1_NULL:
	state <= IDLE;
	
	SEND_DATA_GET_DESC_STRING0:
	state <= IDLE; //хотя надо бы RECV_HANDSHAKE
	
	SEND_DATA_GET_DESC_STRING1:
	begin
	transac_counter <= transac_counter + 1;
	state <= IDLE; //хотя надо бы RECV_HANDSHAKE
	end
	
	SEND_DATA_GET_DESC_STRING2:
	state <= IDLE; //хотя надо бы RECV_HANDSHAKE
	
	SEND_DATA_GET_DESC_FULL: //дескриптор устройства
	begin
	transac_counter <= transac_counter + 1;
	state <= IDLE; //хотя надо бы RECV_HANDSHAKE
	end
	
	SEND_DATA_GET_DESC: //дескриптор устройства
	begin
	transac_counter <= transac_counter + 1;
	state <= IDLE; //хотя надо бы RECV_HANDSHAKE
	end
	
	SEND_ACK:
	state <= IDLE;
	
	SEND_DATA_GET_LINE_CODING:
	state <= IDLE;
	
	SEND_DATA_TEST_MESSAGE:
	begin
	transac_counter <= transac_counter + 1;
	state <= IDLE; //хотя надо бы RECV_HANDSHAKE
	end
	
	SEND_DATA_TEST_MESSAGE_RX:
	begin
	RX_SEND_USB <= 0;
	state <= IDLE;
	end
	
	default: state <= IDLE;
	endcase
	end
	end
	
	wire SEOP;
	assign SEOP = SOP | EOP_delay[2];
	
	assign btrdcnt_strobe = byteready_counter[2];
 
	always @(posedge clk or posedge SEOP)
	begin
	if(SEOP)
	begin
	if(SOP)
	begin
	byteready_counter <= 0;
	sdata_ready <= 0;
	end
	if(EOP_delay[2])
	begin
	byteready_counter <= 0;
	sdata_ready <= 1;
	end
	end
	else
	begin
	if(sixone_signal)
	begin
	if(byteready_counter == 6'b110001) // тут только для 6-ого бита сделано, надо расширить функционал...
	begin
	byteready_counter <= byteready_counter - 8;
	end
	else
	begin
	byteready_counter <= byteready_counter + 1;
	end
	end
	else
	begin
	{sdata_ready,byteready_counter} <= byteready_counter + 1;
	end
	end
	end
	
	always @(posedge sdata_ready or posedge EOP_delay[1])
	begin
	if(EOP_delay[1])
	begin
	if(state == SEND_ACK)
	begin
	FIFO_pointer <= 8'h001;
	end
	
	if(state == SEND_DATA_GET_DESC_FULL)
	begin
	if(transac_counter == 0)
	FIFO_pointer <= 8'h04;
	else if(transac_counter == 1)
	FIFO_pointer <= 8'h11;
	else if(transac_counter == 2)
	FIFO_pointer <= 8'h1E;
	end
	
	if(state == SEND_DATA1_NULL)
	begin
	FIFO_pointer <= 8'h25;
	end
	
	if(state == SEND_DATA_GET_DESC_CONFIGURATION)
	begin
	if(transac_counter == 0)
	FIFO_pointer <= 8'h2A;
	else if(transac_counter == 1)
	FIFO_pointer <= 8'h37;
	end
	
	if(state == SEND_DATA_GET_DESC_CONFIGURATION_FULL)
	begin
	if(transac_counter == 0)
	FIFO_pointer <= 8'h2A;
	else if(transac_counter == 4'b0001)
	FIFO_pointer <= 8'h3D;
	else if(transac_counter == 4'b0010)
	FIFO_pointer <= 8'h4A;
	else if(transac_counter == 4'b0011)
	FIFO_pointer <= 8'h57;
	else if(transac_counter == 4'b0100)
	FIFO_pointer <= 8'h64;
	else if(transac_counter == 4'b0101)
	FIFO_pointer <= 8'h71;
	else if(transac_counter == 4'b0110)
	FIFO_pointer <= 8'h7E;
	else if(transac_counter == 4'b0111)
	FIFO_pointer <= 8'h8B;
	else if(transac_counter == 4'b1000)
	FIFO_pointer <= 8'h98;
	end
	
	if(state == SEND_DATA_GET_DESC_STRING0)
	begin
	FIFO_pointer <= 8'hA0;
	end

	if(state == SEND_DATA_GET_DESC_STRING1)
	begin
	if(transac_counter == 0)
	FIFO_pointer <= 8'hA9;
	else if(transac_counter == 1)
	FIFO_pointer <= 8'hB6;
	else if(transac_counter == 2)
	FIFO_pointer <= 8'hC3;
	else if(transac_counter == 3)
	FIFO_pointer <= 8'hD0;
	else if(transac_counter == 4)
	FIFO_pointer <= 8'hDD;
	end
	
	if(state == SEND_DATA_GET_DESC_STRING2)
	begin
	FIFO_pointer <= 8'hDD;
	end
	
	if(state == SEND_DATA_GET_LINE_CODING)
	begin
	FIFO_pointer <= 8'hE2;
	end
	
	if(state == SEND_DATA_TEST_MESSAGE)
	begin
	//if(transac_counter == 0)
	FIFO_pointer <= 8'h25;
	//else if(transac_counter == 1)
	//FIFO_pointer <= 8'h25;
	//else if(transac_counter == 2)
	//FIFO_pointer <= 8'h25;
	//else if(transac_counter == 3)
	//FIFO_pointer <= 8'hEE; //тупо шлём 3 NULL DATA1 пакета (чтоб не конфликтовать с другими пакетами, а они есть),
	end		//далее наши данные HELLO! и далее просто ждем
	 //переполнения transac_counter и все по-новой пока хост не прекратить просить через конечную точку 0A пакет 
	
	if(state == SEND_DATA_TEST_MESSAGE_RX)
	begin
	FIFO_pointer <= 8'hEE;
	end
	
	
	end
	else
	begin
	if(!SOP & !sEOP & !EOP)
	FIFO_pointer <= FIFO_pointer + 1;	
	end
	end
	
	
	endmodule 