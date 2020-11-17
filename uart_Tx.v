`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mohamed Ammar
// 
// Create Date:    08:22:22 07/11/2020 
// Design Name: UART Transmitter
// Module Name:    uart_Tx 
// Project Name: UART series communication protocol
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module uart_Tx(
	input clock,	
	input send,						//send signal to start sending 
//	input Parity_sel,				// 1 for even parity else for odd parity
	input [7:0] Data_in,
	
	output reg busy,				//busy signal 
	output reg Data_out,
	output reg sent				//raised when finish sending
    );

	wire Parity;							//for parity bit
	parameter clks_per_bit = 2;		//Freq/Baud rate

		  /* Parametrs for the FSM states */
	parameter [2:0] idle      = 3'b000;
	parameter [2:0] StartBit  = 3'b001;
	parameter [2:0] DataBits  = 3'b010;
	parameter [2:0] ParityBit = 3'b011;
	parameter [2:0] StopBit   = 3'b100;
	parameter [2:0] Done		  = 3'b101;
	
		   /* Registers */
	reg [2:0] current_state = idle;
	reg [7:0] clk_count;
	reg [7:0] data_to_send;
	reg [2:0] bit_index;


always @(posedge clock)
begin 
	case (current_state)
		idle: begin						//will be idle until send signal received 
		Data_out <= 1;
		sent 		<=0 ;
			
			if (send == 1'b1)
			begin
				busy <= 1;
				data_to_send <= Data_in;
				clk_count <=0 ;
				current_state <= StartBit;
			end
			
			else begin
			busy <= 0 ;
			current_state <= idle;
			end
	end
	
	StartBit: begin									//first start sending the start bit
		Data_out <= 0;
		if (clk_count < (clks_per_bit -1)) 		//This condition for checkinng if the bit needs more clks
		begin
			clk_count  <= clk_count + 1;
			current_state <= StartBit;
		end
	
		else begin
		clk_count <= 0;
		bit_index <=0;
		current_state <= DataBits;					//done with start bit now go for the data bits
		end
	end
	
	DataBits: begin				
		Data_out <= Data_in[bit_index];
		
		if (clk_count < (clks_per_bit - 1))
		begin
			clk_count <= clk_count + 1;
			current_state <= DataBits;
		end
		
		else begin 
		clk_count <= 0;								
			if (bit_index < 7)							//after sending specific bit check if there is still bits in the msg
			begin
				bit_index <= bit_index +1;
				current_state <= DataBits;
			end
			else begin
				current_state <= ParityBit;
			end
		end
	end
	
	ParityBit: begin
		Data_out <= Parity;								//depending on Parity_sel the parity will be odd or even
		if (clk_count < (clks_per_bit - 1))
		begin
			clk_count	  <= clk_count + 1;
			current_state <= ParityBit;
		end
		
		else begin
			clk_count <= 0;
			current_state <= StopBit;
			busy <= 0; 
			sent <= 0;
		end
	end
	
	StopBit: begin										//sending the stop bit
		Data_out <= 1;
		if (clk_count < (clks_per_bit- 1))
		begin
			clk_count <= clk_count + 1;
			current_state <= StopBit;
		end
		
		else begin
			clk_count <= 0;
			current_state <= Done;
			busy <= 0;
			sent <= 1;
		end
	end
	
	Done: begin
		sent <= 1;
		busy <= 0;
		current_state <= idle;
	end
	
	default: begin
		current_state <= idle;
	end
endcase
end

	//assign Parity = (Parity_sel == 1) ? (^data_to_send) : (~^data_to_send);	
	assign Parity = ~^data_to_send;
endmodule
