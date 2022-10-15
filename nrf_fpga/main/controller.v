module controller(
    input  start              // Start signal
    input  i_Clk              // Clock Signal
    input  i_TX_Ready         // TX Ready for next data
    input  i_RX_DV            // RX Data Valid
    input  i_Rst              // Reset Signal
    input  i_RX_DR_Set        // IRQ Generation
    input  i_FIFO_Empty       // FIFO Empty


    output reg o_SPI_Csn,         // SPI Chip Select
    output reg o_Load_TX         // Load TX Register with data
    output reg o_Load_RX         // Load RX Register with data
    output reg o_TX_DV,          // TX Data Valid Pulse
    output reg done              // Done signal
    output reg [7:0] o_Data      // Input data bus
    );

    // Register Map and Bit values
    parameter WRITE        = 8'h20;
    parameter STATUS_REG   = 8'h07;
    parameter RX_DR        = 8'h40;
    parameter TX_DR        = 8'h20;
    parameter MAX_RT       = 8'h10;
    parameter FIFO_STATUS  = 8'h17;
    parameter R_RX_PAYLOAD = 8'h61;
    parameter NOP          = 8'hFF;

    // State Names
    parameter START                 = 0;       
    parameter SEND_WRITE_STATUS     = 1;
    parameter STORE_STATUS          = 2;
    parameter CLEAR_IRQ_FLAGS       = 3;
    parameter IRQ_FLAG_CHECK        = 4;
    parameter GET_FIFO_STATUS       = 5;
    parameter STORE_FIFO_STATUS     = 6;
    parameter FIFO_EMPTY_CHECK      = 7;
    parameter SEND_READ_COMMAND     = 8;
    parameter SEND_NOP_COMMAND      = 9;
    parameter STORE_DATA            = 10;
    parameter PUSH_INTO_MEMORY      = 11;
    parameter DECODE_DATA           = 12;
    parameter WAIT_1_MS             = 13;


    parameter final_state = ; //TODO

    reg [7:0] state = START;

    always @(posedge i_Clk): begin
        if (i_Rst) begin
            o_SPI_Csn <= 1'b1;
            o_Load_TX <= 1'b0;
            o_Load_RX <= 1'b0;
            o_TX_DV <= 1'b0;
            done <= 1'b0;
            o_Data <= 8'b0;
            state <= SEND_WRITE_STATUS;

        end
        else begin
            case (state)
                SEND_WRITE_STATUS:  if(i_TX_Ready) state <= STORE_STATUS;

                STORE_STATUS: if (i_RX_DV) state <= CLEAR_IRQ_FLAGS; 
                
                CLEAR_IRQ_FLAGS: if (i_TX_Ready) state <= IRQ_FLAG_CHECK;
                        
                IRQ_FLAG_CHECK: (i_RX_DR_Set) ? state <= GET_FIFO_STATUS : state <= WAIT_1_MS;
                
                GET_FIFO_STATUS: if (i_RX_DV) state <= STORE_FIFO_STATUS;

                STORE_FIFO_STATUS: state <= FIFO_EMPTY_CHECK;

                FIFO_EMPTY_CHECK: (i_FIFO_Empty) ? state <= DECODE_DATA : state <= SEND_READ_COMMAND;

                SEND_READ_COMMAND: if(i_TX_Ready) state <= SEND_NOP_COMMAND;

                SEND_NOP_COMMAND: if(i_RX_DV) state <= STORE_DATA;

                DECODE_DATA:

                WAIT_1_MS:

                default: state = SEND_WRITE_STATUS;
            endcase
        end
    end

    always @(state) begin
        case (state)

             // Send Write Status Command
            SEND_WRITE_STATUS: begin
                o_Data      = WRITE + STATUS_REG;
                o_Load_TX   = 1'b1;
                o_Load_RX   = 1'b0;
                o_TX_DV     = 1'b1;
                o_SPI_Csn   = 1'b0;
            end

            // Load RX Register with data
            STORE_STATUS: begin
                o_Load_TX   = 1'b0;
                o_Load_RX   = 1'b1;
                o_TX_DV     = 1'b0;
            end

            // Clear Flags by writing into status register
            CLEAR_IRQ_FLAGS: begin
                o_Data      = RX_DR|TX_DR|MAX_RT; 
                o_Load_TX   = 1'b1;
                o_Load_RX   = 1'b0;
                o_TX_DV     = 1'b1;
            end

            // Check if the flag RX_DR is set
            IRQ_FLAG_CHECK: begin
                o_Load_TX   = 1'b0;
                o_Load_RX   = 1'b0;
                o_TX_DV     = 1'b0;
                o_SPI_Csn    = 1'b1;
            end

            // Send Check if FIFO is empty
            GET_FIFO_STATUS: begin
                o_Data      = FIFO_STATUS;
                o_Load_TX   = 1'b1;
                o_Load_RX   = 1'b0;
                o_TX_DV     = 1'b1;
                o_SPI_Csn    = 1'b0;
            end

            // Load RX Register with data
            STORE_FIFO_STATUS: begin
                o_Load_TX   = 1'b0;
                o_Load_RX   = 1'b1;
                o_TX_DV     = 1'b0;
            end

            // Check if the flag FIFO_EMPTY is set
            FIFO_EMPTY_CHECK: begin
                o_Load_TX   = 1'b0;
                o_Load_RX   = 1'b0;
                o_TX_DV     = 1'b0;
                o_SPI_Csn    = 1'b1;
            end

            // Send Read Command
            SEND_READ_COMMAND: begin
                o_Data      = R_RX_PAYLOAD;
                o_Load_TX   = 1'b1;
                o_Load_RX   = 1'b0;
                o_TX_DV     = 1'b1;
                o_SPI_Csn    = 1'b0;
            end

            // Send NOP Command
            SEND_NOP_COMMAND: begin
                o_Data      = NOP;
                o_Load_TX   = 1'b1;
                o_Load_RX   = 1'b0;
                o_TX_DV     = 1'b1;
                o_SPI_Csn    = 1'b0;
            end

            // Load RX Register with data
            STORE_DATA: begin
                o_Load_TX   = 1'b0;
                o_Load_RX   = 1'b1;
                o_TX_DV     = 1'b0;
                o_SPI_Csn    = 1'b1;
            end

            // Push data into memory
            PUSH_INTO_MEMORY: begin
                o_Load_TX   = 1'b0;
                o_Load_RX   = 1'b0;
                o_TX_DV     = 1'b0;
                o_SPI_Csn    = 1'b1;
                o_Shift_Mem = 1'b1;
            end
            end




            default: 
        endcase
endmodule