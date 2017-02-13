`ifndef _ERR_DC_GEN_V_
`define _ERR_DC_GEN_V_

// Square accumulated error

module err_dc_gen(input clk,
                  input clk_en,
                  input reset, // to clear accumulators
                  input signed [17:0] err,
                  output signed [38:0] acc_dc_err_out);

    parameter LFSR_LEN = 22;

    reg [17+LFSR_LEN:0] acc_dc_err;
    always @(posedge clk, reset)
        if(reset)
            acc_dc_err = {{18 + LFSR_LENGTH}{1'b0}};
        else if(clk_en)
            acc_dc_err = acc_dc_err + err;

    always @(posedge clk, reset)
        if(reset)
            acc_sq_err_out = 39'd0;
        else if(clk_en)
            acc_dc_err_out = acc_dc_err[38:0];

endmodule
`endif
