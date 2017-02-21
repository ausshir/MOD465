`ifndef _ERR_DC_GEN_V_
`define _ERR_DC_GEN_V_

// Square accumulated error

`include "defines.vh"

module err_dc_gen(input clk,
                  input clk_en,
                  input reset, // to clear accumulators
                  input hold,
                  input signed [17:0] err,
                  output reg signed [17:0] acc_dc_err_out);

    //reg signed [17+`LFSR_LEN:0] dc_err;
    //always @*
    //    dc_err = dc_err_del + err;

    reg signed [17+`LFSR_LEN:0] dc_err_del;
    always@(posedge clk or posedge reset)
        if(reset)
            dc_err_del = 0;
        else if(hold)
            dc_err_del = 0;
        else if(clk_en)
            dc_err_del = dc_err_del + err;

    always @(posedge clk or posedge reset)
        if(reset)
            acc_dc_err_out = 0;
        else if(clk_en)
            acc_dc_err_out = dc_err_del[17+`LFSR_LEN:`LFSR_LEN];

endmodule
`endif
