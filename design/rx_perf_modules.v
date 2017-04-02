`ifndef _RX_PERF_MODULES_V_
`define _RX_PERF_MODULES_V_

`ifndef _DEFINES_VH
    `include "defines.vh"
`endif

module rx_perf_modules(input sys_clk,
                       input sam_clk_en,
                       input sym_clk_en,
                       input reset,
                       input cycle_periodic,
                       input cycle_periodic_behind,
                       input signed [17:0] rx_channel_sync,
                       output [1:0] rx_data,
                       output signed [17:0] ref_level,
                       output signed [17:0] avg_power,
                       output signed [17:0] acc_err_sq,
                       output signed [17:0] acc_err_dc);

    (*keep*) wire signed [17:0] rx_down;
    downsampler_4 downsample(.clk(sys_clk),
                              .sym_clk_en(sym_clk_en),
                              .reset(reset),
                              .in(rx_channel_sync),
                              .out(rx_down));

    // Data Decoding
    (*keep*) wire signed [17:0] rx_ref_level, rx_avg_power;
    ref_level_gen ref_level_rx(.clk(sys_clk),
                               .clk_en(sym_clk_en),
                               .reset(reset),
                               .hold(cycle_periodic),
                               .clear(cycle_periodic_behind),
                               .dec_var(rx_down),
                               .ref_level(ref_level),
                               .avg_power(avg_power));

    slicer_4_ask slicer(.clk(sys_clk),
                         .clk_en(sym_clk_en),
                         .in(rx_down),
                         .ref_level(ref_level),
                         .sym_out(rx_data));

    (*keep*) wire signed [17:0] rx_remapped;
    (*keep*) wire signed [17:0] symbol_p2, symbol_p1, symbol_n1, symbol_n2;
    mapper_4_ask_ref mapper_rx(.clk(sys_clk),
                                .clk_en(sym_clk_en),
                                .data(rx_data),
                                .ref_level(ref_level),
                                .sig_out(rx_remapped),
                                .SYMBOL_P2(symbol_p2),
                                .SYMBOL_P1(symbol_p1),
                                .SYMBOL_N1(symbol_n1),
                                .SYMBOL_N2(symbol_n2));

    reg signed [17:0] err_diff;
    // Performance Evaluation
    always @*
        err_diff = rx_down - rx_remapped;

    (*keep*) wire signed [17+17+`LFSR_LEN:0] acc_out_full_sq;
    err_sq_gen err_sq(.clk(sys_clk),
                       .clk_en(sym_clk_en),
                       .reset(reset),
                       .hold(cycle_periodic),
                       .err(err_diff),
                       .acc_sq_err_out(acc_err_sq),
                       .acc_out_full(acc_out_full_sq));

    (*keep*) wire [`LFSR_LEN + 17:0] acc_out_full_dc;
    err_dc_gen err_dc_gen(.clk(sys_clk),
                           .clk_en(sym_clk_en),
                           .reset(reset),
                           .hold(cycle_periodic),
                           .err(err_diff),
                           .acc_dc_err_out(acc_err_dc),
                           .acc_out_full(acc_out_full_dc));

endmodule
`endif
