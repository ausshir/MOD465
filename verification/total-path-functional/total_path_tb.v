`ifndef _TOTAL_PATH_V_
`define _TOTAL_PATH_V_

`timescale 1ns/1ns

`include "../../design/defines.vh"
`define LFSR_LEN 16'd6

`include "../../design/clk_gen.v"
`include "../../design/lfsr_gen_max.v"
`include "../../design/mapper_16_qam_ref.v"
`include "../../design/upsampler_4.v"
`include "../../design/srrc_gold_rx_flt.v"
`include "../../design/srrc_prac_tx_flt.v"

`include "../../design/config_sam_delay.v"
`include "../../design/config_sym_delay.v"
`include "../../design/config_data_delay.v"
`include "../../design/downsampler_4.v"
`include "../../design/slicer_4_ask.v"
`include "../../design/ref_level_gen.v"
`include "../../design/mapper_4_ask_ref.v"

`include "../../design/err_sq_gen.v"
`include "../../design/err_dc_gen.v"

`define SIMULATION

module total_path_tb();

    // Clock Generation @ 10ns/50MHz
    reg clk_tb;
    initial begin: CLK_GEN
        clk_tb = 0;
        forever begin
            #10 clk_tb = ~clk_tb;
        end
    end

    // Reset Generation @ 500ns
    reg reset;
    initial begin: SYS_RESET
        reset = 0;
        #500 reset = 1;
        #100 reset = 0;
    end

    // System
    wire sys_clk, sam_clk, sym_clk, sam_clk_en, sym_clk_en;
    wire [3:0] phase;
    clk_gen clocks_tb(.clk_in(clk_tb),
                      .reset(reset),
                      .sys_clk(sys_clk),
                      .sam_clk(sam_clk),
                      .sym_clk(sym_clk),
                      .sam_clk_ena(sam_clk_en),
                      .sym_clk_ena(sym_clk_en),
                      .clk_phase(phase));

    wire [3:0] tx_data;
    wire [21:0] seq_out;
    wire cycle_out_once, cycle_out_periodic, cycle_out_periodic_ahead, cycle_out_periodic_behind;
    wire [`LFSR_LEN-1:0] lfsr_counter;
    lfsr_gen_max lfsr_tb(.clk(sys_clk),
                         .reset(reset),
                         .clk_en(sym_clk_en),
                         .seq_out(seq_out),
                         .sym_out(tx_data),
                         .cycle_out_once(cycle_out_once),
                         .cycle_out_periodic(cycle_out_periodic),
                         .cycle_out_periodic_ahead(cycle_out_periodic_ahead),
                         .cycle_out_periodic_behind(cycle_out_periodic_behind),
                         .lfsr_counter(lfsr_counter));

    // TX Modules
    wire signed [17:0] tx_sig_inphase, tx_sig_quadrature;
    mapper_16_qam_ref mapper_tx_tb(.clk(sys_clk),
                                   .clk_en(sam_clk_en),
                                   .data(tx_data),
                                   .ref_level(`SYMBOL_REF),
                                   .sig_inph(tx_sig_inphase),
                                   .sig_quad(tx_sig_quadrature));

    wire signed [17:0] tx_up_inphase;
    upsampler_4 upsampler_tx_tb(.clk(sys_clk),
                                .sam_clk_en(sam_clk_en),
                                .sym_clk_en(sym_clk_en),
                                .reset(reset),
                                .phase4(phase[3:2]),
                                .data_in(tx_sig_inphase),
                                .data_out(tx_up_inphase));

    // SIGNAL CHAIN - Matched Filters

    wire signed [17:0] tx_chan_inphase;
    srrc_prac_tx_flt gold_tx_tb(.clk(sys_clk),
                                .sam_clk_en(sam_clk_en),
                                .sym_clk_en(sym_clk_en),
                                .reset(reset),
                                .in(tx_up_inphase[17:0]),
                                .out(tx_chan_inphase));

    wire signed [17:0] rx_up_inphase;
    srrc_gold_rx_flt gold_rx_tb(.clk(sys_clk),
                                .sam_clk_en(sam_clk_en),
                                .sym_clk_en(sym_clk_en),
                                .reset(reset),
                                .in(tx_chan_inphase),
                                .out(rx_up_inphase));

    // RX Modules
    wire signed [17:0] rx_up_sync_inphase;
    config_sam_delay config_sam_del_tb(.clk(sys_clk),
                                       .sam_clk_en(sam_clk_en),
                                       .sym_clk_en(sym_clk_en),
                                       .reset(reset),
                                       .delay(2'd1),
                                       .in(rx_up_inphase),
                                       .out(rx_up_sync_inphase));

    wire signed [17:0] tx_sig_sync_inphase;
    config_sym_delay config_sym_del_tb(.clk(sys_clk),
                                      .sam_clk_en(sam_clk_en),
                                      .sym_clk_en(sym_clk_en),
                                      .reset(reset),
                                      .delay(8'd38),
                                      .in(tx_sig_inphase),
                                      .out(tx_sig_sync_inphase));

    wire [1:0] tx_data_delay;
    config_data_delay config_data_del_tb(.clk(sys_clk),
                                         .sam_clk_en(sam_clk_en),
                                         .sym_clk_en(sym_clk_en),
                                         .reset(reset),
                                         .delay(8'd52),
                                         .in(tx_data[1:0]),
                                         .out(tx_data_delay));

    wire signed [17:0] rx_inphase;
    downsampler_4 downsample_tb(.clk(sys_clk),
                                .sym_clk_en(sym_clk_en),
                                .reset(reset),
                                .in(rx_up_sync_inphase),
                                .out(rx_inphase));



    // Data Decoding
    wire signed [17:0] rx_ref_level, rx_avg_power;
    ref_level_gen ref_level_rx_tb(.clk(sys_clk),
                               .clk_en(sym_clk_en),
                               .reset(reset),
                               .hold(cycle_out_periodic),
                               .clear(cycle_out_periodic_behind),
                               .dec_var(rx_inphase),
                               .ref_level(rx_ref_level),
                               .avg_power(rx_avg_power));

    wire [1:0] rx_data;
    slicer_4_ask slicer_tb(.clk(sys_clk),
                           .clk_en(sym_clk_en),
                           .in(rx_inphase),
                           .ref_level(rx_ref_level),
                           .sym_out(rx_data));

    wire signed [17:0] rx_sig_mapped;
    wire signed [17:0] symbol_p2, symbol_p1, symbol_n1, symbol_n2;
    mapper_4_ask_ref mapper_rx_tb(.clk(sys_clk),
                                  .clk_en(sym_clk_en),
                                  .data(rx_data),
                                  .ref_level(rx_ref_level),
                                  .sig_out(rx_sig_mapped),
                                  .SYMBOL_P2(symbol_p2),
                                  .SYMBOL_P1(symbol_p1),
                                  .SYMBOL_N1(symbol_n1),
                                  .SYMBOL_N2(symbol_n2));

    // Performance Evaluation
    reg signed [17:0] err_diff;
    always @*
        err_diff = rx_inphase - rx_sig_mapped;

    wire signed [17:0] acc_sq_err_out;
    wire signed [17+`LFSR_LEN:0] acc_out_full;
    err_sq_gen err_sq_tb(.clk(sys_clk),
                         .clk_en(sym_clk_en),
                         .reset(reset),
                         .hold(cycle_out_periodic),
                         .err(err_diff),
                         .acc_sq_err_out(acc_sq_err_out),
                         .acc_out_full(acc_out_full));

    wire [17:0] acc_dc_err_out_inphase;
    wire [`LFSR_LEN + 17:0] acc_out_full_dc_inphase;
    err_dc_gen err_dc_gen_tb(.clk(sys_clk),
                             .clk_en(sym_clk_en),
                             .reset(reset),
                             .hold(cycle_out_periodic),
                             .err(err_diff),
                             .acc_dc_err_out(acc_dc_err_out_inphase),
                             .acc_out_full(acc_out_full_dc_inphase));

endmodule
`endif
