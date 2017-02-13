`ifndef _REF_LEVEL_GEN_V_
`define _REF_LEVEL_GEN_V_

// Accumulates and generates a reference level in order to slice the signal into symbols
//  Also creates an estimate of the average output power

module ref_level_gen(input clk,
                    input clk_en,
                    input reset, // clear accumulators
                    input signed [17:0] dec_var,
                    output signed reg [17:0] ref_level,
                    output signed reg [17:0] avg_power);

    parameter LFSR_LEN = 22;
    parameter REF_POWER = 18'd81919; //1.25 in 1s17 (0.625 of FS 131071)

    // Create the absolute value to accumulate an average (inverted MSB)
    reg signed [17:0] dec_var_abs;
    always @(posedge clk, reset)
        if(clk_en)
            dec_var_abs = {1'b0, dec_var[16:0]};

    reg signed [17+LFSR_LEN:0] acc_full;
    always @(posedge clk, reset)
        if(reset)
            acc_full = {{18 + LFSR_LENGTH}{1'b0}};
        if(clk_en)
            acc_full = acc_full + dec_var_abs;

    // Generate the average value and power output
    always @(posedge clk, reset)
        if(reset)
            ref_level = 18'd0;
        else if(clk_en)
            ref_level = acc_full[17:0];

    // NOTE Perhaps this should be pipelined but this is a problem for future me
    always @(posedge clk, reset)
        if(reset)
            avg_power = 17'd0;
        else
            avg_power = ((ref_level * ref_level)[17:0] * REF_POWER)[17:0]

endmodule
`endif
