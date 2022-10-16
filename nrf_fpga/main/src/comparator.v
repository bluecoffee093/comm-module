module comparator(
    input [7:0] i_Data1,     // Input data bus
    input [7:0] i_Data2,     // Input data bus
    output o_Equal          // Output data bus
    );
    
    assign o_Equal = (i_Data1 == i_Data2);
endmodule