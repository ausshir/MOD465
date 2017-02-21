`ifndef _ERR_SQ_GEN_V_
`define _ERR_SQ_GEN_V_

// Square accumulated error

`include "defines.vh"

module err_sq_gen(input clk,
                  input clk_en,
                  input reset, // to clear accumulators
                  input hold,
                  input signed [17:0] err,
                  output reg signed [17:0] acc_sq_err_out);

    reg signed [35:0] sq_err;
    always @*
        sq_err = err*err; // In 2s34 Format

    reg signed [17:0] tr_sq_err;
    always @*
        tr_sq_err = sq_err[34:17]; // In 1s17 Format

    reg signed [17+`LFSR_LEN:0] sum_sq_err;
    reg signed [17+`LFSR_LEN:0] sum_sq_err_del;
    always @*
        sum_sq_err = sum_sq_err_del + tr_sq_err;

    always @(posedge clk or posedge reset)
        if(reset)
            sum_sq_err_del = 0;
        else if(hold)
            sum_sq_err_del = 0;
        else if(clk_en)
            sum_sq_err_del = sum_sq_err;

    always @(posedge clk or posedge reset)
        if(reset)
            acc_sq_err_out = 0;
        else if(clk_en)
            acc_sq_err_out = sum_sq_err_del[17+`LFSR_LEN:`LFSR_LEN];

endmodule
`endif
