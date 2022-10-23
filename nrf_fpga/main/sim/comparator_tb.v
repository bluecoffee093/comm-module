`timescale 1ns / 1ps

module comparator_tb;

	// Inputs
	reg [7:0] i_Data1;
	reg [7:0] i_Data2;

	// Outputs
	wire o_Equal;

	// Instantiate the Unit Under Test (UUT)
	comparator uut (
		.i_Data1(i_Data1), 
		.i_Data2(i_Data2), 
		.o_Equal(o_Equal)
	);

	initial begin
		// Initialize Inputs
		i_Data1 = 0;
		i_Data2 = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$monitor("i_Data1 = %b, i_Data2 = %b, o_Equal = %b", i_Data1, i_Data2, o_Equal);
		i_Data1 = 8'hAB;
		i_Data2 = 8'hAA;
		
		#20;
		
		i_Data1 = 8'hAB;
		i_Data2 = 8'hAB;

	end
      
endmodule

