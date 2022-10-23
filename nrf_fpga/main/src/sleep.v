module sleep(
    input i_Clk,            // Input Clock
	 input i_Rst_L,			 // Reser Counter
    input i_Start,          // Start Sleep
    output reg o_Done       // Output data bus
);
    reg [31:0] counter;
	 always @(posedge i_Clk) begin
		 if (~i_Rst_L) begin 
			 counter <= 0;
			 o_Done <= 1;
		 end
		 else if (i_Start) begin
		 counter <= 100000;
		 o_Done <= 0;
		 end
		 else if (counter > 0) begin
		 counter <= counter - 1;
		 end
		 else begin
			 o_Done <= 1;
		 end
	 end
endmodule