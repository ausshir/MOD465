`ifndef _ERR_SQ_GEN_V_
`define _ERR_SQ_GEN_V_

// Square accumulated error

`include "defines.vh"

// NOTE: To understand these outputs, we are summing the square of all numbers
//  However, we must truncate 17 bits then `LFSR_LEN bits
//  In the end we must hand calculate (SUM/2^17)/(2^`LFSR_LEN)

module err_sq_gen(input clk,
                  input clk_en,
                  input reset, // to clear accumulators
                  input hold,
                  input signed [17:0] err,
                  output reg signed [17:0] acc_sq_err_out,
                  output signed [17+`LFSR_LEN:0] acc_out_full);

    reg signed [35:0] sq_err;
    always @*
        sq_err = err*err; // In 2s34 Format

    reg signed [17:0] tr_sq_err;
    always @*
        tr_sq_err = sq_err[34:17]; // In 1s17 Format

    reg signed [17+`LFSR_LEN:0] sum_sq_err;
    reg signed [17+`LFSR_LEN:0] sum_sq_err_acc;
    always @*
        sum_sq_err_acc = sum_sq_err + tr_sq_err;

    always @(posedge clk or posedge reset)
        if(reset)
            sum_sq_err = 0;
        else if(clk_en && hold)
            sum_sq_err = 0;
        else if(clk_en)
            sum_sq_err = sum_sq_err_acc;

    // Note that HOLD comes out slightly before clk_en
    always @(posedge clk or posedge reset)
        if(reset)
            acc_sq_err_out = 0;
        else if(clk_en)
            acc_sq_err_out = sum_sq_err[17+`LFSR_LEN:`LFSR_LEN];

    assign acc_out_full = sum_sq_err;

endmodule
`endif
