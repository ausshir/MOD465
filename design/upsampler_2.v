`ifndef _UPSAMPLER_2_V_
`define _UPSAMPLER_2_V_

`ifndef _DEFINES_VH
    `include "defines.vh"
`endif

module upsampler_2(input clk,
                   input hb_clk_en,
                   input reset,
                   input signed [17:0] data_in,
                   output reg signed [17:0] data_out);

    // 2-bit counter to zero_stuff samples
    reg count_2;
    always @(posedge clk or posedge reset)
        if(reset)
            count_2 = 0;
        else if(hb_clk_en)
            count_2 = count_2 + 1;

    always @(posedge clk or posedge reset)
        if(reset)
            data_out = 0;
        else if(hb_clk_en)
            if(count_2 == 0)
                data_out = data_in;
            else
                data_out = 0;
        else
            data_out = data_out;

endmodule
`endif
