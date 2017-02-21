`ifndef _ERR_SQ_GEN_V_
`define _ERR_SQ_GEN_V_

// Square accumulated error

`include "defines.vh"

module err_sq_gen(input clk,
                  input clk_en,
                  input reset, // to clear accumulators
                  input hold,
                  input signed [17:0] err,
                  output reg signed [17+`LFSR_LEN:0] acc_sq_err_out);

    // Function to truncate numbers cleanly :)
    function [17:0] trunc_36_to_18(input [35:0] val36);
      trunc_36_to_18 = val36[34:17];
    endfunction

    reg [17:0] sq_err;
    always @(posedge clk or posedge reset)
        if(reset)
            sq_err = 18'd0;
        else if(clk_en)
            sq_err = trunc_36_to_18(err * err);

    reg [17+`LFSR_LEN:0] acc_sq_err;
    always @(posedge clk or posedge reset)
        if(reset)
            acc_sq_err = 0;
        else if(hold)
            acc_sq_err = acc_sq_err;
        else if(clk_en)
            acc_sq_err = acc_sq_err + sq_err;

    always @(posedge clk or posedge reset)
        if(reset)
            acc_sq_err_out = 0;
        else if(clk_en)
            acc_sq_err_out = acc_sq_err[17+`LFSR_LEN:0];

endmodule
`endif
