module memory (
    input i_Clk,
    input i_Rst,
    input [7:0] i_Data,
    input i_Write,
    input [3:0] i_Addr,
    output reg [7:0] o_Data
);
    reg [7:0] mem [3:0];
    always @(posedge i_Clk) begin
        if (i_Rst) begin
            for (i=0; i<16; i=i+1) m[i] <= 8'b00000000; 
        end 
        else begin
            if (i_Write) begin
                mem[i_Addr] <= i_Data;
            end
            o_Data <= mem[i_Addr];
        end
    end
endmodule