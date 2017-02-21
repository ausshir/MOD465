`ifndef _SLICER_4_ASK_V_
`define _SLICER_4_ASK_V_

module slicer_4_ask(input clk,
                    input clk_en,
                    input signed [17:0] in_phs_sig,
                    input signed [17:0] ref_level,
                    output reg [1:0] sym_out);

    // Inphase mapping/slicing using a reference level to decide on bits
    always @(posedge clk)
        if(in_phs_sig > ref_level)
            sym_out = 2'b01;
        else if(in_phs_sig > 0)
            sym_out = 2'b00;
        else if(in_phs_sig > -ref_level)
            sym_out = 2'b11;
        else
            sym_out = 2'b10;

endmodule
`endif
