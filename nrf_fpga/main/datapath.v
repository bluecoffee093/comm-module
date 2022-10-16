module datapath(
    input i_Clk,            // Input Clock
    input i_Rst,            // Reset input
    input [7:0] i_Data      // Input data bus
    input i_SPI_Miso,       // SPI MISO

    output o_SPI_Mosi,      // SPI MOSI 
    output o_SPI_Sck        // SPI Clock
    output o_SPI_Cs         // SPI Chip Select
    output o_Data           // Output data bus

    // Control Signals
    input i_SPI_Csn,         // SPI Chip Select
    input i_Load_TX         // Load TX Register with data
    input i_Load_RX         // Load RX Register with data
    input i_Load_Mem        // Load Memory with data
    input i_TX_DV,          // TX Data Valid Pulse
    input i_Start_Sleep     // Start Sleep
    input i_Mem_Addr        // Memory Address ***TODO***
    output o_TX_Ready       // TX Ready for next data
    output o_Done_Sleep     // Sleep Done
    output o_RX_DV          // RX Data Valid
    output o_FIFO_Empty     // FIFO Empty
    output o_RX_DR_Set      // IRQ Generation
)

    wire [7:0] TX_to_SPI_Module;
    wire [7:0] RX_from_SPI_Module;
    wire [7:0] RX_Output;
    wire main_clk;

    assign main_clk = o_SPI_Sck;
    assign o_SPI_Cs = i_SPI_Csn;

    pipo TX_REG(
        .i_Clk(i_Clk),
        .i_ld(i_Load_TX),
        .i_Data(i_Data),
        .o_Data(TX_to_SPI_Module)
    );

    pipo RX_REG(
        .i_Clk(i_Clk),
        .i_ld(i_Load_RX),
        .i_Data(RX_from_SPI_Module),
        .o_Data(RX_Output)
    );

    spi_transceiver SPI_Module(
        .i_Clk(i_Clk),
        .i_Rst(i_Rst),
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

    memory ram (
        .i_Clk(main_clk),
        .i_Rst(i_Rst),
        .i_Data(RX_Output),
        .i_Write(i_Load_Mem),
        .i_Addr(i_Mem_Addr),
        .o_Data(o_Data)
    );

    sleep sleep_module(
        .i_Clk(main_clk),
        .i_Start(i_Start_Sleep),
        .o_Done(o_Sleep_Done)
    );
endmodule