`timescale 1ps / 1fs

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:49:56 11/14/2020
// Design Name:   uart_tb
// Module Name:   E:/CUFE/digital_design/verilog/uart_2/uart_2/uart_tb_tf.v
// Project Name:  uart_2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart_tb
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module uart_tb_tf;

	// Inputs
	reg clock;
	reg send;
	reg [7:0] Data_in;
		wire [7:0] Data_out;
		
		wire received;
parameter clks_per_bit = 2;

	// Instantiate the Unit Under Test (UUT)
	uart_tb uut (
		.clock(clock), 
		.send(send), 
		.Data_in(Data_in),
			.Data_out(Data_out),
			.received(received)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		send = 0;
		Data_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        send = 1;

		// Add stimulus here
		 #240 Data_in = 8'b11001011;
		 #240 Data_in = 8'b10010011;
		 #240 Data_in = 8'b01101000;
		 #1000 $finish;
	end

  always #5 clock = ~ clock ;  
	
endmodule

