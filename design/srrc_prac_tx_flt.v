`ifndef _SRRC_PRAC_TX_FLT_V_
`define _SRRC_PRAC_TX_FLT_V_

`ifndef _DEFINES_VH
    `include "defines.vh"
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

    // Instead of a full shift register, use a counter to keep track and only shift every 4th sample.
    // The counter is at zero when a new symbol moves into the filter
    // The last bin contains the ouput data that is shifted to the end (representing the 17th tap)
    (*noprune*) reg [1:0] count4;
    always @(posedge clk or posedge reset)
        if(reset)
            count4 = 2'd0;
        else if(sym_clk_en)
            count4 = 2'd0;
        else if(sam_clk_en)
            count4 = count4 + 2'd1;

    // Shift register
    // Note, this may need to be a latch for timing requirements
    // Also, previously used negedge
    reg signed [17:0] bin[28:0];
    always @(posedge clk or posedge reset)
        for(i=0; i<=28; i=i+1) begin
            if(reset)
                bin[i] <= 0;
            else if(sam_clk_en)
                if(count4 == 2'd0)
                    if(i == 0)
                        bin[0] <= in[17:0];
                    else
                        bin[i] <= bin[i-1];
        end

    reg [17:0] bin_out[28:0];
    always @*
        for(i = 0; i <= 27; i = i+1)
            if(reset)
                bin_out[i] <= 18'd0;
            //else if(sam_clk_en)
            else begin
                case(bin[i])
                    `SYMBOL_P1:
                        begin
                            case (count4)
                                2'd0: bin_out[i] <= PRECOMP_P1[4*i];
                                2'd1: bin_out[i] <= PRECOMP_P1[4*i+1];
                                2'd2: bin_out[i] <= PRECOMP_P1[4*i+2];
                                2'd3: bin_out[i] <= PRECOMP_P1[4*i+3];
                                default: bin_out[i] <= 17'd0;
                            endcase
                        end
                    `SYMBOL_P2:
                        begin
                            case (count4)
                                2'd0: bin_out[i] <= PRECOMP_P2[4*i];
                                2'd1: bin_out[i] <= PRECOMP_P2[4*i+1];
                                2'd2: bin_out[i] <= PRECOMP_P2[4*i+2];
                                2'd3: bin_out[i] <= PRECOMP_P2[4*i+3];
                                default: bin_out[i] <= 17'd0;
                            endcase
                        end

                    `SYMBOL_N1:
                        begin
                            case (count4)
                                2'd0: bin_out[i] <= PRECOMP_N1[4*i];
                                2'd1: bin_out[i] <= PRECOMP_N1[4*i+1];
                                2'd2: bin_out[i] <= PRECOMP_N1[4*i+2];
                                2'd3: bin_out[i] <= PRECOMP_N1[4*i+3];
                                default: bin_out[i] <= 17'd0;
                            endcase
                        end

                    `SYMBOL_N2:
                        begin
                            case (count4)
                                2'd0: bin_out[i] <= PRECOMP_N2[4*i];
                                2'd1: bin_out[i] <= PRECOMP_N2[4*i+1];
                                2'd2: bin_out[i] <= PRECOMP_N2[4*i+2];
                                2'd3: bin_out[i] <= PRECOMP_N2[4*i+3];
                                default: bin_out[i] <= 17'd0;
                            endcase
                        end

                    // Invalid data OR zeroes (not connected/impulse response/zero stuffed)
                    default: bin_out[i] <= 18'd0;
                endcase
            end

    // Last Bin (single item, we should just make sure filters are a multiple of 4...) :)
    always @*//(posedge clk or posedge reset)
        if(reset)
            bin_out[28] = 18'd0;
        else if(count4 == 2'd0)
            if(bin[28] == `SYMBOL_P1)
                bin_out[28] = PRECOMP_P1[114];
            else if(bin[28] == `SYMBOL_P2)
                bin_out[28] = PRECOMP_P2[114];
            else if(bin[28] == `SYMBOL_N1)
                bin_out[28] = PRECOMP_N1[114];
            else if(bin[28] == `SYMBOL_N2)
                bin_out[28] = PRECOMP_N2[114];
            else
                bin_out[28] = 18'd0;
        else
            bin_out[28] = 18'd0;

    // Adder Tree
    reg signed [17:0] sum_level_3[14:0];
    always @(posedge clk) begin
        for(i=0; i<=13; i=i+1)
            sum_level_3[i] <= bin_out[(2*i)] + bin_out[(2*i)+1];
        sum_level_3[14] = bin_out[28];
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
    always @(posedge clk or posedge reset) begin
        if(reset)
            out = 0;
        else if(sam_clk_en)
            out = sum_level_7;
    end

endmodule
`endif
