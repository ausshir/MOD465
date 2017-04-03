`ifndef _SRRC_PRAC_HB_FLT_V_
`define _SRRC_PRAC_HB_FLT_V_

`ifndef _DEFINES_VH
    `include "defines.vh"
`endif

module srrc_prac_hb_flt (input clk,
                         input hb_clk_en,
                         input reset,
                         input signed [17:0] in,
                         output reg signed [17:0] out);

    integer i;
    wire signed [17:0] coef[5:0];
    reg signed [17:0] x[10:0];

    `include "../../model/LUT/halfband_coefs.vh"

    // Shift Register
    always @(posedge clk or posedge reset)
        if(reset)
            for(i=0; i<=10; i=i+1) begin
                x[i] <= 0;
            end
        else if(hb_clk_en)
            for(i=0; i<=10; i=i+1) begin
                if(i == 0)
                    x[0] <= { in[17], in[17:1] };
                else
                    x[i] <= x[i-1];
            end

    // Linear Phase filter folding
    reg signed [17:0] sum_level_1[5:0];
    always @(posedge clk or posedge reset)
            if(reset) begin
                for(i=0; i<=5; i=i+1) begin
                    sum_level_1[i] <= 0;
                end
            end
            else begin
                for(i=0; i<=5; i=i+1) begin
                    sum_level_1[i] <= x[i]+x[10-i];
                end
                sum_level_1[5] <= x[5];
            end

    // Multipliers (Using NULL and FS coefficients to reduce)
    reg signed [35:0] mult_out[5:0];
    always @(posedge clk or posedge reset) begin
        if(reset)
            for(i=0; i<=5; i=i+1)
                mult_out[i] <= 0;
        else
            mult_out[0] <= sum_level_1[0] * coef[0];
            mult_out[1] <= 0;
            mult_out[2] <= sum_level_1[2] * coef[2];
            mult_out[3] <= 0;
            mult_out[4] <= sum_level_1[4] * coef[4];
            mult_out[5] <= sum_level_1[5] <<< 17;
    end

    // Adder trees
    reg signed [17:0] sum_level_2[2:0];
    always @(posedge clk or posedge reset)
        if(reset) begin
            for(i=0;i<=2;i=i+1) begin
                sum_level_2[i] <= 0;
            end
        end
        else begin
            for(i=0;i<=3;i=i+1)
                sum_level_2[i] <= mult_out[(2*i)][34:17] + mult_out[(2*i)+1][34:17];
        end

    reg signed [17:0] sum_level_3[1:0];
    always @* begin
        sum_level_3[0] <= sum_level_2[0] + sum_level_2[1];
        sum_level_3[1] <= sum_level_2[2];
    end

    reg signed [17:0] sum_level_4;
    always @* begin
        sum_level_4 <= sum_level_3[0] + sum_level_3[1];
    end

    // Finally we register the output
    always @(posedge clk or posedge reset) begin
        if(reset)
            out <= 0;
        else if(hb_clk_en)
            out <= sum_level_4;
    end

endmodule
`endif
