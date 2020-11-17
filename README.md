# UART
Implementation for the UART series communication protocol

Both RX and TX are implemented as FSM with 6 states from idle to done each state handle part of the frame of the uart packet

file named uart_Tx is the transimmter (TX) of the Uart module 
file named uart_Rx is the receiver (RX) of the Uart module
file named uart_tb is a top module where it includes both TX and RX
file named uart_tb_tf is the test fixture (test_bench) for both the whole module where there is instantiation for both TX and RX to test the whole sending and receiving process.
