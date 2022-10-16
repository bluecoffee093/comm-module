`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:20:35 10/15/2022
// Design Name:   datapath
// Module Name:   /home/ajay/Krssg_comm_module/datapath_tb.v
// Project Name:  Krssg_comm_module
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: datapath
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module datapath_tb;

	// Inputs
	reg i_Clk;
	reg i_Rst;
	reg [7:0] i_Data;
	wire i_SPI_Miso;
	reg i_SPI_Csn;
	reg i_Load_TX;
	reg i_Load_RX;
	reg i_TX_DV;

	// Outputs
	wire o_SPI_Mosi;
	wire o_SPI_Sck;
	wire o_SPI_Cs;
	wire o_TX_Ready;
	wire o_RX_DV;
	wire o_FIFO_Empty;
	wire o_RX_DR_Set;

	// Instantiate the Unit Under Test (UUT)
	datapath uut (
		.i_Clk(i_Clk), 
		.i_Rst(i_Rst), 
		.i_Data(i_Data), 
		.i_SPI_Miso(i_SPI_Miso), 
		.o_SPI_Mosi(o_SPI_Mosi), 
		.o_SPI_Sck(o_SPI_Sck), 
		.o_SPI_Cs(o_SPI_Cs), 
		.i_SPI_Csn(i_SPI_Csn), 
		.i_Load_TX(i_Load_TX), 
		.i_Load_RX(i_Load_RX), 
		.i_TX_DV(i_TX_DV), 
		.o_TX_Ready(o_TX_Ready), 
		.o_RX_DV(o_RX_DV), 
		.o_FIFO_Empty(o_FIFO_Empty), 
		.o_RX_DR_Set(o_RX_DR_Set)
	);
	
	assign i_SPI_Miso = o_SPI_Mosi;

	initial begin
		// Initialize Inputs
		i_Clk = 0;
		i_Rst = 0;
		i_Data = 0;
		//i_SPI_Miso = 0;
		i_SPI_Csn = 0;
		i_Load_TX = 0;
		i_Load_RX = 0;
		i_TX_DV = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$monitor("i_Clk = %b, i_Rst = %b, i_Data = %b, i_SPI_Miso = %b, i_SPI_Csn = %b, i_Load_TX = %b, i_Load_RX = %b, i_TX_DV = %b, o_SPI_Mosi = %b, o_SPI_Sck = %b, o_SPI_Cs = %b, o_TX_Ready = %b, o_RX_DV = %b o_FIFO_Empty = %b, o_RX_DR_Set = %b, time = %d",i_Clk, i_Rst, i_Data,i_SPI_Miso, i_SPI_Csn, i_Load_TX, i_Load_RX , i_TX_DV, o_SPI_Mosi, o_SPI_Sck , o_SPI_Cs , o_TX_Ready , o_RX_DV, o_FIFO_Empty, o_RX_DR_Set, $time);
		i_Rst = 1;
		i_Data = 8'hAB;
		i_Load_TX = 1;
		i_Load_RX = 1;
		#45;
		i_TX_DV = 1;
		#40;
		i_TX_DV = 0;

	end
	always begin
		i_Clk = ~i_Clk;
		#20;
	end
      
endmodule

