`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:51 11/14/2020 
// Design Name: 
// Module Name:    uart_tb 
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
module uart_tb(
		input clock,	
		input send,						//send signal to start sending 
		input [7:0] Data_in,
	output [7:0] Data_out,
	output received		
    );

	wire [0:0] data_line;
	parameter clks_per_bit = 2;

		// Instantiate //
	uart_Tx  #(.clks_per_bit(clks_per_bit)) TX1 (
		.clock(clock),
		.send(send),
		.Data_in(Data_in),
		.busy(busy),
		.Data_out(data_line),
		.sent(sent)
	  );
	
	uart_Rx #(.clks_per_bit(clks_per_bit)) RX1 (
		.Data_in(data_line), 
		.clock(clock), 
		.received(received), 
		.Data_out(Data_out)
	);


endmodule
