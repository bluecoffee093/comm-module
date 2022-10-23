module counter(
    input i_Clk,
    input i_Incr,
    input i_Rst_L,
    output reg [2:0] o_Data
    );
    always @(posedge i_Clk)
        if (~i_Rst_L)
            o_Data <= 8'b000;
        else if (i_Incr)
            o_Data <= o_Data + 1;
endmodule
