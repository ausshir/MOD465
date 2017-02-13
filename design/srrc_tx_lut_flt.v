`ifndef _SRRC_TX_LUT_FLT_V_
`define _SRRC_TX_LUT_FLT_V_

// Signed FS+ and FS- are the symbol encodings used

module srrc_tx_lut_flt (input clk,
								input sam_clk,
								input sym_clk,
								input reset,
								input signed [17:0] in,
								output reg signed [17:0] out);

    integer i;
    reg [17:0] PRECOMP_P1[16:0];
	 reg [17:0] PRECOMP_P2[16:0];
    reg [17:0] PRECOMP_N1[16:0];
    reg [17:0] PRECOMP_N2[16:0];
    reg [17:0] SYMBOL_P1;
    reg [17:0] SYMBOL_N1;
    reg [17:0] SYMBOL_P2;
    reg [17:0] SYMBOL_N2;


    always @* begin
        //if(reset)
			//TX Filter 18'sd Positive LUT P1 Coefficients (headroom)
			PRECOMP_P1[ 0] =  18'sd    118;
			PRECOMP_P1[ 1] = -18'sd    793;
			PRECOMP_P1[ 2] = -18'sd   2154;
			PRECOMP_P1[ 3] = -18'sd   2601;
			PRECOMP_P1[ 4] = -18'sd    270;
			PRECOMP_P1[ 5] =  18'sd   5763;
			PRECOMP_P1[ 6] =  18'sd  14211;
			PRECOMP_P1[ 7] =  18'sd  21737;
			PRECOMP_P1[ 8] =  18'sd  24759;
			PRECOMP_P1[ 9] =  18'sd  21737;
			PRECOMP_P1[10] =  18'sd  14211;
			PRECOMP_P1[11] =  18'sd   5763;
			PRECOMP_P1[12] = -18'sd    270;
			PRECOMP_P1[13] = -18'sd   2601;
			PRECOMP_P1[14] = -18'sd   2154;
			PRECOMP_P1[15] = -18'sd    793;
			PRECOMP_P1[16] =  18'sd    118;

			//TX Filter 18'sd Positive LUT P1 Coefficients (headroom)
			PRECOMP_P2[ 0] =  18'sd     39;
			PRECOMP_P2[ 1] = -18'sd    264;
			PRECOMP_P2[ 2] = -18'sd    718;
			PRECOMP_P2[ 3] = -18'sd    867;
			PRECOMP_P2[ 4] = -18'sd     90;
			PRECOMP_P2[ 5] =  18'sd   1921;
			PRECOMP_P2[ 6] =  18'sd   4737;
			PRECOMP_P2[ 7] =  18'sd   7246;
			PRECOMP_P2[ 8] =  18'sd   8253;
			PRECOMP_P2[ 9] =  18'sd   7246;
			PRECOMP_P2[10] =  18'sd   4737;
			PRECOMP_P2[11] =  18'sd   1921;
			PRECOMP_P2[12] = -18'sd     90;
			PRECOMP_P2[13] = -18'sd    867;
			PRECOMP_P2[14] = -18'sd    718;
			PRECOMP_P2[15] = -18'sd    264;
			PRECOMP_P2[16] =  18'sd     39;

			//TX Filter 18'sd Negative LUT N1 Coefficients (headroom)
			PRECOMP_N1[ 0] = -18'sd     39;
			PRECOMP_N1[ 1] =  18'sd    264;
			PRECOMP_N1[ 2] =  18'sd    718;
			PRECOMP_N1[ 3] =  18'sd    867;
			PRECOMP_N1[ 4] =  18'sd     90;
			PRECOMP_N1[ 5] = -18'sd   1921;
			PRECOMP_N1[ 6] = -18'sd   4737;
			PRECOMP_N1[ 7] = -18'sd   7246;
			PRECOMP_N1[ 8] = -18'sd   8253;
			PRECOMP_N1[ 9] = -18'sd   7246;
			PRECOMP_N1[10] = -18'sd   4737;
			PRECOMP_N1[11] = -18'sd   1921;
			PRECOMP_N1[12] =  18'sd     90;
			PRECOMP_N1[13] =  18'sd    867;
			PRECOMP_N1[14] =  18'sd    718;
			PRECOMP_N1[15] =  18'sd    264;
			PRECOMP_N1[16] = -18'sd     39;

			//TX Filter 18'sd Negative LUT N2 Coefficients (headroom)
			PRECOMP_N2[ 0] = -18'sd    118;
			PRECOMP_N2[ 1] =  18'sd    793;
			PRECOMP_N2[ 2] =  18'sd   2154;
			PRECOMP_N2[ 3] =  18'sd   2601;
			PRECOMP_N2[ 4] =  18'sd    270;
			PRECOMP_N2[ 5] = -18'sd   5763;
			PRECOMP_N2[ 6] = -18'sd  14211;
			PRECOMP_N2[ 7] = -18'sd  21737;
			PRECOMP_N2[ 8] = -18'sd  24759;
			PRECOMP_N2[ 9] = -18'sd  21737;
			PRECOMP_N2[10] = -18'sd  14211;
			PRECOMP_N2[11] = -18'sd   5763;
			PRECOMP_N2[12] =  18'sd    270;
			PRECOMP_N2[13] =  18'sd   2601;
			PRECOMP_N2[14] =  18'sd   2154;
			PRECOMP_N2[15] =  18'sd    793;
			PRECOMP_N2[16] = -18'sd    118;

			SYMBOL_P1 =  18'sd 49151; //0.375 with 131071 max +FS
			SYMBOL_P2 =  18'sd 16383; //0.125
			SYMBOL_N1 = -18'sd 16384; //-0.125
			SYMBOL_N2 = -18'sd 49151; //-0.375 with -131072 max -FS
    end

    // Instead of a full shift register, use a counter to keep track and only shift every 4th sample.
    // The counter is at zero when a new symbol moves into the filter
    // The last bin contains the ouput data that is shifted to the end (representing the 17th tap)
    reg [1:0] count4;
    always @(negedge clk)
		if(sam_clk)
		  if(reset)
				count4 = 2'd0;
		  else if(sym_clk)
				count4 = 2'd0;
		  else
				count4 = count4 + 2'd1;

	 // Shift register
	 // I don't like that this has to be a latch but I see no other way...
	 // Negedge clock works in modelsim..... :(
    reg signed [17:0] bin[4:0];
    always @*
		if(sym_clk)
        if(reset)
            bin[0] = 18'd0;
        else if(count4 == 2'd0) // A new symbol is available
            bin[0] = {in[17:0]};

    always @(negedge clk)
		if(sym_clk)
        for(i = 1; i <= 3; i = i+1)
			 if(reset)
				  bin[i] <= 18'd0;
			 else
				  bin[i] <= bin[i-1];

		always @(negedge clk)
			if(sam_clk)
				if(reset)
					bin[4] = 18'd0;
				else
					bin[4] = bin[3]; // this is a single value, not 4x

    // For each item, output a different value depending on the value held in symbol
    reg [17:0] bin_out[4:0];
    always @*
        for(i = 0; i <= 3; i = i+1)
				if(reset)
                bin_out[i] <= 18'd0;

				else if(bin[i] == SYMBOL_P1)
                case (count4)
                    2'd0: bin_out[i] <= PRECOMP_P1[4*i];
                    2'd1: bin_out[i] <= PRECOMP_P1[4*i+1];
                    2'd2: bin_out[i] <= PRECOMP_P1[4*i+2];
                    2'd3: bin_out[i] <= PRECOMP_P1[4*i+3];
                    default: bin_out[i] <= 17'd0;
                endcase

				else if(bin[i] == SYMBOL_P2)
                case (count4)
                    2'd0: bin_out[i] <= PRECOMP_P2[4*i];
                    2'd1: bin_out[i] <= PRECOMP_P2[4*i+1];
                    2'd2: bin_out[i] <= PRECOMP_P2[4*i+2];
                    2'd3: bin_out[i] <= PRECOMP_P2[4*i+3];
                    default: bin_out[i] <= 17'd0;
                endcase

				else if(bin[i] == SYMBOL_N1)
                case (count4)
                    2'd0: bin_out[i] <= PRECOMP_N1[4*i];
                    2'd1: bin_out[i] <= PRECOMP_N1[4*i+1];
                    2'd2: bin_out[i] <= PRECOMP_N1[4*i+2];
                    2'd3: bin_out[i] <= PRECOMP_N1[4*i+3];
                    default: bin_out[i] <= 17'd0;
                endcase

            else if(bin[i] == SYMBOL_N2)
                case (count4)
                    2'd0: bin_out[i] <= PRECOMP_N2[4*i];
                    2'd1: bin_out[i] <= PRECOMP_N2[4*i+1];
                    2'd2: bin_out[i] <= PRECOMP_N2[4*i+2];
                    2'd3: bin_out[i] <= PRECOMP_N2[4*i+3];
                    default: bin_out[i] <= 17'd0;
                endcase
            else
                bin_out[i] <= 18'd0;

    // Last Bin (single item) :)
    always @*
        if(reset)
            bin_out[4] = 18'd0;
        else if(bin[4] == SYMBOL_P1)
            bin_out[4] = PRECOMP_P1[16];
		  else if(bin[4] == SYMBOL_P2)
            bin_out[4] = PRECOMP_P2[16];
		  else if(bin[4] == SYMBOL_N1)
            bin_out[4] = PRECOMP_N1[16];
        else if(bin[4] == SYMBOL_N2)
            bin_out[4] = PRECOMP_N2[16];
		  else
				bin_out[4] = 18'd0;


	// I should probably use an adder tree, but for 5 bins I didn't think it would really help much
    always @(negedge clk)
        if(reset)
            out = 18'd0;
        else
            out = bin_out[4] + bin_out[3] + bin_out[2] + bin_out[1]+  bin_out[0];

endmodule
`endif
