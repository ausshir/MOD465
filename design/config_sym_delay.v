`ifndef _CONFIG_SYM_DELAY_V_
`define _CONFIG_SYM_DELAY_V_

module config_sym_delay(input clk,
                        input sam_clk_en,
                        input sym_clk_en,
                        input reset,
                        input [7:0] delay,
                        input signed [17:0] in,
                        output reg signed [17:0] out);

    integer i;
    reg signed [17:0] delay_chain[255:0];
    always @(posedge clk or posedge reset)
        for(i = 0; i <= 255; i = i + 1) begin
            if(reset)
                delay_chain[i] <= 0;

            else if(sym_clk_en)
                if(i == 0)
                    delay_chain[0] <= in;
                else
                    delay_chain[i] <= delay_chain[i-1];
        end

    always @*
        out = delay_chain[delay];

endmodule
`endif
