`ifndef _SRRC_GOLD_RX_FLT_V_
`define _SRRC_GOLD_RX_FLT_V_

module srrc_gold_rx_flt (input clk,
                         input fastclk,
                         input sam_clk_en,
                         input sym_clk_en,
                         input reset,
                         input signed [17:0] in,
                         output reg signed [17:0] out);

    integer i;
    wire signed [17:0] coef[99:0];
    reg signed [17:0] x[198:0];

    `include "../../model/LUT/srrc_rx_gold_coefs.vh"

    // Shift Register
    always @(posedge clk or posedge reset)
        if(reset)
            for(i=0; i<=198; i=i+1) begin
                x[i] <= 0;
            end
        else if(sam_clk_en)
            for(i=0; i<=198; i=i+1) begin
                if(i == 0)
                    x[0] <= { in[17], in[17:1] };
                else
                    x[i] <= x[i-1];
            end

    reg signed [17:0] sum_level_1[99:0];
    always @(posedge clk or posedge reset)
            if(reset) begin
                for(i=0; i<=98; i=i+1) begin
                    sum_level_1[i] <= 0;
                end
                sum_level_1[99] <= 0;
            end
            else begin
                for(i=0; i<=98; i=i+1) begin
                    sum_level_1[i] <= x[i]+x[198-i];
                end
                sum_level_1[99] <= x[99];
            end

    // always @ (posedge clk) For pipelining?
    reg signed [35:0] mult_out[99:0];
    always @(posedge clk or posedge reset)
        for(i=0; i<=99; i=i+1)
            if(reset)
                mult_out[i] = 0;
            else
                mult_out[i] = sum_level_1[i] * coef[i];

    reg signed [17:0] sum_level_2[49:0];
    always @(posedge clk or posedge reset)
        if(reset) begin
            for(i=0;i<=49;i=i+1) begin
                sum_level_2[i] <= 0;
            end
        end
        else begin
            for(i=0;i<=49;i=i+1) begin
                sum_level_2[i] <= mult_out[(2*i)][34:17] + mult_out[(2*i)+1][34:17];
            end
        end

    reg signed [17:0] sum_level_3[24:0];
    always @*
        for(i=0; i<=24; i=i+1)
            sum_level_3[i] <= sum_level_2[(2*i)] + sum_level_2[(2*i)+1];

    reg signed [17:0] sum_level_4[12:0];
    always @* begin
        for(i=0; i<=11; i=i+1)
            sum_level_4[i] <= sum_level_3[(2*i)] + sum_level_3[(2*i)+1];
        sum_level_4[12] <= sum_level_3[24];
    end

    reg signed [17:0] sum_level_5[6:0];
    always @* begin
        for(i=0; i<=5; i=i+1)
            sum_level_5[i] <= sum_level_4[(2*i)] + sum_level_4[(2*i)+1];
        sum_level_5[6] <= sum_level_4[12];
    end

    reg signed [17:0] sum_level_6[3:0];
    always @* begin
        for(i=0; i<=2; i=i+1)
            sum_level_6[i] <= sum_level_5[(2*i)] + sum_level_5[(2*i)+1];
        sum_level_6[3] <= sum_level_5[6];
    end

    reg signed [17:0] sum_level_7[1:0];
    always @* begin
        sum_level_7[0] <= sum_level_6[0] + sum_level_6[1];
        sum_level_7[1] <= sum_level_6[2] + sum_level_6[3];
    end

    reg signed [17:0] sum_level_8;
    always @* begin
        sum_level_8 <= sum_level_7[0] + sum_level_7[1];
    end

    // Finally we register the output
    always @(posedge clk or posedge reset) begin
        if(reset)
            out = 0;
        else if(sam_clk_en)
            out = sum_level_8;
    end

endmodule
`endif
