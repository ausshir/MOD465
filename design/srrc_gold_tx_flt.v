`ifndef _SRRC_GOLD_TX_FLT_V_
`define _SRRC_GOLD_TX_FLT_V_

`include "defines.vh"

module srrc_gold_tx_flt(input clk,
                        input fastclk,
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
    reg [1:0] count4;
    always @(posedge clk or posedge reset)
        if(reset)
            count4 = 2'd0;
        else if(sym_clk_en)
            count4 = 2'd0;
        else if(sam_clk_en)
            count4 = count4 + 2'd1;

    reg signed [17:0] in_reg;
    always @(posedge clk or posedge reset)
        if(reset)
            in_reg = 0;
        else if(sam_clk_en)
            in_reg = in;

    // Shift register
    // Note, this may need to be a latch for timing requirements
    // Also, previously used negedge
    reg signed [17:0] bin[49:0];
    always @(posedge clk or posedge reset)
            if(reset)
                for(i=0; i<=49; i=i+1) begin
                    bin[i] <= 0;
                end
            else if(sam_clk_en)
                if(count4 == 2'd1)
                    for(i=0; i<=49; i=i+1) begin
                        if(i == 0)
                            bin[0] <= {in_reg[17:0]};
                        else
                            bin[i] <= bin[i-1];
                    end
            else
                for(i=0; i<=49; i=i+1) begin
                    bin[i] = bin[i];
                end

    reg [17:0] bin_out[49:0];
    always @(posedge fastclk or posedge reset)
        for(i = 0; i <= 48; i = i+1)
            if(reset)
                bin_out[i] <= 18'd0;
            else if(sam_clk_en)
                if(bin[i] == `SYMBOL_P1)
                    case (count4)
                        2'd1: bin_out[i] <= PRECOMP_P1[4*i];
                        2'd2: bin_out[i] <= PRECOMP_P1[4*i+1];
                        2'd3: bin_out[i] <= PRECOMP_P1[4*i+2];
                        2'd0: bin_out[i] <= PRECOMP_P1[4*i+3];
                        default: bin_out[i] <= 17'd0;
                    endcase

                else if(bin[i] == `SYMBOL_P2)
                    case (count4)
                        2'd1: bin_out[i] <= PRECOMP_P2[4*i];
                        2'd2: bin_out[i] <= PRECOMP_P2[4*i+1];
                        2'd3: bin_out[i] <= PRECOMP_P2[4*i+2];
                        2'd0: bin_out[i] <= PRECOMP_P2[4*i+3];
                        default: bin_out[i] <= 17'd0;
                    endcase

                else if(bin[i] == `SYMBOL_N1)
                    case (count4)
                        2'd1: bin_out[i] <= PRECOMP_N1[4*i];
                        2'd2: bin_out[i] <= PRECOMP_N1[4*i+1];
                        2'd3: bin_out[i] <= PRECOMP_N1[4*i+2];
                        2'd0: bin_out[i] <= PRECOMP_N1[4*i+3];
                        default: bin_out[i] <= 17'd0;
                    endcase

                else if(bin[i] == `SYMBOL_N2)
                    case (count4)
                        2'd1: bin_out[i] <= PRECOMP_N2[4*i];
                        2'd2: bin_out[i] <= PRECOMP_N2[4*i+1];
                        2'd3: bin_out[i] <= PRECOMP_N2[4*i+2];
                        2'd0: bin_out[i] <= PRECOMP_N2[4*i+3];
                        default: bin_out[i] <= 17'd0;
                    endcase
                else // Invalid data or zeroes (not connected/impulse response)
                    bin_out[i] <= 18'd0;
            //else
            //    bin_out[i] <= 0;

    // Last Bin (single item) :)
    always @(posedge fastclk or posedge reset)
        if(reset)
            bin_out[49] = 18'd0;
        else if(sam_clk_en && count4 == 2'd0)
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
    // We need to go from 48 bins to 1 output.
    // On the first clock, we add together in goups of 4's
    reg signed [17:0] sum_level_1[12:0];
    always @(posedge clk) begin
        for(i=0; i<=11; i=i+1) begin
            sum_level_1[i] <= bin_out[(4*i)+0] + bin_out[(4*i)+1] + bin_out[(4*i)+2] + bin_out[(4*i)+3];
        end
        sum_level_1[12] <= bin_out[48] + bin_out[49];
    end

    // Again on the second clock
    reg signed [17:0] sum_level_2[3:0];
    always @(posedge clk) begin
        for(i=0; i<=2; i=i+1) begin
            sum_level_2[i] <= sum_level_1[(4*i)+0] + sum_level_1[(4*i)+1] + sum_level_1[(4*i)+2] + sum_level_1[(4*i)+3];
        end
        sum_level_2[3] = sum_level_1[12];
    end

    // On the last, we add in 3 inputs.
    reg signed [17:0] sum_level_3;
    always @(posedge clk) begin
        sum_level_3 = sum_level_2[0] + sum_level_2[1] + sum_level_2[2] + sum_level_2[3];
    end

    // Finally we register the output
    always @(posedge clk or posedge reset) begin
        if(reset)
            out = 0;
        else if(sam_clk_en)
            out = sum_level_3;
    end

endmodule
`endif
