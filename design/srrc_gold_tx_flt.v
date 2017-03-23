`ifndef _SRRC_GOLD_TX_FLT_V_
`define _SRRC_GOLD_TX_FLT_V_

`include "defines.vh"

module srrc_gold_tx_flt(input clk,
                        input sam_clk_en,
                        input sym_clk_en,
                        input reset,
                        input signed [17:0] in,
                        output reg signed [17:0] out);

    integer i;
    // Precomputed filter outputs from LUT
    wire signed [17:0] PRECOMP_P2[198:0];
	wire signed [17:0] PRECOMP_P1[198:0];
    wire signed [17:0] PRECOMP_N1[198:0];
    wire signed [17:0] PRECOMP_N2[198:0];

    `include "../../model/LUT/srrc_tx_gold_coefs.vh"
    //`include "../../model/dummy_coefs.txt"

    // Instead of a full shift register, use a counter to keep track and only shift every 4th sample.
    // The counter is at zero when a new symbol moves into the filter
    // The last bin contains the ouput data that is shifted to the end (representing the 17th tap)
    (*noprune*) reg [1:0] count4, count4_delay;
    always @(posedge clk)
        count4 = phase4;

    always @(posedge clk)
        count4_delay = count4;
    /*
    always @(posedge clk or posedge reset)
        if(reset)
            count4 = 2'd0;
        else if(sym_clk_en)
            count4 = 2'd0;
        else if(sam_clk_en)
            count4 = count4 + 2'd1;
    */


    // Register inputs to improve timing characteristics (?)
    //  Note this delays our bins by count4 = 1, so the case statement is offset
    reg signed [17:0] in_reg;
    always @(posedge clk or posedge reset)
        if(reset)
            in_reg = 0;
        else if(sam_clk_en)
            in_reg = in;

    // Shift register
    // Note, this may need to be a latch for timing requirements
    // Also, previously used negedge
    (*noprune*) reg signed [17:0] bin[49:0];
    always @(posedge clk or posedge reset)
        for(i=0; i<=49; i=i+1) begin
            if(reset)
                bin[i] <= 0;
            else if(sam_clk_en)
                if(count4 == 2'd2)
                    if(i == 0)
                        bin[0] <= {in_reg[17:0]};
                    else
                        bin[i] <= bin[i-1];
                else
                    bin[i] <= bin[i];
            else
                bin[i] <= bin[i];
        end

    reg [17:0] bin_out[49:0];
    always @*//(posedge clk or posedge reset)
        for(i = 0; i <= 48; i = i+1)
            if(reset)
                bin_out[i] <= 18'd0;
            //else if(sam_clk_en)
            else if(bin[i] == `SYMBOL_P1)
                case (count4)
                    2'd2: bin_out[i] <= PRECOMP_P1[4*i];
                    2'd3: bin_out[i] <= PRECOMP_P1[4*i+1];
                    2'd0: bin_out[i] <= PRECOMP_P1[4*i+2];
                    2'd1: bin_out[i] <= PRECOMP_P1[4*i+3];
                    default: bin_out[i] <= 17'd0;
                endcase

            else if(bin[i] == `SYMBOL_P2)
                case (count4)
                    2'd2: bin_out[i] <= PRECOMP_P2[4*i];
                    2'd3: bin_out[i] <= PRECOMP_P2[4*i+1];
                    2'd0: bin_out[i] <= PRECOMP_P2[4*i+2];
                    2'd1: bin_out[i] <= PRECOMP_P2[4*i+3];
                    default: bin_out[i] <= 17'd0;
                endcase

            else if(bin[i] == `SYMBOL_N1)
                case (count4)
                    2'd2: bin_out[i] <= PRECOMP_N1[4*i];
                    2'd3: bin_out[i] <= PRECOMP_N1[4*i+1];
                    2'd0: bin_out[i] <= PRECOMP_N1[4*i+2];
                    2'd1: bin_out[i] <= PRECOMP_N1[4*i+3];
                    default: bin_out[i] <= 17'd0;
                endcase

            else if(bin[i] == `SYMBOL_N2)
                case (count4)
                    2'd2: bin_out[i] <= PRECOMP_N2[4*i];
                    2'd3: bin_out[i] <= PRECOMP_N2[4*i+1];
                    2'd0: bin_out[i] <= PRECOMP_N2[4*i+2];
                    2'd1: bin_out[i] <= PRECOMP_N2[4*i+3];
                    default: bin_out[i] <= 17'd0;
                endcase
            else // Invalid data OR zeroes (not connected/impulse response/zero stuffed)
                bin_out[i] <= 18'd0;
            //else
            //    bin_out[i] <= 0;

    // Last Bin (single item, we should just make sure filters are a multiple of 4...) :)
    always @*//(posedge clk or posedge reset)
        if(reset)
            bin_out[49] = 18'd0;
        else if(count4 == 2'd2)
            if(bin[49] == `SYMBOL_P1)
                bin_out[49] = PRECOMP_P1[16];
            else if(bin[49] == `SYMBOL_P2)
                bin_out[49] = PRECOMP_P2[16];
            else if(bin[49] == `SYMBOL_N1)
                bin_out[49] = PRECOMP_N1[16];
            else if(bin[49] == `SYMBOL_N2)
                bin_out[49] = PRECOMP_N2[16];
            else
                bin_out[49] = 18'd0;
        else
            bin_out[49] = 18'd0;

    // Adder Tree
    reg signed [17:0] sum_level_3[24:0];
    always @(posedge clk)
        for(i=0; i<=24; i=i+1)
            sum_level_3[i] <= bin_out[(2*i)] + bin_out[(2*i)+1];

    reg signed [17:0] sum_level_4[12:0];
    always @(posedge clk) begin
        for(i=0; i<=11; i=i+1)
            sum_level_4[i] <= sum_level_3[(2*i)] + sum_level_3[(2*i)+1];
        sum_level_4[12] <= sum_level_3[24];
    end

    reg signed [17:0] sum_level_5[6:0];
    always @(posedge clk) begin
        for(i=0; i<=5; i=i+1)
            sum_level_5[i] <= sum_level_4[(2*i)] + sum_level_4[(2*i)+1];
        sum_level_5[6] <= sum_level_4[12];
    end

    reg signed [17:0] sum_level_6[3:0];
    always @(posedge clk) begin
        for(i=0; i<=2; i=i+1)
            sum_level_6[i] <= sum_level_5[(2*i)] + sum_level_5[(2*i)+1];
        sum_level_6[3] <= sum_level_5[6];
    end

    reg signed [17:0] sum_level_7[1:0];
    always @(posedge clk) begin
        sum_level_7[0] <= sum_level_6[0] + sum_level_6[1];
        sum_level_7[1] <= sum_level_6[2] + sum_level_6[3];
    end

    reg signed [17:0] sum_level_8;
    always @(posedge clk) begin
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
