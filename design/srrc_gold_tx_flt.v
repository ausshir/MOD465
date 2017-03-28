`ifndef _SRRC_GOLD_TX_FLT_V_
`define _SRRC_GOLD_TX_FLT_V_

`ifndef _DEFINES_VH
    `include "defines.vh"
`endif

module srrc_gold_tx_flt(input clk,
                        input sam_clk_en,
                        input sym_clk_en,
                        input reset,
                        input signed [17:0] in,
                        output reg signed [17:0] out);

    integer i;
    // Precomputed filter outputs from LUT
    wire signed [17:0] PRECOMP_P2[144:0];
	wire signed [17:0] PRECOMP_P1[144:0];
    wire signed [17:0] PRECOMP_N1[144:0];
    wire signed [17:0] PRECOMP_N2[144:0];

    `include "../../model/LUT/srrc_tx_gold_coefs.vh"
    //`include "../../model/dummy_coefs.txt"


    // Shift register
    reg signed [17:0] bin[144:0];
    always @(posedge clk or posedge reset)
        for(i=0; i<=144; i=i+1) begin
            if(reset)
                bin[i] <= 0;
            else if(sam_clk_en)
                if(i == 0)
                    bin[0] <= in[17:0];
                else
                    bin[i] <= bin[i-1];
        end

    reg [17:0] bin_out[144:0];
    always @*
        for(i=0; i<=144; i=i+1)
            if(reset)
                bin_out[i] <= 18'd0;
            //else if(sam_clk_en)
            else begin
                case(bin[i])
                    `SYMBOL_P2: bin_out[i] <= PRECOMP_P2[i];
                    `SYMBOL_P1: bin_out[i] <= PRECOMP_P1[i];
                    `SYMBOL_N1: bin_out[i] <= PRECOMP_N1[i];
                    `SYMBOL_N2: bin_out[i] <= PRECOMP_N2[i];
                    // Invalid data OR zeroes (not connected/impulse response/zero stuffed)
                    default: bin_out[i] <= 18'd0;
                endcase
            end

    // Adder Tree
    reg signed [17:0] sum_level_1[72:0];
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            for(i=0; i<=71; i=i+1)
                sum_level_1[i] <= 0;
            sum_level_1[72] <= 0;
        end
        else begin
            for(i=0; i<=71; i=i+1)
                sum_level_1[i] <= bin_out[(2*i)] + bin_out[(2*i)+1];
            sum_level_1[72] <= bin_out[144];
        end
    end

    reg signed [17:0] sum_level_2[36:0];
    always @* begin
        for(i=0; i<=35; i=i+1)
            sum_level_2[i] <= sum_level_1[(2*i)] + sum_level_1[(2*i)+1];
        sum_level_2[36] <= sum_level_1[72];
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
        sum_level_6[0] <= sum_level_5[0] + sum_level_5[1];
        sum_level_6[1] <= sum_level_5[2] + sum_level_5[3];
        sum_level_6[2] <= sum_level_5[4];
    end

    reg signed [17:0] sum_level_7[1:0];
    always @* begin
        sum_level_7[0] <= sum_level_6[0] + sum_level_6[1];
        sum_level_7[1] <= sum_level_6[2];
    end

    // Finally we register the output
    always @(posedge clk or posedge reset) begin
        if(reset)
            out = 0;
        else if(sam_clk_en)
            out = sum_level_7[0] + sum_level_7[1];
    end

endmodule
`endif
