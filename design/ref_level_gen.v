`ifndef _REF_LEVEL_GEN_V_
`define _REF_LEVEL_GEN_V_

// Accumulates and generates a reference level in order to slice the signal into symbols
//  Also creates an estimate of the average output power

`include "defines.vh"

module ref_level_gen(input clk,
                    input clk_en,
                    input reset, // clear accumulators
                    input signed [17:0] dec_var,
                    output reg signed [17:0] ref_level,
                    output reg signed [17:0] avg_power);

    // Create the absolute value to accumulate an average (inverted MSB)
    reg signed [17:0] dec_var_abs;
    always @(posedge clk or posedge reset)
		  if(reset)
		      dec_var_abs = 18'd0;
        else if(clk_en)
            dec_var_abs = {1'b0, dec_var[16:0]};

    reg signed [17+`LFSR_LEN:0] acc_full;
    always @(posedge clk or posedge reset)
        if(reset)
            acc_full = {{18 + `LFSR_LEN}{1'b0}};
        else if(clk_en)
            acc_full = acc_full + dec_var_abs;

    // Generate the average value and power output
    always @(posedge clk or posedge reset)
        if(reset)
            ref_level = 18'd0;
        else if(clk_en)
            ref_level = acc_full[17:0];

    // NOTE Perhaps this should be pipelined but this is a problem for future me
    always @(posedge clk or posedge reset)
        if(reset)
            avg_power = 17'd0;
        else
            avg_power = ((ref_level * ref_level) * `REF_POWER);

endmodule
`endif
