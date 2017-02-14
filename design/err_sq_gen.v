`ifndef _ERR_SQ_GEN_V_
`define _ERR_SQ_GEN_V_

// Square accumulated error

`include "defines.vh"

module err_sq_gen(input clk,
                  input clk_en,
                  input reset, // to clear accumulators
                  input signed [17:0] err,
                  output reg signed [38:0] acc_sq_err_out);

    reg [17:0] sq_err;
    always @(posedge clk or posedge reset)
        if(reset)
            sq_err = 18'd0;
        else if(clk_en)
            sq_err = (err * err);

    reg [17+`LFSR_LEN:0] acc_sq_err;
    always @(posedge clk or posedge reset)
        if(reset)
            acc_sq_err = {{18 + `LFSR_LEN}{1'b0}};
        else if(clk_en)
            acc_sq_err = acc_sq_err + sq_err;

    always @(posedge clk or posedge reset)
        if(reset)
            acc_sq_err_out = 39'd0;
        else if(clk_en)
            acc_sq_err_out = acc_sq_err[38:0];

endmodule
`endif
