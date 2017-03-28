`ifndef _SRRC_PRAC_TX_FLT_V_
`define _SRRC_PRAC_TX_FLT_V_

`ifndef _DEFINES_VH
    `include "defines.vh"
`endif

`ifndef _CONFIG_SAM_DELAY_PRAC_V_
    `include "config_sam_delay_prac.v"
`endif

module srrc_prac_tx_flt(input clk,
                        input sam_clk_en,
                        input sym_clk_en,
                        input reset,
                        input signed [17:0] in,
                        output reg signed [17:0] out);

    integer i;
    // Precomputed filter outputs from LUT
    wire signed [17:0] PRECOMP_P2[114:0];
	wire signed [17:0] PRECOMP_P1[114:0];
    wire signed [17:0] PRECOMP_N1[114:0];
    wire signed [17:0] PRECOMP_N2[114:0];

    `include "../../model/LUT/srrc_tx_practical_coefs.vh"
    //`include "../../model/dummy_coefs.txt"


    // Shift register
    reg signed [17:0] bin[114:0];
    always @(posedge clk or posedge reset)
        for(i=0; i<=114; i=i+1) begin
            if(reset)
                bin[i] <= 0;
            else if(sam_clk_en)
                if(i == 0)
                    bin[0] <= in[17:0];
                else
                    bin[i] <= bin[i-1];
        end

    reg [17:0] bin_out[114:0];
    always @*
        for(i=0; i<=114; i=i+1)
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
    reg signed [17:0] sum_level_1[57:0];
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            for(i=0; i<=56; i=i+1)
                sum_level_1[i] <= 0;
            sum_level_1[57] <= 0;
        end
        else begin
            for(i=0; i<=56; i=i+1)
                sum_level_1[i] <= bin_out[(2*i)] + bin_out[(2*i)+1];
            sum_level_1[57] <= bin_out[114];
        end
    end

    reg signed [17:0] sum_level_2[29:0];
    always @* begin
        for(i=0; i<=28; i=i+1)
            sum_level_2[i] <= sum_level_1[(2*i)] + sum_level_1[(2*i)+1];
        sum_level_2[29] <= sum_level_1[57];
    end

    reg signed [17:0] sum_level_3[14:0];
    always @* begin
        for(i=0; i<=14; i=i+1)
            sum_level_3[i] <= sum_level_2[(2*i)] + sum_level_2[(2*i)+1];
    end

    reg signed [17:0] sum_level_4[7:0];
    always @* begin
        for(i=0; i<=6; i=i+1)
            sum_level_4[i] <= sum_level_3[(2*i)] + sum_level_3[(2*i)+1];
        sum_level_4[7] <= sum_level_3[14];
    end

    reg signed [17:0] sum_level_5[3:0];
    always @* begin
        for(i=0; i<=3; i=i+1)
            sum_level_5[i] <= sum_level_4[(2*i)] + sum_level_4[(2*i)+1];
    end

    reg signed [17:0] sum_level_6[1:0];
    always @* begin
        sum_level_6[0] <= sum_level_5[0] + sum_level_5[1];
        sum_level_6[1] <= sum_level_5[2] + sum_level_5[3];
    end

    reg signed [17:0] sum_level_7;
    always @* begin
        sum_level_7 <= sum_level_6[0] + sum_level_6[1];
    end

    // Finally we register the output
    reg signed [17:0] out_pre;
    always @(posedge clk or posedge reset) begin
        if(reset)
            out_pre = 0;
        else if(sam_clk_en)
            out_pre = sum_level_7;
    end

    // Add a configurable delay chain in order to match the delay from the gold standard filter
    wire signed [17:0] out_delayed;
    config_sam_delay_prac config_sam_del_prac_tb(.clk(clk),
                                                 .sam_clk_en(sam_clk_en),
                                                 .sym_clk_en(sym_clk_en),
                                                 .reset(reset),
                                                 .delay(5'd14), // Difference in length between this filter and gold standard
                                                 .in(out_pre),
                                                 .out(out_delayed));

    always @*
        out = out_delayed;

endmodule
`endif
