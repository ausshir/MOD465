`ifndef _ERR_DC_GEN_V_
`define _ERR_DC_GEN_V_

// Square accumulated error

`ifndef _DEFINES_VH
    `include "defines.vh"
`endif

// NOTE: To understand these outputs, we are summing all numbers
//  However, we must truncate `LFSR_LEN bits
//  In the end we must hand calculate (SUM)/(2^`LFSR_LEN)

module err_dc_gen(input clk,
                  input clk_en,
                  input reset, // to clear accumulators
                  input hold,
                  input clear,
                  input signed [17:0] err,
                  output reg signed [17:0] acc_dc_err_out,
                  output signed [17+`LFSR_LEN:0] acc_out_full);

    reg signed [17+`LFSR_LEN:0] dc_err;
    reg signed [17+`LFSR_LEN:0] dc_err_acc;
    always @*
        dc_err_acc = dc_err + err;

    always@(posedge clk or posedge reset)
        if(reset)
            dc_err = 0;
        else if(clear)
            dc_err = 0;
        else if(clk_en)
            dc_err = dc_err_acc;

    // Note that HOLD comes out slightly before clk_en
    always @(posedge clk or posedge reset)
        if(reset)
            acc_dc_err_out = 0;
        else if(clk_en && hold)
            acc_dc_err_out = dc_err[17+`LFSR_LEN:`LFSR_LEN];
        else
            acc_dc_err_out = acc_dc_err_out;

    assign acc_out_full = dc_err;

endmodule
`endif
