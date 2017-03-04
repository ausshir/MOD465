`ifndef _CLK_TB_V_
`define _CLK_TB_V_

`timescale 1ns/1ns

`include "../../design/clk_gen.v"
`include "../../design/lfsr_gen_max.v"
`include "../../design/mapper_16_qam.v"
`include "../../design/upsampler_4.v"
`include "../../design/srrc_gold_tx_flt.v"
`include "../../design/srrc_gold_rx_flt.v"

`include "../../design/defines.vh"

`define SIMULATION

module tx_signal_path_tb();

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

    wire clk_25, clk_625, clk_15625, clk_625_en, clk_15625_en;
    wire [3:0] phase;

    wire [3:0] sym_out;
    wire [21:0] seq_out;
    wire [17:0] in_phs_sig;
    wire [17:0] quad_sig;
    wire [17:0] upsampled_sig;
    reg [17:0] upsampled_sig_out;
    wire cycle_out, cycle_out_periodic, cycle_out_periodic_ahead, cycle_out_periodic_behind;
    wire [`LFSR_LEN-1:0] lfsr_counter;

    wire signed [17:0] channel;

    always @(posedge clk_25)
        if(clk_625_en)
            upsampled_sig_out = upsampled_sig;

    // Instantiate SUT
    clk_gen clocks(clk_tb, reset, clk_25, clk_625, clk_15625, clk_625_en, clk_15625_en, phase);
    lfsr_gen_max lfsr(clk_25, clk_15625_en, reset, seq_out, sym_out, cycle_out, cycle_out_periodic, cycle_out_periodic_ahead, cycle_out_periodic_behind, lfsr_counter);
    mapper_16_qam mapper(clk_25, clk_15625_en, sym_out, in_phs_sig, quad_sig);
    upsampler_4 upsampler(clk_25, clk_625_en, clk_15625_en, phase[3:2], reset, in_phs_sig, upsampled_sig);
    srrc_gold_rx_flt filter(clk_25, clk_tb, clk_625_en, clk_15625_en, reset, upsampled_sig_out, channel);

endmodule
`endif
