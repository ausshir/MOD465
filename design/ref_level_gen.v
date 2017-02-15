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

    // Function to truncate numbers cleanly :)
    function [17:0] trunc_36_to_18(input [35:0] val36);
        trunc_36_to_18 = val36[34:17];
    endfunction

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
    reg signed [17:0] avg_power_intermediate;
    always @(posedge clk or posedge reset)
        if(reset) begin
            avg_power <= 17'd0;
            avg_power_intermediate <= 17'd0;
        end
        else begin
            avg_power_intermediate <= trunc_36_to_18(ref_level * ref_level);
            avg_power <= trunc_36_to_18(avg_power_intermediate * `REF_POWER);
        end

endmodule
`endif
