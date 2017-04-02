`ifndef _UPSAMPLER_4_V_
`define _UPSAMPLER_4_V_

`ifndef _DEFINES_VH
    `include "defines.vh"
`endif

module upsampler_4(input clk,
                   input sam_clk_en,
                   input sym_clk_en,
                   input reset,
                   input signed [17:0] data_in,
                   output reg signed [17:0] data_out);

    // 2-bit counter to zero_stuff samples
    reg [1:0] count_4;
    always @(posedge clk or posedge reset)
        if(reset)
            count_4 = 0;
        else if(sym_clk_en)
            count_4 = 0;
        else if(sam_clk_en)
            count_4 = count_4 + 2'd1;

    always @(posedge clk or posedge reset)
        if(reset)
            data_out = 0;
        else if(sam_clk_en)
            if(count_4 == 2'd0)
                data_out = data_in;
            else
                data_out = 0;
        else
            data_out = data_out;

endmodule
`endif
