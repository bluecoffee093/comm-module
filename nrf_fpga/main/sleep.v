module sleep(
    input i_Clk,            // Input Clock
    input i_Start,          // Start Sleep
    output o_Done,          // Output data bus
)
    reg [31:0] counter;
    always @(posedge i_Clk) begin
        if (i_Start & counter!=0) begin
            counter <= 32'd1;
        end
        else begin
            counter <= counter + 1;
        end
    end

    always @(posedge i_Clk) begin
        if (counter <= 100001) begin
            o_Done <= 1'b1;
        end
        else begin
            o_Done <= 1'b0;
        end
    end
endmodule