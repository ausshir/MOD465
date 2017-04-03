`ifndef _TOTAL_PATH_V_
`define _TOTAL_PATH_V_

`timescale 1ns/1ns

`include "../../design/defines.vh"
`define LFSR_LEN 16'd8

`include "../../design/clk_gen.v"
`include "../../design/lfsr_gen_max.v"
`include "../../design/mapper_16_qam_ref.v"
`include "../../design/upsampler_4.v"
`include "../../design/upsampler_2.v"

`include "../../design/config_sam_delay_prac.v"
`include "../../design/config_sam_delay.v"
`include "../../design/config_sym_delay.v"
`include "../../design/config_data_delay.v"
`include "../../design/downsampler_4.v"
`include "../../design/slicer_4_ask.v"
`include "../../design/ref_level_gen.v"
`include "../../design/mapper_4_ask_ref.v"

`include "../../design/srrc_gold_rx_flt.v"
`include "../../design/srrc_gold_tx_flt.v"
`include "../../design/srrc_prac_tx_flt.v"
`include "../../design/srrc_prac_hb_flt.v"

`include "../../design/err_sq_gen.v"
`include "../../design/err_dc_gen.v"

`include "../../design/tx_modules.v"
`include "../../design/rx_perf_modules.v"
`include "../../design/sync_modules.v"


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
    wire sys_clk, sam_clk, sym_clk, sam_clk_en, sym_clk_en, hb_clk_en;
    wire [3:0] phase;
    clk_gen clocks_tb(.clk_in(clk_tb),
                      .reset(reset),
                      .sys_clk(sys_clk),
                      .sam_clk(sam_clk),
                      .sym_clk(sym_clk),
                      .sam_clk_ena(sam_clk_en),
                      .sym_clk_ena(sym_clk_en),
                      .hb_clk_ena(hb_clk_en),
                      .clk_phase(phase));

    wire [3:0] tx_data;
    wire [21:0] seq_out;
    wire cycle_out_once, cycle_out_periodic, cycle_out_periodic_ahead, cycle_out_periodic_behind;
    wire [`LFSR_LEN-1:0] lfsr_counter;
    lfsr_gen_max lfsr_tb(.clk(sys_clk),
                         .reset(reset),
                         .sam_clk_en(sam_clk_en),
                         .sym_clk_en(sym_clk_en),
                         .seq_out(seq_out),
                         .sym_out(tx_data),
                         .cycle_out_once(cycle_out_once),
                         .cycle_out_periodic(cycle_out_periodic),
                         .cycle_out_periodic_ahead(cycle_out_periodic_ahead),
                         .cycle_out_periodic_behind(cycle_out_periodic_behind),
                         .lfsr_counter(lfsr_counter));

    // TX Modules
    wire signed [17:0] tx_chan_inph, tx_sig_inph;
    tx_modules tx_inph(.sys_clk(sys_clk),
                       .sam_clk_en(sam_clk_en),
                       .sym_clk_en(sym_clk_en),
                       .hb_clk_en(hb_clk_en),
                       .reset(reset),
                       .tx_data(tx_data[1:0]),
                       .tx_sig(tx_sig_inph),
                       .tx_channel(tx_chan_inph));

    // Channel and RX Filters
    wire signed [17:0] rx_up_inph;
    srrc_gold_rx_flt gold_rx_tb(.clk(sys_clk),
                                .sam_clk_en(sam_clk_en),
                                .sym_clk_en(sym_clk_en),
                                .reset(reset),
                                .in(tx_chan_inph),
                                .out(rx_up_inph));

    // Synchronization
    wire signed [17:0] rx_up_sync_inph;
    wire signed [17:0] tx_sig_delay_inph;
    wire [1:0] tx_data_delay_inph;

    sync_modules sync_inph(.sys_clk(sys_clk),
                           .sam_clk_en(sam_clk_en),
                           .sym_clk_en(sym_clk_en),
                           .reset(reset),
                           .rx_in(rx_up_inph),
                           .rx_sync(rx_up_sync_inph),
                           .tx_in(tx_sig_inph),
                           .tx_delay(tx_sig_delay_inph),
                           .data_in(tx_data[1:0]),
                           .data_delay(tx_data_delay_inph));


    // RX Modules
    wire [3:0] rx_data;
    wire signed [17:0] acc_sq_err_inph, acc_dc_err_inph, ref_level_inph, avg_power_inph;
    wire signed [17+17+`LFSR_LEN:0] acc_sq_err_full_inph;
    rx_perf_modules rx_inph(.sys_clk(sys_clk),
                            .sam_clk_en(sam_clk_en),
                            .sym_clk_en(sym_clk_en),
                            .reset(reset),
                            .cycle_periodic(cycle_out_periodic),
                            .cycle_periodic_behind(cycle_out_periodic_behind),
                            .rx_channel_sync(rx_up_sync_inph),
                            .rx_data(rx_data[1:0]),
                            .ref_level(ref_level_inph),
                            .avg_power(avg_power_inph),
                            .acc_sq_err_dec(acc_sq_err_inph),
                            .acc_sq_err_full(acc_sq_err_full_inph),
                            .acc_dc_err(acc_dc_err_inph));

endmodule
`endif
