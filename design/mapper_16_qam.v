`ifndef _MAPPER_16_QAM_V_
`define _MAPPER_16_QAM_V_

`include "defines.vh"

module mapper_16_qam(input clk,
                     input clk_en,
                     input [3:0] data,
                     output reg signed [17:0] in_phs_sig,
                     output reg signed [17:0] quad_sig);

    // Inphase Mapping using grey code on last two bits of the symbol
    always @*
        if(data[1:0] == 2'b00)
            in_phs_sig = `SYMBOL_P2;
        else if(data[1:0] == 2'b01)
            in_phs_sig = `SYMBOL_P1;
        else if(data[1:0] == 2'b11)
            in_phs_sig = `SYMBOL_N1;
        else // 2'b10
            in_phs_sig = `SYMBOL_N2;

    // Quadrature Mapping using grey code on first two bits of the symbol
    always @*
        if(data[3:2] == 2'b00)
            quad_sig = `SYMBOL_P2;
        else if(data[3:2] == 2'b01)
            quad_sig = `SYMBOL_P1;
        else if(data[3:2] == 2'b11)
            quad_sig = `SYMBOL_N1;
        else // 2'b10
            quad_sig = `SYMBOL_N2;

endmodule
`endif
