`ifndef _ERR_SQ_GEN_V_
`define _ERR_SQ_GEN_V_

// Square accumulated error

`ifndef _DEFINES_VH
    `include "defines.vh"
`endif


// NOTE: To understand these outputs, we are summing the square of all numbers
//  However, we must truncate 17 bits then `LFSR_LEN bits
//  In the end we must hand calculate (SUM/2^17)/(2^`LFSR_LEN)

module err_sq_gen(input clk,
                  input clk_en,
                  input reset, // to clear accumulators
                  input hold,
                  input clear,
                  input signed [17:0] err,
                  output reg signed [17:0] acc_sq_err_dec,
                  output reg signed [17+17+`LFSR_LEN:0] acc_sq_err_full);

    reg signed [35:0] sq_err;
    always @*
        sq_err = err*err; // In 2s34 Format

    reg signed [34:0] tr_sq_err;
    always @*
        tr_sq_err = sq_err[34:0]; // In 1s34 Format

    reg signed [17+17+`LFSR_LEN:0] sum_sq_err;
    reg signed [17+17+`LFSR_LEN:0] sum_sq_err_acc;
    always @*
        sum_sq_err_acc = sum_sq_err + tr_sq_err; // In 23s34 Format

    always @(posedge clk or posedge reset)
        if(reset)
            sum_sq_err = 0;
        else if(clear)
            sum_sq_err = 0;
        else if(clk_en)
            sum_sq_err = sum_sq_err_acc;

    always @(posedge clk or posedge reset)
        if(reset)
            acc_sq_err_dec = 0;
        else if(clk_en && hold)
            acc_sq_err_dec = sum_sq_err[17+17+`LFSR_LEN:17+`LFSR_LEN]; //grab top 17 bits in 18s0 or 17u0 format
        else
            acc_sq_err_dec = acc_sq_err_dec;

    always @(posedge clk or posedge reset)
        if(reset)
            acc_sq_err_full = 0;
        else if(clk_en && hold)
            acc_sq_err_full = sum_sq_err; //Grab all data in a variable format with at least 17 integer bits and the rest fractional
        else
            acc_sq_err_full = acc_sq_err_full;

endmodule
`endif
