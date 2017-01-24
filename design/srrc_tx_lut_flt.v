`ifndef _SRRC_TX_LUT_FLT_V_
`define _SRRC_TX_LUT_FLT_V_

// Signed FS+ and FS- are the symbol encodings used

module srrc_tx_lut_flt (input clk,
                    input reset,
                    input symbol_clk,
		            input signed [17:0] in,
	                output reg signed [17:0] out);

    integer i;
    reg [17:0] PRECOMP_P[16:0];
    reg [17:0] PRECOMP_N[16:0];
    reg [17:0] SYMBOL_P;
    reg [17:0] SYMBOL_N;

    always @* begin
        if(reset)
            PRECOMP_P[ 0] =  18'sd    314;
            PRECOMP_P[ 1] = -18'sd   2115;
            PRECOMP_P[ 2] = -18'sd   5743;
            PRECOMP_P[ 3] = -18'sd   6936;
            PRECOMP_P[ 4] = -18'sd    719;
            PRECOMP_P[ 5] =  18'sd  15367;
            PRECOMP_P[ 6] =  18'sd  37897;
            PRECOMP_P[ 7] =  18'sd  57966;
            PRECOMP_P[ 8] =  18'sd  66023;
            PRECOMP_P[ 9] =  18'sd  57966;
            PRECOMP_P[10] =  18'sd  37897;
            PRECOMP_P[11] =  18'sd  15367;
            PRECOMP_P[12] = -18'sd    719;
            PRECOMP_P[13] = -18'sd   6936;
            PRECOMP_P[14] = -18'sd   5743;
            PRECOMP_P[15] = -18'sd   2115;
            PRECOMP_P[16] =  18'sd    314;

            PRECOMP_N[ 0] = -18'sd    314;
            PRECOMP_N[ 1] =  18'sd   2115;
            PRECOMP_N[ 2] =  18'sd   5743;
            PRECOMP_N[ 3] =  18'sd   6936;
            PRECOMP_N[ 4] =  18'sd    719;
            PRECOMP_N[ 5] = -18'sd  15367;
            PRECOMP_N[ 6] = -18'sd  37897;
            PRECOMP_N[ 7] = -18'sd  57966;
            PRECOMP_N[ 8] = -18'sd  66023;
            PRECOMP_N[ 9] = -18'sd  57966;
            PRECOMP_N[10] = -18'sd  37897;
            PRECOMP_N[11] = -18'sd  15367;
            PRECOMP_N[12] =  18'sd    719;
            PRECOMP_N[13] =  18'sd   6936;
            PRECOMP_N[14] =  18'sd   5743;
            PRECOMP_N[15] =  18'sd   2115;
            PRECOMP_N[16] = -18'sd    314;

            SYMBOL_P =  18'sd 131071;
            SYMBOL_N = -18'sd 131071;
    end

    // Create a symbol control signal that is only high for the first clock pulse
    reg symbol;
    always @(posedge clk)
        if(symbol_clk)
            symbol = symbol + 1'b1;
        else
            symbol = 1'b0;

    // Instead of a full shift register, use a counter to keep track and only shift every 4th sample.
    // The counter is at zero when a new symbol moves into the filter
    // The last bin contains the ouput data that is shifted to the end (representing the 17th tap)
    reg [1:0] count4;
    always @(posedge clk)
        if(reset)
            count4 = 2'd0;
        else if(symbol)
            count4 = 2'd0;
        else
            count4 = count4 + 2'd1;

    reg signed [17:0] bin[4:0];

    always @*
        if(reset)
            bin[0] = 18'd0;
        else if(count4 == 2'd0)
            bin[0] = {in[17:0]};

    always @(posedge clk)
        for(i = 1; i <= 4; i = i+1)
            if(symbol)
                if(reset)
                    bin[i] <= 18'd0;
                else
                    bin[i] <= bin[i-1];

    // Not using symmetry really...
    // For each clock, output a different value depending on the value held in symbol
    reg [17:0] bin_out[4:0];
    always @*
        for(i = 0; i <= 3; i = i+1)
            if(reset)
                bin_out[i] <= 18'd0;
            else if(bin[i] == SYMBOL_P) // full scale positive
                case (count4)
                    2'd0: bin_out[i] <= PRECOMP_P[4*i]; //for example 131071 * 314 (?)
                    2'd1: bin_out[i] <= PRECOMP_P[4*i+1];
                    2'd2: bin_out[i] <= PRECOMP_P[4*i+2];
                    2'd3: bin_out[i] <= PRECOMP_P[4*i+3];
                    default: bin_out[i] <= 17'd0;
                endcase
            else if(bin[i] == SYMBOL_N)
                case (count4)
                    2'd0: bin_out[i] <= PRECOMP_N[4*i]; //for example 131071 * 314 (?)
                    2'd1: bin_out[i] <= PRECOMP_N[4*i+1];
                    2'd2: bin_out[i] <= PRECOMP_N[4*i+2];
                    2'd3: bin_out[i] <= PRECOMP_N[4*i+3];
                    default: bin_out[i] <= 17'd0;
                endcase
            else
                bin_out[i] <= 18'd0;

    always @*
        if(reset)
            bin_out[4] = 18'd0;
        else if(bin[4] == SYMBOL_P)
            bin_out[4] = PRECOMP_P[16];
        else if(bin[4] == SYMBOL_N)
            bin_out[4] = PRECOMP_N[16];

    always @(posedge clk)
        if(reset)
            out = 18'd0;
        else
            out = bin_out[4] + bin_out[3] + bin_out[2] + bin_out[1]+  bin_out[0];

endmodule
`endif
