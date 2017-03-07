`ifndef _REF_LEVEL_GEN_V_
`define _REF_LEVEL_GEN_V_

// Accumulates and generates a reference level in order to slice the signal into symbols
//  Also creates an estimate of the average output power

`ifndef _DEFINES_VH
    `include "defines.vh"
`endif

module ref_level_gen(input clk,
                    input clk_en,
                    input reset, // clear accumulators
                    input hold, // stop accumulating
                    input clear,
                    input signed [17:0] dec_var,
                    output reg signed [17:0] ref_level,
                    output reg signed [17:0] avg_power);

    // Function to truncate numbers cleanly :)
    function [17:0] trunc_36_to_18(input [35:0] val36);
        trunc_36_to_18 = val36[34:17];
    endfunction

    // Accumulate positive values
    reg signed [17+`LFSR_LEN:0] acc_full_reg;
    reg signed [17+`LFSR_LEN:0] acc_full;
    always @*
        if(dec_var[17] == 1'b0)
            acc_full = acc_full_reg + dec_var;
        else
            acc_full = acc_full_reg + {-dec_var};

    always @(posedge clk or posedge reset)
        if(reset)
            acc_full_reg = 0;
        else if(clear)
            acc_full_reg = 0;
        else if(clk_en)
            acc_full_reg = acc_full;

    // Generate the average value and power output
    always @(posedge clk or posedge reset)
        if(reset)
            ref_level = 18'd0;
        else if(clk_en)
            if(hold)
                    ref_level = acc_full_reg >>> `LFSR_LEN;
            else
                ref_level = ref_level;

    // NOTE Perhaps this should be pipelined but this is a problem for future me
    reg signed [35:0] sq_ref_level;
    always @ *
        sq_ref_level = ref_level*ref_level; // 2s34

    reg signed [17:0] trim_sq_ref_level;
    always @ *
        trim_sq_ref_level = sq_ref_level[34:17]; // 1s17

    reg signed [35:0] mult_out;
    always @ *
        mult_out = trim_sq_ref_level * `REF_POWER; // 3s33

    always @ *
        avg_power = mult_out[33:16]; // 1s17

endmodule
`endif
