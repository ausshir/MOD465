`ifndef _DOWNSAMPLER_4_V_
`define _DOWNSAMPLER_4_V_

`ifndef _DEFINES_VH
    `include "defines.vh"
`endif

module downsampler_4(input clk,
                     input sym_clk_en,
                     input reset,
                     input signed [17:0] in,
                     output reg signed [17:0] out);

    // 2-bit counter to zero_stuff samples
    always @(posedge clk)
        if(reset)
            out = 0;
        else if(sym_clk_en)
            out = in;


endmodule
`endif
