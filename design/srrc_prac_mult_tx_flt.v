`ifndef _SRRC_PRAC_MULT_TX_FLT_V_
`define _SRRC_PRAC_MULT_TX_FLT_V_

module srrc_prac_mult_tx_flt(input clk,
                             input fastclk,
                             input sam_clk_en,
                             input sym_clk_en,
                             input reset,
                             input signed [17:0] in,
                             output reg signed [17:0] out);

    integer i;
    wire signed [17:0] coef[60:0];
    reg signed [17:0] x[120:0];

    `include "../../model/LUT/srrc_tx_practical_mult_coefs.vh"

    // Shift Register
    always @(posedge clk or posedge reset)
        if(reset)
            for(i=0; i<=120; i=i+1) begin
                x[i] <= 0;
            end
        else if(sam_clk_en)
            for(i=0; i<=120; i=i+1) begin
                if(i == 0)
                    x[0] <= { in[17:0] };
                else
                    x[i] <= x[i-1];
            end

    reg signed [17:0] sum_level_1[60:0];
    always @(posedge clk or posedge reset)
            if(reset) begin
                for(i=0; i<=59; i=i+1) begin
                    sum_level_1[i] <= 0;
                end
                sum_level_1[60] <= 0;
            end
            else begin
                for(i=0; i<=59; i=i+1) begin
                    sum_level_1[i] <= x[i]+x[120-i];
                end
                sum_level_1[60] <= x[60];
            end

    // always @ (posedge clk) For pipelining?
    reg signed [35:0] mult_out[60:0];
    always @(posedge clk or posedge reset)
        for(i=0; i<=60; i=i+1)
            if(reset)
                mult_out[i] = 0;
            else
                mult_out[i] = sum_level_1[i] * coef[i];

    reg signed [17:0] sum_level_2[30:0];
    always @(posedge clk or posedge reset)
        if(reset) begin
            for(i=0;i<=29;i=i+1) begin
                sum_level_2[i] <= 0;
            end
            sum_level_2[30] <= 0;
        end
        else begin
            for(i=0;i<=29;i=i+1) begin
                sum_level_2[i] <= mult_out[(2*i)][34:17] + mult_out[(2*i)+1][34:17];
            end
            sum_level_2[30] <= mult_out[60][34:17];
        end

    reg signed [17:0] sum_level_3[15:0];
    always @(posedge clk) begin
        for(i=0; i<=14; i=i+1)
            sum_level_3[i] <= sum_level_2[(2*i)] + sum_level_2[(2*i)+1];
        sum_level_3[15] = sum_level_2[30];
    end

    reg signed [17:0] sum_level_4[7:0];
    always @(posedge clk) begin
        for(i=0; i<=7; i=i+1)
            sum_level_4[i] <= sum_level_3[(2*i)] + sum_level_3[(2*i)+1];
    end

    reg signed [17:0] sum_level_5[3:0];
    always @(posedge clk) begin
        for(i=0; i<=3; i=i+1)
            sum_level_5[i] <= sum_level_4[(2*i)] + sum_level_4[(2*i)+1];
    end

    reg signed [17:0] sum_level_6[1:0];
    always @(posedge clk) begin
        sum_level_6[0] <= sum_level_5[0] + sum_level_5[1];
        sum_level_6[1] <= sum_level_5[2] + sum_level_5[3];
    end

    reg signed [17:0] sum_level_7;
    always @(posedge clk) begin
        sum_level_7 <= sum_level_6[0] + sum_level_6[1];
    end

    // Finally we register the output
    always @(posedge clk or posedge reset) begin
        if(reset)
            out = 0;
        else if(sam_clk_en)
            out = sum_level_7;
    end

endmodule
`endif
