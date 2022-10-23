module memory (
    input i_Clk,
    input i_Rst_L,
    input [7:0] i_Data,
    input i_Write,
    input [2:0] i_Addr,
    output reg [47:0] o_Data
);
    reg [7:0] mem [15:0];
	integer i;
    always @(posedge i_Clk) begin
        if (~i_Rst_L) begin
            for (i=0; i<16; i=i+1) mem[i] <= 8'b00000000;
				o_Data <= {mem[3],mem[2],mem[1],mem[0]};
        end 
        else begin
            if (i_Write) begin
                mem[i_Addr] <= i_Data;
            end
            o_Data <= {mem[5],mem[4],mem[3],mem[2],mem[1],mem[0]};
        end
    end
endmodule