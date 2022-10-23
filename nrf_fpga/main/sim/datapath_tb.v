`timescale 1ns / 1ps

module datapath_tb;

	// Inputs
	reg i_SPI_Csn_tb;
	reg i_Load_TX_tb;
	reg i_Load_RX_tb;
	reg i_TX_DV_tb;
	reg i_Load_Data_Size_tb;
	reg i_Incr_Count_tb;
	reg i_Load_Mem_tb;
	reg i_Start_Sleep_tb;

	reg i_Clk_tb;
	reg i_Rst_L_tb;
	reg [7:0] i_Data_tb;
	reg i_Latch_Output_tb;
	wire i_SPI_Miso_tb;
	

	// Outputs
	wire o_TX_Ready_tb;
	wire o_Done_Sleep_tb;
	wire o_RX_DV_tb;
	wire o_FIFO_Empty_tb;
	wire o_RX_DR_Set_tb;
	wire o_Eqz_tb;
	
	wire o_SPI_Mosi_tb;
	wire o_SPI_Sck_tb;
	wire o_SPI_Csn_tb;
	wire [47:0] o_Data_tb;
	
	//reg done=0;
	reg [5:0] state;
	assign i_SPI_Miso_tb = o_SPI_Mosi_tb;

	// Instantiate the Unit Under Test (UUT)
	datapath uut (
		// Data Inputs
		.i_Clk(i_Clk_tb),
		.i_Rst(i_Rst_L_tb), 
		.i_Data(i_Data_tb), 
		.i_SPI_Miso(i_SPI_Miso_tb),

		 //Control inputs
		.i_SPI_Csn(i_SPI_Csn_tb),
		.i_Load_TX(i_Load_TX_tb),
		.i_Load_RX(i_Load_RX_tb),
		.i_TX_DV(i_TX_DV_tb),
		.i_Load_Data_Size(i_Load_Data_Size_tb),
		.i_Incr_Count(i_Incr_Count_tb),
		.i_Load_Mem(i_Load_Mem_tb),
		.i_Start_Sleep(i_Start_Sleep_tb),
		.i_Latch_Output(i_Latch_Output_tb),

		// Data Outputs
		.o_SPI_Mosi(o_SPI_Mosi_tb), 
		.o_SPI_Sck(o_SPI_Sck_tb), 
		.o_SPI_Csn(o_SPI_Csn_tb),
		.o_Data(o_Data_tb),
		 
		//Control Outputs
		.o_TX_Ready(o_TX_Ready_tb),
		.o_Done_Sleep(o_Done_Sleep_tb), 
		.o_RX_DV(o_RX_DV_tb), 
		.o_FIFO_Empty(o_FIFO_Empty_tb), 
		.o_RX_DR_Set(o_RX_DR_Set_tb),
		.o_Eqz(o_Eqz_tb)
	);
	
	always begin
		i_Clk_tb = ~i_Clk_tb;
		#10;
	end

	initial begin
		i_Clk_tb = 1;
		i_Rst_L_tb = 1;
		i_Data_tb = 8'h00;
		i_SPI_Csn_tb = 1;
		i_Load_TX_tb = 0;
		i_Load_RX_tb = 0;
		i_TX_DV_tb = 0;
		/*$monitor("i_Clk = %b ", 		i_Clk_tb,
			"i_Rst = %b ",  			i_Rst_L_tb,
			"i_Data = %b ", 			i_Data_tb,
			"i_SPI_Miso = %b ",			i_SPI_Miso_tb,
			"i_SPI_Csn = %b ", 			i_SPI_Csn_tb,
			"i_Load_TX = %b ", 			i_Load_TX_tb,
			"i_Load_RX = %b ", 			i_Load_RX_tb,
			"i_TX_DV = %b ", 			i_TX_DV_tb,
			"o_SPI_Mosi = %b ",			o_SPI_Mosi_tb,
			"o_SPI_Sck = %b ", 			o_SPI_Sck_tb,
			"o_SPI_Csn = %b ", 			o_SPI_Csn_tb,
			"o_TX_Ready = %b ",			o_TX_Ready_tb,
			"o_RX_DV = %b ",			o_RX_DV_tb,
			"o_FIFO_Empty = %b ", 		o_FIFO_Empty_tb,
			"o_RX_DR_Set = %b ", 		o_RX_DR_Set_tb,
			"TX_to_SPI_Module = %b ",	uut.TX_to_SPI_Module,
			"RX_from_SPI_Module = %b ", uut.RX_from_SPI_Module,
			"time = %d", 				$time);*/
			
		$dumpfile("datapath.vcd");
		$dumpvars(0, datapath_tb);
		
		#10000
		$finish;
	end


	always @(posedge i_Clk_tb) begin
		case(state) 
			0 	   : state <= 1;
			1 	   : state <= 2;
			2 	   : state <= 3;
			3 	   : if (~o_RX_DV_tb) state <= 3; else state <= 4;
			4 	   : state <= 5;
			5 	   : if (~o_TX_Ready_tb) state <= 5; else state <= 6;
			6	   : state <= 7;
			7	   : if (~o_RX_DR_Set_tb) state <= 37; else state <= 8;
			8	   : if (~o_TX_Ready_tb) state <= 8; else state <= 9;
			9	   : state <= 10;
			10	   : state <= 11;
			11	   : if (~o_TX_Ready_tb) state <= 11; else state <= 12;
			12	   : state <= 13;
			13	   : state <= 14;
			14	   : if (~o_RX_DV_tb) state <= 14; else state <= 15;
			15	   : state <= 16;
			16	   : if (~o_FIFO_Empty_tb) state <= 18; else state <= 37;
			17	   : state <= 37;
			18	   : if (~o_TX_Ready_tb) state <= 18; else state <= 19;
			19	   : state <= 20;
			20	   : state <= 21;
			21	   : if (~o_TX_Ready_tb) state <= 21; else state <= 22;
			22     : state <= 23;
			23	   : state <= 24;
			24	   : if (~o_RX_DV_tb) state <= 24; else state <= 25;
			25	   : state <= 26;
			26	   : state <= 27;
			27	   : if (~o_TX_Ready_tb) state <= 27; else state <= 28;
			28	   : state <= 29;
			29	   : state <= 30;
			30	   : if (~o_Eqz_tb) state <= 31; else state <= 17;
			31	   : if (~o_TX_Ready_tb) state <= 31; else state <= 32;
			32	   : state <= 33;
			33	   : state <= 34;
			34	   : if (~o_RX_DV_tb) state <= 34; else state <= 35;
			35	   : state <= 36;
			36	   : state <= 30;
			37	   : state <= 38;
			38	   : if (~o_Done_Sleep_tb) state <= 38; else state <= 0;
			default: state <= 0;
		endcase
	end

	always @(state) begin
		case (state) 
			0: begin
				i_Rst_L_tb 			= 0;
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
				i_Latch_Output_tb		= 0;
			end
			1: begin
				i_Rst_L_tb 			= 1;
				i_Data_tb  			= 8'h47; // Dummy Data
				i_Load_TX_tb 		= 1;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			2: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 1;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			3: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			4: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 1;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			5: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 1;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			6: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 1;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			7: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			8: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			9: begin
				i_Data_tb  			= 8'h81; // Dummy Data
				i_Load_TX_tb 		= 1;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			10: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 1;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			11: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			12: begin
				i_Data_tb  			= 8'he4;
				i_Load_TX_tb 		= 1;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			13: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 1;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			14: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			15: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 1;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			16: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			17: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
				i_Latch_Output_tb 	= 1;
			end
			18: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			19: begin
				i_Data_tb  			= 8'h60;
				i_Load_TX_tb 		= 1;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			20: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 1;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			21: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			22: begin
				i_Data_tb  			= 8'h06;
				i_Load_TX_tb 		= 1;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			23: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 1;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			24: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			25: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 1;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			26: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 1;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			27: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			28: begin
				i_Data_tb  			= 8'hf9; //Dummy Data
				i_Load_TX_tb 		= 1;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			29: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 1;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			30: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			31: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			32: begin
				i_Data_tb  			= 8'hab;
				i_Load_TX_tb 		= 1;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			33: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 1;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			34: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			35: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 1;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
			36: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 1;
				i_Load_Mem_tb 		= 1;
				i_Start_Sleep_tb 	= 0;
			end
			37: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 1;
				i_Latch_Output_tb   = 0;
			end
			38: begin
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end

			default: begin
				i_Rst_L_tb 			= 0;
				i_Data_tb  			= 8'h00;
				i_Load_TX_tb 		= 0;
				i_Load_RX_tb 		= 0;
				i_TX_DV_tb 			= 0;
				i_Load_Data_Size_tb = 0;
				i_Incr_Count_tb 	= 0;
				i_Load_Mem_tb 		= 0;
				i_Start_Sleep_tb 	= 0;
			end
		endcase
	end

      
endmodule

