`ifndef _SRRC_GOLD_RX_FLT_V_
`define _SRRC_GOLD_RX_FLT_V_

`ifndef _DEFINES_VH
    `include "defines.vh"
`endif

module srrc_gold_rx_flt (input clk,
                         input sam_clk_en,
                         input sym_clk_en,
                         input reset,
                         input signed [17:0] in,
                         output reg signed [17:0] out);

    integer i;
    wire signed [17:0] coef[72:0];
    reg signed [17:0] x[144:0];

    `include "../../model/LUT/srrc_rx_gold_coefs.vh"

    // Shift Register
    always @(posedge clk or posedge reset)
        if(reset)
            for(i=0; i<=144; i=i+1) begin
                x[i] <= 0;
            end
        else if(sam_clk_en)
            for(i=0; i<=144; i=i+1) begin
                if(i == 0)
                    x[0] <= { in[17], in[17:1] };
                else
                    x[i] <= x[i-1];
            end

    // Linear Phase filter folding
    reg signed [17:0] sum_level_1[72:0];
    always @(posedge clk or posedge reset)
            if(reset) begin
                for(i=0; i<=72; i=i+1) begin
                    sum_level_1[i] <= 0;
                end
            end
            else begin
                for(i=0; i<=71; i=i+1) begin
                    sum_level_1[i] <= x[i]+x[144-i];
                end
                sum_level_1[72] <= x[72];
            end

    // Multipliers (using 72 of them)
    reg signed [35:0] mult_out[72:0];
    always @(posedge clk or posedge reset)
        for(i=0; i<=72; i=i+1)
            if(reset)
                mult_out[i] <= 0;
            else
                mult_out[i] <= sum_level_1[i] * coef[i];

    // Adder trees
    reg signed [17:0] sum_level_2[36:0];
    always @(posedge clk or posedge reset)
        if(reset) begin
            for(i=0;i<=36;i=i+1) begin
                sum_level_2[i] <= 0;
            end
        end
        else begin
            for(i=0;i<=35;i=i+1)
                sum_level_2[i] <= mult_out[(2*i)][34:17] + mult_out[(2*i)+1][34:17];
            sum_level_2[36] <= mult_out[72][34:17];
        end

    reg signed [17:0] sum_level_3[18:0];
    always @* begin
        for(i=0; i<=17; i=i+1)
            sum_level_3[i] <= sum_level_2[(2*i)] + sum_level_2[(2*i)+1];
        sum_level_3[18] <= sum_level_2[36];
    end

    reg signed [17:0] sum_level_4[9:0];
    always @* begin
        for(i=0; i<=8; i=i+1)
            sum_level_4[i] <= sum_level_3[(2*i)] + sum_level_3[(2*i)+1];
        sum_level_4[9] <= sum_level_3[18];
    end

    reg signed [17:0] sum_level_5[4:0];
    always @* begin
        for(i=0; i<=4; i=i+1)
            sum_level_5[i] <= sum_level_4[(2*i)] + sum_level_4[(2*i)+1];
    end

    reg signed [17:0] sum_level_6[2:0];
    always @* begin
        for(i=0; i<=1; i=i+1)
            sum_level_6[i] <= sum_level_5[(2*i)] + sum_level_5[(2*i)+1];
        sum_level_6[2] <= sum_level_5[4];
    end

    reg signed [17:0] sum_level_7[1:0];
    always @* begin
        sum_level_7[0] <= sum_level_6[0] + sum_level_6[1];
        sum_level_7[1] <= sum_level_6[2];
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
