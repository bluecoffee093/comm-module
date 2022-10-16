`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:56:42 10/15/2022
// Design Name:   spi_transceiver
// Module Name:   /home/ajay/Krssg_comm_module/SPI_transceiver_tb.v
// Project Name:  Krssg_comm_module
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: spi_transceiver
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module SPI_transceiver_tb;

	// Inputs
	reg i_Rst_L;
	reg i_Clk;
	reg [7:0] i_TX_Byte;
	reg i_TX_DV;
	wire i_SPI_MISO;

	// Outputs
	wire o_TX_Ready;
	wire o_RX_DV;
	wire [7:0] o_RX_Byte;
	wire o_SPI_Clk;
	wire o_SPI_MOSI;

	// Instantiate the Unit Under Test (UUT)
	spi_transceiver uut (
		.i_Rst_L(i_Rst_L), 
		.i_Clk(i_Clk), 
		.i_TX_Byte(i_TX_Byte), 
		.i_TX_DV(i_TX_DV), 
		.o_TX_Ready(o_TX_Ready), 
		.o_RX_DV(o_RX_DV), 
		.o_RX_Byte(o_RX_Byte), 
		.o_SPI_Clk(o_SPI_Clk), 
		.i_SPI_MISO(i_SPI_MISO), 
		.o_SPI_MOSI(o_SPI_MOSI)
	);

	assign i_SPI_MISO = o_SPI_MOSI;
		
	initial begin
		// Initialize Inputs
		i_Rst_L = 0;
		i_Clk = 0;
		i_TX_Byte = 0;
		i_TX_DV = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$monitor("i_Rst_L = %b, i_Clk = %b, i_TX_Byte = %b, i_TX_DV = %b, i_SPI_MISO = %b, wire o_TX_Ready = %b, o_RX_DV = %b, o_RX_Byte = %b, o_SPI_Clk = %b, o_SPI_MOSI = %b", i_Rst_L, i_Clk, i_TX_Byte, i_TX_DV, i_SPI_MISO,o_TX_Ready, o_RX_DV, o_RX_Byte, o_SPI_Clk , o_SPI_MOSI);  
		i_Rst_L = 1;
		i_TX_Byte = 8'hAB;
		i_TX_DV = 1;
		#45;
		i_TX_DV = 0;
		
	end
	
	always begin
		i_Clk = ~i_Clk;
		#20;
	end
      
endmodule

