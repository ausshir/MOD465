`ifndef _SRRC_GOLD_RX_FLT_V_
`define _SRRC_GOLD_RX_FLT_V_

module srrc_gold_rx_flt (input clk,
                         input sam_clk_en,
                         input sym_clk_en,
                         input reset,
                         input signed [17:0] in,
                         output reg signed [17:0] out);

    integer i;
    wire signed [17:0] coef[94:0];
    reg signed [17:0] x[188:0];

    `include "../../model/srrc_rx_gold_coefs.vh"

    // Shift Register
    always @(posedge clk or posedge reset)
        if(reset)
            for(i=0; i<=188; i=i+1) begin
                x[i] <= 0;
            end
        else if(sam_clk_en)
            for(i=0; i<=188; i=i+1) begin
                if(i == 0)
                    x[0] <= { in[17:0] };
                else
                    x[i] <= x[i-1];
            end

    reg signed [17:0] sum_level_1[94:0];
    always @(posedge clk or posedge reset)
        for(i=0; i<=93; i=i+1)
            if(reset) begin
                sum_level_1[i] <= 0;
                sum_level_1[94] <= 0;
            end
            else begin
                sum_level_1[i] <= x[i]+x[188-i];
                sum_level_1[94] <= x[94];
            end

    // always @ (posedge clk) For pipelining?
    reg signed [35:0] mult_out[94:0];
    always @(posedge clk or posedge reset)
        for(i=0; i<=94; i=i+1)
            if(reset)
                mult_out[i] = 0;
            else
                mult_out[i] = sum_level_1[i] * coef[i];

    reg signed [17:0] sum_level_2[47:0];
    always @(posedge clk or posedge reset)
        for(i=0;i<=47;i=i+1)
            if(reset) begin
                sum_level_2[i] <= 0;
                sum_level_2[47] <= 0;
            end
            else begin
                sum_level_2[i] <= mult_out[2*i][34:17] + mult_out[2*i+1][34:17];
                sum_level_2[47] <= mult_out[94][34:17];
            end

    // Larger Adder Tree
    // We need to go from 48 bins to 1 output.
    // On the first clock, we add together in goups of 4's
    reg signed [17:0] sum_level_3[11:0];
    always @(posedge clk) begin
        for(i=0; i<=10; i=i+1) begin
            sum_level_3[i] <= sum_level_2[(4*i)+0] + sum_level_2[(4*i)+1] + sum_level_2[(4*i)+2] + sum_level_2[(4*i)+3];
        end
        sum_level_3[11] <= sum_level_2[47] + sum_level_2[46] + sum_level_2[45];
    end

    // Again on the second clock
    reg signed [17:0] sum_level_4[2:0];
    always @(posedge clk) begin
        for(i=0; i<=2; i=i+1) begin
            sum_level_4[i] <= sum_level_3[(4*i)+0] + sum_level_3[(4*i)+1] + sum_level_3[(4*i)+2] + sum_level_3[(4*i)+3];
        end
    end

    // On the last, we add in 3 inputs.
    reg signed [17:0] sum_level_5;
    always @(posedge clk) begin
        sum_level_5 = sum_level_4[0] + sum_level_4[1] + sum_level_4[2];
    end

    // Finally we register the output
    always @(posedge clk or posedge reset) begin
        if(reset)
            out = 0;
        else if(sam_clk_en)
            out = sum_level_5;
    end

endmodule
`endif
