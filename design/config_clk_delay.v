`ifndef _CONFIG_CLK_DELAY_V_
`define _CONFIG_CLK_DELAY_V_

module config_clk_delay(input clk,
                        input sam_clk_en,
                        input sym_clk_en,
                        input reset,
                        input [1:0] delay,
                        input signed [17:0] in,
                        output reg signed [17:0] out);

    integer i;
    reg signed [17:0] delay_chain[3:0];
    always @(posedge clk or posedge reset)
        if(reset) begin
            for(i = 0; i <= 3; i = i + 1)
                delay_chain[i] <= 0;
        end
        else begin
            for(i = 0; i <= 3; i = i + 1)
                if(i == 0)
                    delay_chain[0] <= in;
                else
                    delay_chain[i] <= delay_chain[i-1];
        end

    always @*
        out = delay_chain[delay];

endmodule
`endif
