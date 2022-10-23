module pipo2(
    input        i_Clk,      // Input Clock
    input        i_Ld,       // Load Register
    input [47:0] i_Data,     // Input data bus
    output[47:0] o_Data // Output data bus
    );
	 reg [47:0] r_Data = 0;
    always @(posedge i_Clk ) begin
        if (i_Ld) r_Data <= i_Data;
    end
	 assign o_Data = r_Data;
	 
endmodule