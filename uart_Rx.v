`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mohamed Ammar
// 
// Create Date:    19:17:38 11/09/2020 
// Design Name: UART_Receiver
// Module Name:    uart_Rx 
// Project Name: 
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
module uart_Rx(
	input clock,
	input Data_in,
//	input Parity_sel,				// 1 for even parity else for odd parity

	output reg [7:0] Data_out,
	output reg received
    );
	 parameter clks_per_bit = 2;   		//clk freq/Baud rate
	 
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
	reg [7:0] data_received;
	reg [2:0] bit_index;

	always @(posedge clock)
	begin
		case (current_state)
		idle : begin 
			received <= 0;
			if (Data_in == 1'b0) begin 
				data_received <= 8'b00000000;
				clk_count <= 0;
				current_state <= StartBit;
			end
			else begin
				current_state <= idle ;
			end 
		end
		
		StartBit : begin
			if (clk_count < (clks_per_bit - 2)) begin			//check if the start_bit need more clks 
				if (Data_in == 1'b0) begin        			//if it is not received yet wait 
					clk_count <= clk_count + 1;
					current_state <= StartBit;
				end
				else begin						//if it is not received during the clk_per_bit period then go back to idle state 
					current_state <= idle ;
				end
			end
			else begin
				if (Data_in == 1'b0) begin 	//if the start_bit received correctly go to data_bits
					current_state <= DataBits;
					bit_index <= 0;
					clk_count <= 0;
				end
				else begin							//if it is not 0 then there is error 
					current_state <= idle;
				end
			end
		end
		
		DataBits : begin
			if (clk_count < (clks_per_bit -1 )) begin		//check if this bit still needs more clks
				current_state <= DataBits;
				clk_count <= clk_count + 1;
			end
			else begin 
				data_received[bit_index] <= Data_in;
				clk_count <= 0;
				
				if (bit_index < 7) begin		//checking  that all the bit are received 
					bit_index <= bit_index+1 ;
					current_state <= DataBits;
				end
				else begin
					current_state <= ParityBit;
				end
			end
		end
		
		ParityBit : begin 
			if (clk_count < (clks_per_bit - 2)) begin
				if (Data_in == Parity) begin
					current_state <= ParityBit;
					clk_count <= clk_count+1;
				end
				else begin
				current_state <= idle;
				end
			end
			else begin 
				current_state <= StopBit;
				clk_count <= 0;
			end
		end
		
		StopBit : begin
			if (clk_count < (clks_per_bit - 2)) begin
				if (Data_in == 1'b1) begin
					clk_count <= clk_count + 1;
					current_state <= StopBit;
				end	
				else begin 
					current_state <= idle;
				end
			end
			else begin
				received <= 1;
				Data_out <= data_received;
				current_state <= Done;
			end
		end
		
		Done : begin
			current_state <= idle;
		end
		
		default : begin
			current_state <= idle;
		end
		
endcase
end
		//assign Parity = (Parity_sel == 1) ? (^data_received) : (~^data_received);	
		assign Parity = ~^data_received;
endmodule

