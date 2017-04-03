`ifndef _TX_MODULES_V_
`define _TX_MODULES_V_

`ifndef _DEFINES_VH
    `include "defines.vh"
`endif

module tx_modules(input sys_clk,
                  input sam_clk_en,
                  input sym_clk_en,
                  input hb_clk_en,
                  input reset,
                  input [1:0] tx_data,
                  output signed [17:0] tx_sig,
                  output reg signed [17:0] tx_channel
                  );

    wire signed [17:0] symbol_p2, symbol_p1, symbol_n1, symbol_n2;
    mapper_4_ask_ref mapper_tx(.clk(sys_clk),
                                 .clk_en(sym_clk_en),
                                 .data(tx_data),
                                 .ref_level(`SYMBOL_REF),
                                 .sig_out(tx_sig),
                                 .SYMBOL_P2(symbol_p2),
                                 .SYMBOL_P1(symbol_p1),
                                 .SYMBOL_N1(symbol_n1),
                                 .SYMBOL_N2(symbol_n2));

    wire signed [17:0] tx_up;
    upsampler_4 upsampler_tx(.clk(sys_clk),
                             .sam_clk_en(sam_clk_en),
                             .sym_clk_en(sym_clk_en),
                             .reset(reset),
                             .data_in(tx_sig),
                             .data_out(tx_up));

    wire signed [17:0] tx_srrc;
    srrc_prac_tx_flt flt_tx(.clk(sys_clk),
                            .sam_clk_en(sam_clk_en),
                            .sym_clk_en(sym_clk_en),
                            .reset(reset),
                            .in(tx_up),
                            .out(tx_srrc));

    wire signed [17:0] tx_up_hba, tx_up_hbb;
    upsampler_2 upsampler_hba_tx(.clk(sys_clk),
                                 .hb_clk_en(hb_clk_en),
                                 .reset(reset),
                                 .data_in(tx_srrc),
                                 .data_out(tx_up_hba));

    wire signed [17:0] tx_hb_hba, tx_hb_hbb;
    srrc_prac_hb_flt flt_hba(.clk(sys_clk),
                             .hb_clk_en(hb_clk_en),
                             .reset(reset),
                             .in(tx_up_hba),
                             .out(tx_hb_hba));

    upsampler_2 upsampler_hbb_tx(.clk(sys_clk),
                                 .hb_clk_en(sys_clk),
                                 .reset(reset),
                                 .data_in(tx_hb_hba),
                                 .data_out(tx_up_hbb));

    srrc_prac_hb_flt flt_hbb(.clk(sys_clk),
                             .hb_clk_en(sys_clk),
                             .reset(reset),
                             .in(tx_up_hbb),
                             .out(tx_hb_hbb));

    always @*
        tx_channel = tx_srrc;

endmodule
`endif
