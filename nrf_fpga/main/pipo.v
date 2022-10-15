module pipo(
    input        i_Clk,      // Input Clock
    input        i_Ld,       // Load Register
    input  [7:0] i_Data,     // Input data bus
    output [7:0] o_Data      // Output data bus
    );

    always @(posedge clk ) begin
        if (i_Ld) begin
            o_Data <= i_Data;
        end
    end
endmodule