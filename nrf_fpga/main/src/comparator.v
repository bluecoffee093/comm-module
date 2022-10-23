module comparator(
   input [7:0] i_Data1,     // Input data bus
   input [7:0] i_Data2,     // Input data bus
   output reg o_Equal          // Output data bus
   );
   always @(i_Data1 or i_Data2) begin
		o_Equal = 0;
		if(i_Data1 == i_Data2) 
			o_Equal = 1;
		else
			o_Equal = 0;
	end
endmodule