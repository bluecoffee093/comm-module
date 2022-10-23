module controller(
    input  start,              // Start signalo_SPI_Csn
    input  i_Rst,              // Reset Signal
    input  i_Clk,              // Clock Signal

    // Control Signals Input
    input  i_TX_Ready,         // TX Ready for next data
    input  i_Done_Sleep,       // Done Sleeping
    input  i_RX_DV,            // RX Data Valid
    input  i_FIFO_Empty,       // FIFO Empty
    input  i_RX_DR_Set,        // IRQ Generation
	input  i_Eqz,			   // Equal to Zero

    // Control Signals Output
	output reg o_Rst_L,		  	  // Reset Signal
    output reg o_SPI_Csn,         // SPI Chip Select
    output reg o_Load_TX,         // Load TX Register with data
    output reg o_Load_RX,         // Load RX Register with data
    output reg o_TX_DV,           // TX Data Valid Pulse
	output reg o_Load_Data_Size,  // Load Data Size Register
	output reg o_Incr_Count,      // Increment Counter count
	output reg o_Load_Mem,        // Load Memory with data
    output reg o_Start_Sleep,     // Start Sleep
    output reg o_Latch_Output,    // Latch Output
    output reg [7:0] o_Data,      // Input data bus

    // Control Signals Internal
    output reg done              // Done signal
    );

    // Register Map and Bit values
    parameter WRITE        = 8'h20;
	parameter READ		   = 8'h00;
    parameter STATUS_REG   = 8'h07;
	parameter STATUS_DATA  = 8'h0E;
    parameter RX_DR        = 8'h40;
    parameter TX_DR        = 8'h20;
    parameter MAX_RT       = 8'h10;
    parameter FIFO_STATUS  = 8'h17;
	parameter R_RX_PL_WID  = 8'h60;
    parameter R_RX_PAYLOAD = 8'h61;
    parameter NOP          = 8'hFF;

    reg [5:0] state;

	always @(posedge i_Clk) begin
		case(state) 
			0 	   : state <= 1;
			1 	   : state <= 2;
			2 	   : state <= 3;
			3 	   : if (~i_RX_DV) state <= 3; else state <= 4;
			4 	   : state <= 5;
			5 	   : if (~i_TX_Ready) state <= 5; else state <= 6;
			6	   : state <= 7;
			7	   : if (~i_RX_DR_Set) state <= 37; else state <= 8;
			8	   : if (~i_TX_Ready) state <= 8; else state <= 9;
			9	   : state <= 10;
			10	   : state <= 11;
			11	   : if (~i_TX_Ready) state <= 11; else state <= 12;
			12	   : state <= 13;
			13	   : state <= 14;
			14	   : if (~i_RX_DV) state <= 14; else state <= 15;
			15	   : state <= 16;
			16	   : if (~i_FIFO_Empty) state <= 18; else state <= 37;
			17	   : state <= 37;
			18	   : if (~i_TX_Ready) state <= 18; else state <= 19;
			19	   : state <= 20;
			20	   : state <= 21;
			21	   : if (~i_TX_Ready) state <= 21; else state <= 22;
			22     : state <= 23;
			23	   : state <= 24;
			24	   : if (~i_RX_DV) state <= 24; else state <= 25;
			25	   : state <= 26;
			26	   : state <= 27;
			27	   : if (~i_TX_Ready) state <= 27; else state <= 28;
			28	   : state <= 29;
			29	   : state <= 30;
			30	   : if (~i_Eqz) state <= 31; else state <= 17;
			31	   : if (~i_TX_Ready) state <= 31; else state <= 32;
			32	   : state <= 33;
			33	   : state <= 34;
			34	   : if (~i_RX_DV) state <= 34; else state <= 35;
			35	   : state <= 36;
			36	   : state <= 30;
			37	   : state <= 38;
			38	   : if (~i_Done_Sleep) state <= 38; else state <= 0;
			default: state <= 0;
		endcase
	end
    
	always @(state) begin
		case (state) 
			0: begin
				o_Rst_L 			= 0;
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
				o_Latch_Output		= 0;
			end
			1: begin
				o_Rst_L 			= 1;
				o_Data  			= WRITE + STATUS_REG;
				o_Load_TX 			= 1;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			2: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 1;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			3: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			4: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 1;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			5: begin
				o_Data  			= STATUS_DATA;
				o_Load_TX 			= 1;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			6: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 1;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			7: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			8: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			9: begin
				o_Data  			= READ + FIFO_STATUS;
				o_Load_TX 			= 1;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			10: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 1;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			11: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			12: begin
				o_Data  			= NOP;
				o_Load_TX 			= 1;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			13: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 1;
				o_Load_Data_Size	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			14: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			15: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 1;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			16: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			17: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
				o_Latch_Output 		= 1;
			end
			18: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size	 = 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			19: begin
				o_Data  			= R_RX_PL_WID;
				o_Load_TX 			= 1;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			20: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 1;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			21: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			22: begin
				o_Data  			= NOP;
				o_Load_TX 			= 1;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			23: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 1;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			24: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size	 = 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			25: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 1;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			26: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 1;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			27: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size	 = 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			28: begin
				o_Data  			= R_RX_PAYLOAD;
				o_Load_TX 			= 1;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			29: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 1;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			30: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			31: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			32: begin
				o_Data  			= NOP;
				o_Load_TX 			= 1;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			33: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 1;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			34: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			35: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 1;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
			36: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 1;
				o_Load_Mem 			= 1;
				o_Start_Sleep 		= 0;
			end
			37: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 1;
				o_Latch_Output  	 = 0;
			end
			38: begin
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end

			default: begin
				o_Rst_L 			= 0;
				o_Data  			= 8'h00;
				o_Load_TX 			= 0;
				o_Load_RX 			= 0;
				o_TX_DV 			= 0;
				o_Load_Data_Size 	= 0;
				o_Incr_Count 		= 0;
				o_Load_Mem 			= 0;
				o_Start_Sleep 		= 0;
			end
		endcase
	end
endmodule