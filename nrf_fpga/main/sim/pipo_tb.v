`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:29:05 10/15/2022
// Design Name:   pipo
// Module Name:   /home/ajay/Krssg_comm_module/pipo_tb.v
// Project Name:  Krssg_comm_module
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pipo
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pipo_tb;

	// Inputs
	reg i_Clk;
	reg i_Ld;
	reg [7:0] i_Data;

	// Outputs
	wire [7:0] o_Data;

	// Instantiate the Unit Under Test (UUT)
	pipo uut (
		.i_Clk(i_Clk), 
		.i_Ld(i_Ld), 
		.i_Data(i_Data), 
		.o_Data(o_Data)
	);

	initial begin
		// Initialize Inputs
		i_Clk = 0;
		i_Ld = 0;
		i_Data = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$monitor("I_Data = %b, i_Clk = %b, i_Ld = %b, o_Data = %b, time = %d", i_Data, i_Clk, i_Ld, o_Data, $time);
		
		i_Data = 8'hAC;
		i_Ld = 1;
		#35;
		i_Ld = 0;
		#20;
		i_Data = 8'hAA;
		#20;
		i_Ld = 1;

	end
	
	always begin
		i_Clk = ~i_Clk;
		#20;
	end
      
endmodule

