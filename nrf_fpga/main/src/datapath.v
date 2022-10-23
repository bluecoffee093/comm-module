module datapath(
    input i_Clk,             // Input Clock
    input i_Rst,             // Reset input
    input [7:0] i_Data,      // Input data bus
    input i_SPI_Miso,        // SPI MISO

    output o_SPI_Mosi,       // SPI MOSI 
    output o_SPI_Sck,        // SPI Clock
    output o_SPI_Csn,        // SPI Chip Select
    output [47:0] o_Data,    // Output data bus

    // Control Signals
    input i_SPI_Csn,         // SPI Chip Select
    input i_Load_TX,         // Load TX Register with data
    input i_Load_RX,         // Load RX Register with data
    input i_TX_DV,           // TX Data Valid Pulse
    input i_Load_Data_Size,  // Load Data Size
    input i_Incr_Count,	     // Increase Count
    input i_Load_Mem,        // Load Memory with data
    input i_Start_Sleep,     // Start Sleep
    input i_Latch_Output,    // Latch Output

    output o_TX_Ready,       // TX Ready for next data
    output o_Done_Sleep,     // Sleep Done
    output o_RX_DV,          // RX Data Valid
    output o_FIFO_Empty,     // FIFO Empty
    output o_RX_DR_Set,      // IRQ Generation
    output o_Eqz             // Equal to Zero	
);

    wire [7:0] TX_to_SPI_Module;
    wire [7:0] RX_from_SPI_Module;
    wire [7:0] RX_Output;
	wire [7:0] Data_Size_Bus;
    wire [2:0] Mem_Addr;
    wire [47:0] o_Data_Mem;
	wire [7:0] Mem_addr_extend;
    wire main_clk;

    assign main_clk = i_Clk;
	assign Mem_addr_extend = {5'b00000,Mem_Addr};
	 
    pipo TX_REG(
        .i_Clk(main_clk),
        .i_Ld(i_Load_TX),
        .i_Data(i_Data),
        .o_Data(TX_to_SPI_Module)
    );

    pipo RX_REG(
        .i_Clk(main_clk),
        .i_Ld(i_Load_RX),
        .i_Data(RX_from_SPI_Module),
        .o_Data(RX_Output)
    );
	 
	 pipo Data_Size_REG(
        .i_Clk(main_clk),
        .i_Ld(i_Load_Data_Size),
        .i_Data(RX_Output),
        .o_Data(Data_Size_Bus)
    );

    pipo2 output_buffer(
        .i_Clk(main_clk),
        .i_Ld(i_Latch_Output),
        .i_Data(o_Data_Mem),
        .o_Data(o_Data)
    );
	 
	 counter Count_REG(
        .i_Clk(main_clk),
        .i_Incr(i_Incr_Count),
        .i_Rst_L(i_Rst),
        .o_Data(Mem_Addr)
    );

    spi_transceiver SPI_Module(
        .i_Clk(i_Clk),
        .i_Rst_L(i_Rst),
        .i_TX_Byte(TX_to_SPI_Module),
        .i_TX_DV(i_TX_DV),
        .o_TX_Ready(o_TX_Ready),
        .o_RX_DV(o_RX_DV),
        .o_RX_Byte(RX_from_SPI_Module),
        .o_SPI_Clk(o_SPI_Sck),
        .i_SPI_MISO(i_SPI_Miso),
        .o_SPI_MOSI(o_SPI_Mosi)
    );

    comparator interrupt_request_check(
        .i_Data1(RX_Output & 8'h40),
        .i_Data2(8'h40),
        .o_Equal(o_RX_DR_Set)
    );

    comparator fifo_empty_check(
        .i_Data1(RX_Output & 8'h01),
        .i_Data2(8'h01),
        .o_Equal(o_FIFO_Empty)
    );

	comparator eqz_check(
        .i_Data1(Data_Size_Bus),
        .i_Data2(Mem_addr_extend),
        .o_Equal(o_Eqz)
	 );
    memory ram (
        .i_Clk(main_clk),
        .i_Rst_L(i_Rst),
        .i_Data(RX_Output),
        .i_Write(i_Load_Mem),
        .i_Addr(Mem_Addr),
        .o_Data(o_Data_Mem)
    );

    sleep sleep_module(
        .i_Clk(main_clk),
        .i_Rst_L(i_Rst),
        .i_Start(i_Start_Sleep),
        .o_Done(o_Done_Sleep)
    );
endmodule