`ifndef _SLICER_4_ASK_V_
`define _SLICER_4_ASK_V_

module slicer_4_ask(input clk,
                    input clk_en,
                    input signed [17:0] in,
                    input signed [17:0] ref_level,
                    output reg [1:0] sym_out);

    // Signal slicing using a reference level to decide on bits
    always @*
        if(in > ref_level)
            sym_out = 2'b00;
        else if(in > 0)
            sym_out = 2'b01;
        else if(in > -ref_level)
            sym_out = 2'b11;
        else
            sym_out = 2'b10;

endmodule
`endif
