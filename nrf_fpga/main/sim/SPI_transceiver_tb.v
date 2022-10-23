`timescale 1ns / 1ps

module spi_transceiver_tb;

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
	
		// Add stimulus here
		$monitor("i_Rst_L: %b" , i_Rst_L,
		"i_Clk: %b", 		i_Clk,
		"i_TX_Byte: %b", 	i_TX_Byte,
		"i_TX_DV: %b", 	i_TX_DV,
		"i_SPI_MISO: %b", i_SPI_MISO,
		"o_TX_Ready: %b", o_TX_Ready,
		"o_RX_DV: %b", 	o_RX_DV,
		"o_RX_Byte: %b", 	o_RX_Byte,
		"o_SPI_Clk: %b", 	o_SPI_Clk,
		"o_SPI_MOSI: %b", o_SPI_MOSI);  
	
		// Initialize Inputs
		i_Rst_L = 0;
		i_Clk = 0;
		i_TX_Byte = 0;
		i_TX_DV = 0;

		// Wait 100 ns for global reset to finish
		#20;
		
		i_Rst_L = 1;
		i_TX_Byte = 8'hAB;
		i_TX_DV = 1;
		#20
		i_TX_DV = 0;
	end
	
	always begin
		i_Clk = ~i_Clk;
		#10;
	end
      
endmodule

