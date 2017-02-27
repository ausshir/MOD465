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
    // Note that the last 305:307 are zeros to stuff the bin
    wire [17:0] PRECOMP_P2[307:0];
	wire [17:0] PRECOMP_P1[307:0];
    wire [17:0] PRECOMP_N1[307:0];
    wire [17:0] PRECOMP_N2[307:0];

    `include "../../model/dummy_coefs.txt"

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
        else if(sym_clk_en)
            in_reg = in;

    // Shift register
    // Note, this may need to be a latch for timing requirements
    // Also, previously used negedge
    reg signed [17:0] bin[76:0];
    //always @(posedge clk or posedge reset)
    //    if(reset)
    //        bin[0] = 18'd0;
    //    else if(count4 == 2'd0) // A new symbol is available
    //        bin[0] = {in_reg[17:0]};

    always @(posedge clk or posedge reset)
            if(reset)
                for(i = 0; i <= 76; i = i+1) begin
                    bin[i] <= 18'd0;
                end
            else if(sym_clk_en)
                for(i = 0; i <= 76; i = i+1) begin
                    if(i == 0)
                        bin[0] <= {in_reg[17:0]};
                    else
                        bin[i] <= bin[i-1];
                end

    // The last bin holds only a single sample, so it needs to be updated every sam_clk
    /*
    always @(posedge clk or posedge reset)
        if(reset)
            bin[76] = 18'd0;
        else if(sam_clk_en)
            if(count4 == 2'd0)
                bin[76] = bin[75];
            else
                bin[76] = 18'd0;
    */

    reg [17:0] bin_out[76:0];
    always @*
        for(i = 0; i <= 75; i = i+1)
            if(reset)
                bin_out[i] <= 18'd0;
            else if(sam_clk_en)
                if(bin[i] == `SYMBOL_P1)
                    case (count4)
                        2'd0: bin_out[i] <= PRECOMP_P1[4*i];
                        2'd1: bin_out[i] <= PRECOMP_P1[4*i+1];
                        2'd2: bin_out[i] <= PRECOMP_P1[4*i+2];
                        2'd3: bin_out[i] <= PRECOMP_P1[4*i+3];
                        default: bin_out[i] <= 17'd0;
                    endcase

                else if(bin[i] == `SYMBOL_P2)
                    case (count4)
                        2'd0: bin_out[i] <= PRECOMP_P2[4*i];
                        2'd1: bin_out[i] <= PRECOMP_P2[4*i+1];
                        2'd2: bin_out[i] <= PRECOMP_P2[4*i+2];
                        2'd3: bin_out[i] <= PRECOMP_P2[4*i+3];
                        default: bin_out[i] <= 17'd0;
                    endcase

                else if(bin[i] == `SYMBOL_N1)
                    case (count4)
                        2'd0: bin_out[i] <= PRECOMP_N1[4*i];
                        2'd1: bin_out[i] <= PRECOMP_N1[4*i+1];
                        2'd2: bin_out[i] <= PRECOMP_N1[4*i+2];
                        2'd3: bin_out[i] <= PRECOMP_N1[4*i+3];
                        default: bin_out[i] <= 17'd0;
                    endcase

                else if(bin[i] == `SYMBOL_N2)
                    case (count4)
                        2'd0: bin_out[i] <= PRECOMP_N2[4*i];
                        2'd1: bin_out[i] <= PRECOMP_N2[4*i+1];
                        2'd2: bin_out[i] <= PRECOMP_N2[4*i+2];
                        2'd3: bin_out[i] <= PRECOMP_N2[4*i+3];
                        default: bin_out[i] <= 17'd0;
                    endcase
                else // Invalid data or zeroes (not connected/impulse response)
                    bin_out[i] <= 18'd0;

    // Last Bin (single item) :)
    always @*
        if(reset)
            bin_out[76] = 18'd0;
        else if(sam_clk_en && count4 == 2'd0)
            if(bin[76] == `SYMBOL_P1)
                bin_out[76] = PRECOMP_P1[16];
            else if(bin[76] == `SYMBOL_P2)
                bin_out[76] = PRECOMP_P2[16];
            else if(bin[76] == `SYMBOL_N1)
                bin_out[76] = PRECOMP_N1[16];
            else if(bin[76] == `SYMBOL_N2)
                bin_out[76] = PRECOMP_N2[16];
            else
                bin_out[76] = 18'd0;
        else
            bin_out[76] = 18'd0;

    // OMG is this even possible???
    always @(posedge clk or posedge reset)
        if(reset)
            out = 18'd0;
        else if(sam_clk_en)
            out = bin_out[76] + bin_out[75] + bin_out[74] + bin_out[73] + bin_out[72] + bin_out[71] + bin_out[70]
                + bin_out[69] + bin_out[68] + bin_out[67] + bin_out[66] + bin_out[65] + bin_out[64] + bin_out[63]
                + bin_out[62] + bin_out[61] + bin_out[60] + bin_out[59] + bin_out[58] + bin_out[57] + bin_out[56]
                + bin_out[55] + bin_out[54] + bin_out[53] + bin_out[52] + bin_out[51] + bin_out[50] + bin_out[49]
                + bin_out[48] + bin_out[47] + bin_out[46] + bin_out[45] + bin_out[44] + bin_out[43] + bin_out[42]
                + bin_out[41] + bin_out[40] + bin_out[39] + bin_out[38] + bin_out[37] + bin_out[36] + bin_out[35]
                + bin_out[34] + bin_out[33] + bin_out[32] + bin_out[31] + bin_out[30] + bin_out[29] + bin_out[28]
                + bin_out[27] + bin_out[26] + bin_out[25] + bin_out[24] + bin_out[23] + bin_out[22] + bin_out[21]
                + bin_out[20] + bin_out[19] + bin_out[18] + bin_out[17] + bin_out[16] + bin_out[15] + bin_out[14]
                + bin_out[13] + bin_out[12] + bin_out[11] + bin_out[10] + bin_out[ 9] + bin_out[ 8] + bin_out[ 7]
                + bin_out[ 6] + bin_out[ 5] + bin_out[ 4] + bin_out[ 3] + bin_out[ 2] + bin_out[ 1] + bin_out[ 0];

endmodule
`endif
