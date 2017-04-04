`ifndef _TX_MIXER_V_
`define _TX_MIXER_V_

`ifndef _DEFINES_VH
    `include "defines.vh"
`endif

module tx_mixer(input clk,
                input sym_clk_en,
                input reset,
                input signed [17:0] tx_inph,
                input signed [17:0] tx_quad,
                output reg signed [17:0] tx_channel);

    reg [1:0] count_4;
    always @(posedge clk or posedge reset)
        if(reset)
            count_4 = 0;
        else if(sym_clk_en)
            count_4 = 0;
        else
            count_4 = count_4 + 2'd1;

    always @*
        case(count_4)
            2'd0 : tx_channel = { tx_inph };
            2'd1 : tx_channel = { tx_quad };
            2'd2 : tx_channel = {-tx_inph };
            2'd3 : tx_channel = {-tx_quad };
        endcase

endmodule
`endif
