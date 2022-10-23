`timescale 1ns / 1ps

module pipo_tb;

	// Inputs
	reg i_Clk_tb;
	reg i_Ld_tb;
	reg [7:0] i_Data_tb;

	// Outputs
	wire [7:0] o_Data_tb;

	// Instantiate the Unit Under Test (UUT)
	pipo uut (
		.i_Clk(i_Clk_tb), 
		.i_Ld(i_Ld_tb), 
		.i_Data(i_Data_tb), 
		.o_Data(o_Data_tb)
	);

	initial begin
		// Initialize Inputs
		i_Clk_tb = 0;
		i_Ld_tb = 0;
		i_Data_tb = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$monitor("I_Data = %b, i_Clk = %b, i_Ld = %b, o_Data = %b, time = %d", i_Data_tb, i_Clk_tb, i_Ld_tb, o_Data_tb, $time);
		
		i_Data_tb = 8'hAC;
		i_Ld_tb = 1;
		#20;
		i_Ld_tb = 0;
		#20;
		i_Data_tb = 8'hAA;
		#20;
		i_Ld_tb = 1;

	end
	
	always begin
		i_Clk_tb = ~i_Clk_tb;
		#10;
	end
      
endmodule

